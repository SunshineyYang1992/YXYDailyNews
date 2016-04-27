//
//  YXYTabBarController.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "YXYTabBarController.h"
#import "YXYNavigationController.h"
#import "NewsViewController.h"

@interface YXYTabBarController ()

@end

@implementation YXYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	NewsViewController *vc1 = [[NewsViewController alloc] init];
	[self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tabbar_news"] selectedImage:[UIImage imageNamed:@"tabbar_news_hl"] withTittle:@"新闻"];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
	YXYNavigationController *nav = [[YXYNavigationController alloc] initWithRootViewController:controller];
	
	[nav.tabBarItem setImage:image];
	[nav.tabBarItem setSelectedImage:selectImage];
	//    nav.tabBarItem.title = tittle;
	//    controller.navigationItem.title = tittle;
	controller.title = tittle;//这句代码相当于上面两句代码
	[nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
	nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
	[self addChildViewController:nav];
}


@end
