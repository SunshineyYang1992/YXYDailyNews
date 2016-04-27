//
//  UIImageView+Extension.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

-(void)setImageWithURL:(NSURL *)url;

-(void)setImageWithURL:(NSURL *)url
	  placeHolderImage:(UIImage *)placeHolder
			 completed:(void (^)(UIImage *image, NSError *error))complete;

-(void)setImageWithURL:(NSURL *)url
	  placeHolderImage:(UIImage *)placeHolder
			   options:(NSInteger)options
			  progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
			 completed:(void (^)(UIImage *image, NSError *error))complete;

-(void)setIMageAfterClickURL:(NSURL *)url;

@end
