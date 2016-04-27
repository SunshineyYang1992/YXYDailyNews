//
//  ChannelCollectionViewCell.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "ChannelCollectionViewCell.h"

@interface ChannelCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end

@implementation ChannelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
	self.deleteButton.hidden = YES;
	
}

- (void)setChannelName:(NSString *)channelName {
	_channelName = channelName;
	self.channelTitle.text = channelName;
}

- (void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
	UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteButton)];
	recognizer.minimumPressDuration = 0.5;
	[self addGestureRecognizer:recognizer];
	_cellIndexPath = cellIndexPath;
	
}
- (void)showDeleteButton {
	self.deleteButton.hidden = NO;
}
- (IBAction)deleteChannel:(id)sender {
	if ([self.delegate respondsToSelector:@selector(deleteChannelCellAtIndexPath:)]) {
		[self.delegate deleteChannelCellAtIndexPath:self.cellIndexPath];
	}
	self.deleteButton.hidden = YES;
}


@end
