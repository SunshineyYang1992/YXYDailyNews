//
//  DetailViewController.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "DetailViewController.h"
#import "AnalyzingNetworking.h"
#import "YXYConst.h"

#import <SVProgressHUD.h>

@interface DetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong)UIView *shadeView;
@property (nonatomic, strong)UIButton *favoriteBtn;
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)UIBarButtonItem *back;
@property (nonatomic, strong)UIBarButtonItem *forward;
@property (nonatomic, strong)UIBarButtonItem *refresh;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([AnalyzingNetworking analyze] == NO) {
		[SVProgressHUD showErrorWithStatus:@"无网络间接"];
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	[self setupBasic];
	[self setupNavigationBar];
	
}
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[SVProgressHUD show];
	self.navigationController.toolbarHidden = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
	[self updateSkinModel];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
	self.navigationController.toolbarHidden = YES;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateSkinModel {
	NSString  *currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
	if ([currentSkinModel isEqualToString:NightSkinModelValue]) {
		self.view.backgroundColor = [UIColor blackColor];
		self.shadeView.hidden = NO;
		self.refresh.tintColor = [UIColor whiteColor];
		self.back.tintColor = [UIColor whiteColor];
		self.forward.tintColor = [UIColor whiteColor];
	} else {//日间模式
		self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
		self.shadeView.hidden = YES;
		self.refresh.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
		self.back.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
		self.forward.tintColor = [UIColor colorWithRed:245/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
	}
}
- (void)setupBasic {
	
	self.webView = [[UIWebView alloc]init];
	self.webView.frame = self.view.frame;
	self.webView.delegate = self;
	[self.view addSubview:self.webView];
	[SVProgressHUD show];
	
	self.shadeView = [[UIView alloc]init];
	self.shadeView.backgroundColor = [UIColor blackColor];
	self.shadeView.alpha = 0.3;
	self.shadeView.userInteractionEnabled = NO;
	self.shadeView.frame = self.webView.bounds;
	[self.webView addSubview:self.shadeView];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
	
}
- (void)setupNavigationBar {
	
	self.favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.favoriteBtn.frame = CGRectMake(0, 0, 30, 30);
	[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
	[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_pressed"] forState:UIControlStateHighlighted];
	[self.favoriteBtn setImage:[[UIImage imageNamed:@"navigationBarItem_favorite_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
	[self.favoriteBtn addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.favoriteBtn];
	
	self.back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_back_icon"]imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	
	self.forward = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"toolbar_forward_icon"]imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
	
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	self.refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	self.toolbarItems = @[self.back, self.forward,flexibleItem,self.refresh];
	
	
}
- (void)favorite {
	self.favoriteBtn.selected = !self.favoriteBtn.selected;
	if (self.favoriteBtn.selected) {
		[SVProgressHUD showSuccessWithStatus:@"收藏成功"];
		[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorited_normal"] forState:UIControlStateNormal];
		[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorited_pressed"] forState:UIControlStateHighlighted];
	} else {
		[SVProgressHUD showSuccessWithStatus:@"取消收藏"];
		[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
		[self.favoriteBtn setImage:[UIImage imageNamed:@"navigationBarItem_favorite_pressed"] forState:UIControlStateHighlighted];
	}

}
- (void)goBack {
	[self.webView goBack];
	
}
- (void)goForward {
	[self.webView goForward];
}
- (void)reload {
	[self.webView reload];
}
#pragma mark: webview Delegate 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	double delayInSeconds = 0.2;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
	});
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[SVProgressHUD dismiss];
	self.back.enabled = webView.canGoBack;
	self.forward.enabled = webView.canGoForward;
	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[SVProgressHUD dismiss];
	
}



@end
