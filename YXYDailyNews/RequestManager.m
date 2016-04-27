//
//  RequestManager.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "RequestManager.h"
#import "YXYHeaderNews.h"
#import "YXYNormalNews.h"
#import "YXYNormalNewsFetchDataParameter.h"

#import "AnalyzingNetworking.h"
#import "YXYConst.h"

#import <AFNetworking.h>
#import <FMDB.h>
#import <MJExtension.h>

static NSString * const apiKey = @"f2dae36d3e3f62d0889304106ee0be2f";

@implementation RequestManager

static FMDatabaseQueue *_queue;

+ (void)initialize {
	
	NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"data.sqlite"];
	NSLog(@"%@", path);
	
	_queue = [FMDatabaseQueue databaseQueueWithPath:path];
	[_queue inDatabase:^(FMDatabase *db) {
		
		//[db executeUpdate:@"create table if not exists table_video(id integer primary key autoincrement, idstr text, time integer, video blob);"];
		
		//[db executeUpdate:@"create table if not exists table_picture(id integer primary key autoincrement, idstr text, time integer, picture blob);"];
		//[db executeUpdate:@"create table if not exists table_videocomment(id integer primary key autoincrement, idstr text, page integer, hotcommentarray blob, latestcommentarray blob, total integer);"];
		[db executeUpdate:@"create table if not exists table_headernews(id integer primary key autoincrement, title text, url text, abstract text, image_url text);"];
		
		[db executeUpdate:@"create table if not exists table_normalnews(id integer primary key autoincrement, channelid text, title text, imageurls blob, desc text, link text, pubdate text, createdtime integer, source text);"];
	}];
}

#pragma mark: Normal News

+ (void)normalNewsWithParameters:(YXYNormalNewsFetchDataParameter *)normalNewsParameters sucess:(void (^)(NSMutableArray *))sucess failure:(void (^)(NSError *))failure {
	
	if (![AnalyzingNetworking analyze]) {
		YXYNormalNewsFetchDataParameter *tempParameters = [[YXYNormalNewsFetchDataParameter alloc]init];
		tempParameters.channelId = normalNewsParameters.channelId;
		
		NSMutableArray *tempCacheArray = [self selectDataFromNormalNewsCacheWithParameters:tempParameters];
		
		sucess(tempCacheArray);
		return;
	}
	NSMutableArray *cacheArray = [self selectDataFromNormalNewsCacheWithParameters:normalNewsParameters];
	
	if (cacheArray.count == 20) {
		sucess(cacheArray);
	}else {
		AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
		[manage.requestSerializer setValue:apiKey forHTTPHeaderField:@"apikey"];

		NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		parameters[@"channelId"] = normalNewsParameters.channelId;
		parameters[@"channelName"] = [normalNewsParameters.channelName stringByAppendingString:@"国内最新"];
		parameters[@"title"] = normalNewsParameters.title;
		parameters[@"page"] = @(normalNewsParameters.page);
		
		[manage GET:@"http://apis.baidu.com/showapi_open_bus/channel_news/search_news" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			
			NSMutableArray *picArray = [YXYNormalNews mj_objectArrayWithKeyValuesArray:responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"]];
			for (YXYNormalNews *news in picArray) {
				news.allPages = [responseObject[@"showapi_res_body"][@"pagebean"][@"allPages"] integerValue];
			}
			[self addNormalNewsArray:picArray];

			sucess(picArray);
			
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			NSLog(@"%@",error);
		}];
		
	}
	
}
+ (NSMutableArray *)selectDataFromNormalNewsCacheWithParameters:(YXYNormalNewsFetchDataParameter *)parameters {
	
	__block NSMutableArray *newsArray = nil;
	[_queue inDatabase:^(FMDatabase *db) {
		
		newsArray = [NSMutableArray array];
		FMResultSet *result = nil;
		if (parameters.recentTime != 0) {
			NSInteger time = parameters.recentTime;
			NSString *sqlString = [NSString stringWithFormat:@"select * from table_normalnews where createdtime > %@ and channelid = '%@' order by createdtime desc limit 0,20;",@(time),parameters.channelId];
			result = [db executeQuery:sqlString];
		}
		
		if (parameters.remoteTime != 0) {
			NSInteger time = parameters.remoteTime;
			NSString *sqlString = [NSString stringWithFormat:@"select * from table_normalnews where createdtime < %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
			result = [db executeQuery:sqlString];
		}
		
		if (parameters.remoteTime==0 && parameters.recentTime==0){
			
			NSString *sqlString = [NSString stringWithFormat:@"select * from table_normalnews where channelid = '%@' order by createdtime desc limit 0,20;", parameters.channelId];
			result = [db executeQuery:sqlString];
		}
		while (result.next) {
			YXYNormalNews *news = [[YXYNormalNews alloc]init];
			news.title = [result stringForColumn:@"title"];
			news.publishDate = [result stringForColumn:@"pubdate"];
			news.createTime = [result longLongIntForColumn:@"createdtime"];
			news.src = [result stringForColumn:@"source"];
			news.desc = [result stringForColumn:@"desc"];
			news.link = [result stringForColumn:@"link"];
			news.channelId = [result stringForColumn:@"channelid"];
			news.imgUrls = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"imageurls"]];
			[newsArray addObject:news];
			
		}
		

	}];
	return newsArray;
	
}
+ (void)addNormalNewsArray:(NSMutableArray *)newsArray {
	
	for (YXYNormalNews *news in newsArray) {
		[self addNormalNews:news];
	}
}
+ (void)addNormalNews:(YXYNormalNews *)normalNews {
	[_queue inDatabase:^(FMDatabase *db) {
		
		FMResultSet *result = nil;
		NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_normalnews WHERE link = '%@';",normalNews.link];
		result = [db executeQuery:querySql];
		if (result.next == NO) {
			NSData *imgUrls = [NSKeyedArchiver archivedDataWithRootObject:normalNews.imgUrls];
			[db executeUpdate:@"insert into table_normalnews (title, pubdate, createdtime, source, desc, link, imageurls, channelid) values(?,?,?,?,?,?,?,?);",normalNews.title,normalNews.publishDate,@(normalNews.createTime),normalNews.src,normalNews.desc,normalNews.link,imgUrls,normalNews.channelId];
			
		}
		[result close];
	}];
}

#pragma mark: Header News

+ (void)headerNewsFromServerOrCacheWithMaxHeaderNews:(YXYHeaderNews *)headerNews sucess:(void (^)(NSMutableArray *))sucess failure:(void (^)(NSError *))failure {
	
	if ([AnalyzingNetworking currentNetworkingType] == NetworkingTypeNoReachable) {
		NSMutableArray *newsArray = [self headerNewsFromCacheWithMax:headerNews];
		sucess(newsArray);
		
	}else {
		
		AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
		[manage.requestSerializer setValue:apiKey forHTTPHeaderField:@"apikey"];
		[manage GET:@"http://apis.baidu.com/songshuxiansheng/news/news" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			
			NSMutableArray *headerNewsAraay = [YXYHeaderNews mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
			
			NSArray *tempArray = [headerNewsAraay copy];
			for (YXYHeaderNews *headerNews in tempArray) {
    
				if ([headerNews.imgUrl isEqualToString:@""]) {
					[headerNewsAraay removeObject:headerNews];
				}
			}
			[self addHeaderNewsArray:[headerNewsAraay copy]];
			sucess(headerNewsAraay);
			
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			
			NSLog(@"%@",error);
		}];
	}
}

+ (NSMutableArray *)headerNewsFromCacheWithMax:(YXYHeaderNews *)headerNews {
	
	__block NSMutableArray *headerNewsArray = nil;
	[_queue inDatabase:^(FMDatabase *db) {
		
		headerNewsArray = [NSMutableArray array];
		
		FMResultSet *result = nil;
		result = [db executeQuery:@"select * from table_headernews order by id desc limit 0,5"];
		
		while (result.next) {
			YXYHeaderNews *headerNews = [[YXYHeaderNews alloc]init];
			headerNews.title = [result stringForColumn:@"title"];
			headerNews.url = [result stringForColumn:@"url"];
			headerNews.abstract = [result stringForColumn:@"abstract"];
			headerNews.imgUrl = [result stringForColumn:@"image_url"];
			[headerNewsArray addObject:headerNews];
		}
		
	}];
	return headerNewsArray;
}

+ (void)addHeaderNews:(YXYHeaderNews *)headerNews {
	[_queue inDatabase:^(FMDatabase *db) {
		
		NSString *url = headerNews.url;
		FMResultSet *result = nil;
		NSString *sqlQuery = [NSString stringWithFormat:@"select * from table_headernews where url = '%@';",url];
		result = [db executeQuery:sqlQuery];
		if (result.next == NO) {
			
			[db executeUpdate:@"insert into table_headernews (title, url, abstract, image_url) values(?,?,?,?);",headerNews.title, headerNews.url,headerNews.abstract,headerNews.imgUrl];
			
		}
		[result close];
	}];
	
}
+ (void)addHeaderNewsArray:(NSArray *)headNewsArray {
	for (YXYHeaderNews *news in headNewsArray) {
		[self addHeaderNews:news];
	}
}


#pragma  mark: Delete cache 

+ (void)deletePartOfCacheInSqlite {
	[_queue inDatabase:^(FMDatabase *db) {
		
		[db executeUpdate:@"delete from table_normalnews where id > 20"];
		[db executeUpdate:@"delete from table_headernews where id > 5"];
		
	}];
}



















@end
