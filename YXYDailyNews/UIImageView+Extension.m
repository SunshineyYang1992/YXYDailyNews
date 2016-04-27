//
//  UIImageView+Extension.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "UIImageView+Extension.h"
#import <UIImageView+WebCache.h>
#import "YXYConst.h"
#import "AnalyzingNetworking.h"


@implementation UIImageView (Extension)


-(BOOL)currentImageDownloadMode {
	
	BOOL isDownloadNoImageIn3G = [[NSUserDefaults standardUserDefaults]boolForKey:IsDownLoadNoImageIn3GKey];
	if (isDownloadNoImageIn3G == YES && [AnalyzingNetworking currentNetworkingType] != NetworkingTypeWifi) {
		return NO;
	}
	return YES;
}

- (void)setImageWithURL:(NSURL *)url {
	
	if ([self currentImageDownloadMode] == NO || url == nil) {
		self.image = [UIImage imageNamed:@"allplaceHolderImage"];
		return;
	}
	
	[self sd_setImageWithURL:url];
}
- (void)setImageWithURL:(NSURL *)url placeHolderImage:(UIImage *)placeHolder completed:(void (^)(UIImage *, NSError *))complete {
	
	if ([self currentImageDownloadMode] == NO && url == nil) {
		NSError *error = [NSError errorWithDomain:@"example.com" code:500 userInfo:nil];
		complete(placeHolder,error);
		return;
	}
	[self sd_setImageWithURL:url placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		complete(image,error);
	}];
	
}
- (void)setImageWithURL:(NSURL *)url placeHolderImage:(UIImage *)placeHolder options:(NSInteger)options progress:(void (^)(NSInteger, NSInteger))progress completed:(void (^)(UIImage *, NSError *))complete {
	
	if ([self currentImageDownloadMode] == NO && url == nil) {
		NSError *error = [NSError errorWithDomain:@"example.com" code:500 userInfo:nil];
		progress(100,100);
		complete(placeHolder,error);
		return;
	}
	
	[self sd_setImageWithURL:url placeholderImage:placeHolder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
		
		progress(receivedSize, expectedSize);
		
	} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
		complete(image, error);
		
	}];
	
}
- (void)setIMageAfterClickURL:(NSURL *)url {
	[self sd_setImageWithURL:url];
}





@end
