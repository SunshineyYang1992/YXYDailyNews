//
//  AnalyzingNetworking.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "AnalyzingNetworking.h"
#import "Reachability.h"

@implementation AnalyzingNetworking

+ (BOOL)analyze {
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
		return NO;
	}
	return YES;
}

+ (NetworkingType)currentNetworkingType {
	Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
	if ([reachability currentReachabilityStatus]==ReachableViaWiFi) {
		return NetworkingTypeWifi;
	}else if ([reachability currentReachabilityStatus] == ReachableViaWWAN) {
		return NetworkingType3G;
	}
	return NetworkingTypeNoReachable;
}



@end
