//
//  WatchLiveTableViewController.m
//  live
//
//  Created by kenneth on 15-7-10.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "WatchLiveTableViewController.h"
#import "Macro.h"
#import "SegmentView.h"
#import "MJBaseTableView.h"
#import "XSearchFriendViewController.h"

NS_ENUM(NSInteger, LiveTabIndex)
{
    ELiveTab_Lastest,   // 最新直播
    ELiveTab_Trailer,   // 直播预告
    //
    ELiveTab_Count,
    ELiveTab_Videos,    // 精彩回放
};
@interface WatchLiveTableViewController ()<SegmentViewDelegate, UIScrollViewDelegate>
{
    SegmentView *_segmentView;
    UIScrollView *_scrollView;
    MJBaseTableView *_liveTableView;
    MJBaseTableView *_trailerTableView;
    MJBaseTableView *_videoTableView;
}
@end

@implementation WatchLiveTableViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    // 添加搜索按钮 add by gcz 2016-05-20 16:58:45
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
    //分段视图
    NSArray* items = [NSArray arrayWithObjects:@"热门", @"最新",  nil];
    CGRect segmentFrame = CGRectMake(SCREEN_WIDTH/6, 0, SCREEN_WIDTH*2/4, 32); // 44->35 w:SCREEN_WIDTH*2/3->SCREEN_WIDTH*2/4
    _segmentView = [[SegmentView  alloc] initWithFrame:segmentFrame andItems:items andSize:14 border:NO];
    _segmentView.delegate = self;
    self.navigationItem.titleView = _segmentView;
    //设置scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT-STATUS_HEIGHT)];
    _scrollView.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
    _scrollView.contentSize = CGSizeMake(ELiveTab_Count*SCREEN_WIDTH, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _liveTableView = [[MJLiveTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Lastest, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
    [_scrollView addSubview:_liveTableView];
    
//    _videoTableView = [[MJVideoTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Videos, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
//    [_scrollView addSubview:_videoTableView];
    
    _trailerTableView = [[MJTrailerTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Trailer, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
    [_scrollView addSubview:_trailerTableView];
    

    
    [_liveTableView beginRefreshing];
    [_trailerTableView beginRefreshing];
//    [_videoTableView beginRefreshing];
    
}

- (void)segmentView:(SegmentView  *)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _scrollView.contentOffset;
    NSInteger page = (offset.x + _scrollView.frame.size.width/2) / _scrollView.frame.size.width;
    [_segmentView setSelectIndex:page];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_liveTableView startRefreshTimer];
    [_trailerTableView startRefreshTimer];
    [_videoTableView startRefreshTimer];
    
   
    self.tabBarController.tabBar.hidden = NO;
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_liveTableView stopRefreshTimer];
    [_trailerTableView stopRefreshTimer];
    [_videoTableView stopRefreshTimer];
}

#pragma mark - Private method
// 搜索点击
- (void)searchClick
{
    XSearchFriendViewController *vc = [[XSearchFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 发布成功代理
- (void)publishTrailerSuccess
{
    [_trailerTableView beginRefreshing];
}

@end
