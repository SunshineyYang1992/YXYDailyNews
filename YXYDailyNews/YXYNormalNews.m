//
//  YXYNormalNews.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "YXYNormalNews.h"

@implementation YXYNormalNews

- (void)setPublishDate:(NSString *)publishDate {
	
	_publishDate = publishDate;
	_createTime = [[[publishDate stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
}

- (void)setImgUrls:(NSArray *)imgUrls {
	_imgUrls = imgUrls;
	
	CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat horizontalMargin = 10;
	CGFloat verticalMargin = 15;
	CGFloat controlMargin = 5;
	CGFloat titleLabelHeight = 19.5;
	CGFloat detailLabelHeight = 31;
	CGFloat commentLabelHeight = 13.5;
	
	if (imgUrls.count >= 3) {
		self.normalNewsType = NormalNewsTypeMutiPic;

		self.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
	}else if (imgUrls.count == 0) {
		self.normalNewsType = NormalNewsTypeNoPic;
		self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + detailLabelHeight + controlMargin + commentLabelHeight + controlMargin;
	}else {
		self.normalNewsType = NormalNewsTypeSinglePic;
		self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + detailLabelHeight + controlMargin + commentLabelHeight + controlMargin;
	}
}

@end
