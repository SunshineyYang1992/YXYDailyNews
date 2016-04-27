//
//  MutiPicViewController.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "MutiPicViewController.h"
#import "UIImageView+Extension.h"
#import "YXYConst.h"


@interface MutiPicViewController ()

@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *back;


@end

@implementation MutiPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupScrollView];
	[self setupTextView];
	[self setupBackButton];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden =YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
	[self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hidden = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateSkinModel {
	NSString  *currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
	if ([currentSkinModel isEqualToString:NightSkinModelValue]) {
		self.textView.textColor = [UIColor grayColor];
	} else {//日间模式
		self.textView.textColor = [UIColor whiteColor];
	}
}

- (void)setupScrollView {
	self.automaticallyAdjustsScrollViewInsets = NO;
	UIScrollView *scrollView = [[UIScrollView alloc]init];
	scrollView.frame = self.view.frame;
	scrollView.backgroundColor = [UIColor blackColor];
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.imgUrls.count, 0);
	scrollView.pagingEnabled = YES;
	
	for (NSInteger i = 0; i < self.imgUrls.count; i++) {
		NSDictionary *dict = self.imgUrls[i];
		UIImageView *imageView = [[UIImageView alloc]init];
		imageView.userInteractionEnabled = YES;
		[imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)]];
		imageView.frame = CGRectMake(i * scrollView.frame.size.width, 0, scrollView.frame.size.width,scrollView.frame.size.height);
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[imageView setImageWithURL:[NSURL URLWithString:dict[@"url"]]];
		[scrollView addSubview:imageView];

	}
	[self.view addSubview:scrollView];
	
	
}
- (void)setupTextView {
	
	self.textView = [[UITextView alloc]init];
	self.textView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.7, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height * 0.25);
	self.textView.alpha = 0.7;
	self.textView.backgroundColor = [UIColor blackColor];
	self.textView.textColor = [UIColor whiteColor];
	self.textView.font = [UIFont systemFontOfSize:16];
	self.textView.text = self.text;
	self.textView.userInteractionEnabled = NO;
	[self.view addSubview:self.textView];
}
- (void)setupBackButton {
	
	self.back = [UIButton buttonWithType:UIButtonTypeCustom];
	CGFloat margin= 10;
	CGFloat buttonWidthHeight = 35;
	self.back.frame = CGRectMake(margin, [UIApplication sharedApplication].statusBarFrame.size.height + margin, buttonWidthHeight, buttonWidthHeight);
	[self.back setImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
	[self.back addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.back];
	
	
}
- (void)tapImageView {
	self.textView.hidden = !self.textView.hidden;
	self.back.hidden = !self.back.hidden;
}
- (void)popBack {
	[self.navigationController popViewControllerAnimated:YES];
	
}

@end
