//
//  NewsTableViewController.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXYNormalNews.h"
#import "YXYHeaderNews.h"

@interface NewsTableViewController : UITableViewController

@property (nonatomic, strong)YXYNormalNews *news;
@property (nonatomic, copy)NSString *channelId;
@property (nonatomic, copy)NSString *channelName;


@end
