//
//  SinglePicNewsTableViewCell.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "SinglePicNewsTableViewCell.h"
#import "UIImageView+Extension.h"
@interface SinglePicNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *preview;

@end
@implementation SinglePicNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
	
	self.commentLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImgUrl:(NSString *)imgUrl {
	_imgUrl = imgUrl;
	[self.preview setImageWithURL:[NSURL URLWithString:imgUrl]];
	
}
- (void)setTitleText:(NSString *)titleText {
	_titleText = titleText;
	self.titleLabel.text = titleText;
}
- (void)setDetailText:(NSString *)detailText {
	_detailText = detailText;
	self.descriptionLabel.text = detailText;
	
}


@end
