//
//  YXYNavigationController.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "YXYNavigationController.h"

@interface YXYNavigationController ()

@end

@implementation YXYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

	self.navigationBar.barTintColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
	attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
	attributes[NSFontAttributeName] = [UIFont systemFontOfSize:20];

	self.toolbar.barTintColor = [UIColor whiteColor];
	self.navigationBar.titleTextAttributes = attributes;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"navigationbar_pic_back_icon"] forState:UIControlStateNormal];
		[button setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateHighlighted];
		button.frame = CGRectMake(0, 0, 30, 30);
		// 让按钮内部的所有内容左对齐
		button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		//        [button sizeToFit];
		// 让按钮的内容往左边偏移10
		[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		
		// 修改导航栏左边的item
		viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		// 隐藏tabbar
		viewController.hidesBottomBarWhenPushed = YES;
	}
	
	// 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
	[super pushViewController:viewController animated:animated];
	
	
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)back
{
	[self popViewControllerAnimated:YES];
}

@end
