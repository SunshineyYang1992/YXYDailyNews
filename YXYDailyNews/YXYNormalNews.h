//
//  YXYNormalNews.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YXYNormalNews : NSObject

typedef NS_ENUM(NSUInteger, NormalNewsType) {
	
	NormalNewsTypeNoPic = 1,
	NormalNewsTypeSinglePic = 2,
	NormalNewsTypeMutiPic = 3 // more than 3
};

@property (nonatomic, copy)NSString *channelId;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, strong)NSArray *imgUrls;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *publishDate;
@property (nonatomic, copy)NSString *src;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger allPages;

@property (nonatomic,assign)NormalNewsType normalNewsType;
@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, assign)CGFloat cellHeight;


@end
