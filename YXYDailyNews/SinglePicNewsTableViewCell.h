//
//  SinglePicNewsTableViewCell.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePicNewsTableViewCell : UITableViewCell

@property (nonatomic, strong)NSArray *pictureArray;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *titleText;
@property (nonatomic, copy)NSString *detailText;


@end
