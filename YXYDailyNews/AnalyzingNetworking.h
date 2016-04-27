//
//  AnalyzingNetworking.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyzingNetworking : NSObject

typedef NS_ENUM(NSUInteger, NetworkingType) {
	NetworkingTypeNoReachable = 1,
	NetworkingType3G = 2,
	NetworkingTypeWifi = 3
};

+ (BOOL)analyze;
+ (NetworkingType)currentNetworkingType;


@end
