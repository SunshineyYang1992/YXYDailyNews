//
//  RequestManager.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXYNormalNewsFetchDataParameter;
@class YXYHeaderNews;



@interface RequestManager : NSObject


// News

+ (void)normalNewsWithParameters:(YXYNormalNewsFetchDataParameter *)normalNewsParameters
						  sucess:(void(^)(NSMutableArray *array))sucess
						 failure:(void(^)(NSError *error))failure;

+ (void)headerNewsFromServerOrCacheWithMaxHeaderNews:(YXYHeaderNews *)headerNews
											  sucess:(void(^)(NSMutableArray *array))sucess
											 failure:(void(^)(NSError *error))failure;
+ (void)deletePartOfCacheInSqlite;


@end
