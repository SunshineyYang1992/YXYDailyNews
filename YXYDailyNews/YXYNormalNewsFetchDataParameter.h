//
//  YXYNormalNewsFetchDataParameter.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXYNormalNewsFetchDataParameter : NSObject

@property (nonatomic, assign)NSInteger recentTime;
@property (nonatomic, assign)NSInteger remoteTime;

@property (nonatomic, copy)NSString *channelId;
@property (nonatomic, copy)NSString *channelName;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger page;


@end
