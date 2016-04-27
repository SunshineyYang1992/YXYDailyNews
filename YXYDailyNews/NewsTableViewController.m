//
//  NewsTableViewController.m
//  YXYDailyNews
//
//  Created by Sunshine Yang on 4/26/16.
//  Copyright © 2016 SunshineYang. All rights reserved.
//

#import "NewsTableViewController.h"
#import "DetailViewController.h"
#import "MutiPicViewController.h"

#import "NoPicNewsTableViewCell.h"
#import "SinglePicNewsTableViewCell.h"
#import "MutiPicNewsTableViewCell.h"

#import "AnalyzingNetworking.h"
#import "YXYConst.h"
#import "UIImageView+Extension.h"
#import "RequestManager.h"
#import "YXYNormalNewsFetchDataParameter.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>


static NSString *const SinglePicCell = @"SinglePicCell";
static NSString *const NoPicCell = @"NoPicCell";
static NSString *const MutiPicCell = @"MutiPicCell";
static NSString *const apikey = @"f2dae36d3e3f62d0889304106ee0be2f";


@interface NewsTableViewController ()

@property (nonatomic, strong)NSMutableArray *normalNewsArray;
@property (nonatomic, strong)NSMutableArray *headerNewsArray;

@property (nonatomic, strong)UIScrollView *headingScrollView;
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UIImageView *middleImageView;
@property (nonatomic, strong)UIImageView *rightImageView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UILabel *heading;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger currentHeadingIndex;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	if ([AnalyzingNetworking analyze] == NO) {
		[SVProgressHUD showErrorWithStatus:@"无网络连接"];
		return;
	}
	[self setupBasic];
	[self setupRefresh];
	[self setupHeading];
	[self addTimer];
}
#pragma mark: Lazy Initialize 

- (NSMutableArray *)headerNewsArray {
	if (!_headerNewsArray) {
		_headerNewsArray = [NSMutableArray array];
	}
	return _headerNewsArray;
}

- (NSMutableArray *)normalNewsArray {
	if (!_normalNewsArray) {
		_normalNewsArray = [NSMutableArray array];
	}
	return _normalNewsArray;
}


#pragma mark: Setup Views

- (void)setupHeading {
	
	CGFloat headerLabelHeight = 30;
	CGFloat margin = 10;
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	UIView *headingView = [[UIView alloc]init];
	headingView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
	
	self.headingScrollView = [[UIScrollView alloc]init];
	self.headingScrollView.showsHorizontalScrollIndicator = NO;
	self.headingScrollView.showsVerticalScrollIndicator = NO;
	self.headingScrollView.frame = headingView.frame;
	[headingView addSubview:self.headingScrollView];
	self.headingScrollView.contentSize = CGSizeMake(headingView.frame.size.width *3, 0);
	//	self.headingScrollView.contentOffset = CGPointZero;
	self.headingScrollView.contentOffset = CGPointMake(headingView.frame.size.width, 0);
	self.headingScrollView.pagingEnabled = YES;
	self.headingScrollView.delegate = self;
	
	for (int i=0; i < 3; i++) {
		UIImageView *imageView = [[UIImageView alloc]init];
		if (i == 0) {
			self.leftImageView = imageView;
		}else if ( i == 1) {
			self.middleImageView = imageView;
		}else if ( i == 2) {
			self.rightImageView =imageView;
		}
		imageView.frame = CGRectMake(i * self.headingScrollView.frame.size.width, 0, self.headingScrollView.frame.size.width, self.headingScrollView.frame.size.height);
		UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadingImageView:)];
		imageView.userInteractionEnabled = YES;
		[imageView addGestureRecognizer:recognizer];
		[self.headingScrollView addSubview:imageView];
		
	}
	
	UIView *view = [[UIView alloc] init];
	view.frame = CGRectMake(0, headingView.frame.size.height - headerLabelHeight, headingView.frame.size.width, headerLabelHeight);
	view.alpha = 0.8;
	view.backgroundColor =[UIColor darkGrayColor];
	[headingView addSubview:view];
	
	UIPageControl *pageControl = [[UIPageControl alloc] init];
	pageControl.numberOfPages = 5;
	CGFloat pageControlWidth = [pageControl sizeForNumberOfPages:pageControl.numberOfPages].width;
	pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
	
	self.pageControl = pageControl;
	pageControl.frame = CGRectMake(headingView.frame.size.width - pageControlWidth-0.5*margin, 0, pageControlWidth, headerLabelHeight);
	pageControl.currentPage = 0;
	[view addSubview:pageControl];
	
	UILabel *headerLabel = [[UILabel alloc] init];
	self.heading = headerLabel;
	headerLabel.frame = CGRectMake(0, 0, headingView.frame.size.width - pageControlWidth-1.5*margin, headerLabelHeight);
	headerLabel.textAlignment = NSTextAlignmentLeft;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.backgroundColor = [UIColor darkGrayColor];
	headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[view addSubview:headerLabel];
	
	headingView.hidden = YES;
	self.tableView.tableHeaderView = headingView;
	
	
}

- (void)setupBasic {
	
	self.currentHeadingIndex = 0;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoPicNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NoPicCell];
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePicNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:SinglePicCell];
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MutiPicNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:MutiPicCell];
	
	
	
}
- (void)setupRefresh {
	
	MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	self.tableView.mj_header = header;
	self.tableView.mj_header.automaticallyChangeAlpha = YES;
	[self.tableView.mj_header beginRefreshing];
	
	self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	self.currentPage = 1;
	
	
}

- (void)updateHeaderView {
	
	if (self.headerNewsArray.count == 0) {
		return;
	}
	self.currentHeadingIndex = 0;
	YXYHeaderNews *middleNews = self.headerNewsArray[self.currentHeadingIndex];
	//NSLog(@"%@",middleNews.imgUrl);
	[self.middleImageView setImageWithURL:[NSURL URLWithString:middleNews.imgUrl]];
	self.heading.text = [NSString stringWithFormat:@"    %@",middleNews.title];
	
	NSInteger leftIndex = (self.currentHeadingIndex - 1 + self.headerNewsArray.count)%self.headerNewsArray.count;//防止减1减成负数，所以加了一个self.headerNewsArray.count
	YXYHeaderNews *leftNews = self.headerNewsArray[leftIndex];
	[self.leftImageView setImageWithURL:[NSURL URLWithString:leftNews.imgUrl]];
	
	NSInteger rightIndex = (self.currentHeadingIndex + 1)%self.headerNewsArray.count;
	YXYHeaderNews *rightNews = self.headerNewsArray[rightIndex];
	[self.rightImageView setImageWithURL:[NSURL URLWithString:rightNews.imgUrl]];
	self.pageControl.currentPage=0;
	[self.headingScrollView setContentOffset:CGPointMake(self.headingScrollView.frame.size.width, 0)];
	self.pageControl.numberOfPages = self.headerNewsArray.count;
	[self.tableView reloadData];
}


- (void)clickHeadingImageView:(id)sender {
	YXYHeaderNews *news = self.headerNewsArray[self.currentHeadingIndex];
	[self pushToDetailViewControllerWithUrl:news.url];
}
- (void)pushToDetailViewControllerWithUrl:(NSString *)url {
	
	DetailViewController *detailVC = [[DetailViewController alloc]init];
	detailVC.url = url;
	[self.navigationController pushViewController:detailVC animated:YES];
	
}

#pragma mark: Fetch data 

- (void)loadNewData {
	[SVProgressHUD show];
	[self fetchNewHeaderNews];
	[self fetchNewNormalNews];
	
}
- (void)loadMoreData {
	
	[SVProgressHUD show];
	YXYNormalNews *news = self.normalNewsArray.lastObject;
	if (self.currentPage >= news.allPages) {
		[self.tableView.mj_footer endRefreshingWithNoMoreData];
		[SVProgressHUD showErrorWithStatus:@"全部加载完毕"];
		return;
	}
	NSInteger current = self.currentPage + 1;
	YXYNormalNewsFetchDataParameter *parameter = [[YXYNormalNewsFetchDataParameter alloc]init];
	parameter.channelId = self.channelId;
	parameter.channelName = self.channelName;
	parameter.title = @":";
	parameter.page = current;
	parameter.recentTime = news.createTime;
	[RequestManager normalNewsWithParameters:parameter sucess:^(NSMutableArray *array) {
		
		[self.normalNewsArray addObjectsFromArray:array];
		[self.tableView reloadData];
		[self.tableView.mj_footer endRefreshing];
		[SVProgressHUD dismiss];
		self.currentPage = current;
		
		
	} failure:^(NSError *error) {
		
		[SVProgressHUD dismiss];
		[SVProgressHUD showErrorWithStatus:@"jiazaishib"];
		[self.tableView.mj_footer endRefreshing];
		[self.tableView reloadData];
	}];
	
	
}
- (void)fetchNewHeaderNews {
	
	[self removeTimer];
	[RequestManager headerNewsFromServerOrCacheWithMaxHeaderNews:self.headerNewsArray.lastObject sucess:^(NSMutableArray *array) {
		
		self.headerNewsArray = array;
		self.tableView.tableHeaderView.hidden = NO;
		[SVProgressHUD dismiss];
		[self updateHeaderView];
		//NSLog(@"%@",self.headerNewsArray);
	} failure:^(NSError *error) {
		[SVProgressHUD dismiss];
		[SVProgressHUD showErrorWithStatus:@"加载失败"];
		[self.tableView.mj_header endRefreshing];
		[self removeTimer];
		NSLog(@"%@fetchHeaderNews%@",self, error);

	}];
	[self addTimer];
	
}
- (void)fetchNewNormalNews {
	
	YXYNormalNews *news = self.normalNewsArray.firstObject;
	YXYNormalNewsFetchDataParameter *parameter = [[YXYNormalNewsFetchDataParameter alloc]init];
	parameter.channelId = self.channelId;
	parameter.channelName = self.channelName;
	parameter.title = @", ";
	parameter.page = 1;
	parameter.recentTime = news.createTime;
	[RequestManager normalNewsWithParameters:parameter sucess:^(NSMutableArray *array) {
		self.normalNewsArray = array;
		//NSLog(@"%@",self.normalNewsArray);

		[SVProgressHUD dismiss];
		[self.tableView reloadData];
		[self.tableView.mj_header endRefreshing];
		
	} failure:^(NSError *error) {
		
		[SVProgressHUD dismiss];
		[SVProgressHUD showErrorWithStatus:@"加载失败"];
		[self.tableView.mj_header endRefreshing];
		[self.tableView reloadData];
	}];
}

#pragma mark: Helper methods

- (void)addTimer {
	
	self.timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(next) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
	
	
}
- (void)removeTimer {
	[self.timer invalidate];
}
- (void)next {
	[UIView animateWithDuration:1 animations:^{
		
		[self.headingScrollView setContentOffset:CGPointMake(self.headingScrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width, 0)];
		[self scrollViewDidEndDecelerating:self.headingScrollView];
	}];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.normalNewsArray.count;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	YXYNormalNews *news = self.normalNewsArray[indexPath.row];
//	NSLog(@"%@",news);
	if (news.normalNewsType == NormalNewsTypeMutiPic) {
		
		MutiPicNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MutiPicCell];
		cell.title = news.title;
		cell.imgUrls = news.imgUrls;
		
		return cell;
	}else if (news.normalNewsType == NormalNewsTypeSinglePic) {
		SinglePicNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SinglePicCell];
		cell.titleText = news.title;
		cell.detailText = news.desc;
		NSDictionary *dict = news.imgUrls.firstObject;
		if (dict) {
			cell.imgUrl = dict[@"url"];
		}
		return cell;
	}else {
		NoPicNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoPicCell];
		cell.titleText = news.title;
		cell.contentText = news.desc;
		return cell;
	}
}

#pragma mark: TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	YXYNormalNews *news = self.normalNewsArray[indexPath.row];
	return news.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YXYNormalNews *news = self.normalNewsArray[indexPath.row];
	if (news.normalNewsType == NormalNewsTypeMutiPic) {
		MutiPicViewController *mutiPicVC = [[MutiPicViewController alloc]init];
		mutiPicVC.imgUrls = news.imgUrls;
		NSString *text = news.desc;
		if (text == nil || [text isEqualToString:@""]) {
			text = news.title;
		}
		mutiPicVC.text = text;
		[self.navigationController pushViewController:mutiPicVC animated:YES];
		
	}else {
		[self pushToDetailViewControllerWithUrl:news.link];
	}
}

#pragma mark: Scroll View delegate 

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self removeTimer];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	[self addTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (scrollView == self.headingScrollView) {
		if (self.headerNewsArray.count == 0 || self.headerNewsArray == nil) {
			return;
		}
		
		if (scrollView.contentOffset.x >= scrollView.frame.size.width) {
			self.currentHeadingIndex = (self.currentHeadingIndex + 1) % self.headerNewsArray.count;
			
		}else {
			self.currentHeadingIndex = (self.currentHeadingIndex -1 + self.headerNewsArray.count) % self.headerNewsArray.count;
		}
		self.pageControl.currentPage = self.currentHeadingIndex;
		
		YXYHeaderNews *midNews = self.headerNewsArray[self.currentHeadingIndex];
	//	[self.middleImageView setImageWithURL:[NSURL URLWithString:midNews.url]];
		self.heading.text = [NSString stringWithFormat:@"   %@",midNews.title];
		
		NSInteger leftIndex = (self.currentHeadingIndex - 1 + self.headerNewsArray.count) % self.headerNewsArray.count;
		YXYHeaderNews *leftNews = self.headerNewsArray[leftIndex];
		//[self.leftImageView setImageWithURL:[NSURL URLWithString:leftNews.imgUrl]];
		
		NSInteger rightIndex = (self.currentHeadingIndex + 1) % self.headerNewsArray.count;
		YXYHeaderNews *rightNews = self.headerNewsArray[rightIndex];
	//	[self.rightImageView setImageWithURL:[NSURL URLWithString:rightNews.imgUrl]];
		[self.headingScrollView setContentOffset:CGPointMake(self.headingScrollView.frame.size.width, 0)];
		
	}
	
}




@end
