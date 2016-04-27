//
//  NoPicNewsTableViewCell.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "NoPicNewsTableViewCell.h"

@interface NoPicNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIView *seperateLine;

@end

@implementation NoPicNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
	self.commentLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText {
	_titleText = titleText;
	self.titleLabel.text = titleText;
}
- (void)setContentText:(NSString *)contentText {
	_contentText = contentText;
	self.contentLabel.text = contentText;
}


@end
