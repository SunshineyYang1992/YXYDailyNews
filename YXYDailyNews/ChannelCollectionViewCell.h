//
//  ChannelCollectionViewCell.h
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelCollectionViewCellDelegate <NSObject>

- (void)deleteChannelCellAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface ChannelCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)NSString *channelName;
@property (nonatomic, strong)NSIndexPath *cellIndexPath;
@property (nonatomic, weak) id<ChannelCollectionViewCellDelegate> delegate;


@end
