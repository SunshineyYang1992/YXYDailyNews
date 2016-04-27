//
//  MutiPicNewsTableViewCell.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/25/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "MutiPicNewsTableViewCell.h"
#import "UIImageView+Extension.h"


@interface MutiPicNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end
@implementation MutiPicNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImgUrls:(NSArray *)imgUrls {
	_imgUrls = imgUrls;
	[self.imageView1 setImageWithURL:imgUrls[0][@"url"]];
	[self.imageView2 setImageWithURL:imgUrls[1][@"url"]];
	[self.imageView3 setImageWithURL:imgUrls[2][@"url"]];
	self.commentLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
}
- (void)setTitle:(NSString *)title {
	_title = title;
	self.titleLabel.text = title;
}


@end
