//
//  XXOrderBaseTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXOrderBaseTableViewController.h"
#import "ZJScrollPageView.h"
#import "XXMyOrderTableViewController.h"
@interface XXOrderBaseTableViewController ()<ZJScrollPageViewDelegate>
{
        NSArray *_titleArr;
    ZJScrollPageView *_scrollPageView;
    
}
@end

@implementation XXOrderBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = RGB(239, 241, 250);
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    _titleArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    //    style.showLine = YES;
    style.scrollTitle = YES;
    style.scaleTitle = YES;
    style.titleBigScale = 1.1;
    style.showLine = YES;
    style.scrollLineHeight = 3;
    style.scrollLineColor = kNavBarThemeColor;
    style.titleFont = [UIFont systemFontOfSize:16];
    style.normalTitleColor = RGBAlpha(34, 34, 34, 1.0);
    style.selectedTitleColor = kNavBarThemeColor;
    style.adjustCoverOrLineWidth = YES;
    style.autoAdjustTitlesWidth = YES;
    style.titleScrollViewColor = [UIColor whiteColor];
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) segmentStyle:style titles:_titleArr parentViewController:self delegate:self];
    _scrollPageView.isLoad = YES;
    [_scrollPageView setSelectedIndex:_selectedIndex animated:YES];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [_scrollPageView addSubview:lineView];
    lineView.backgroundColor=RGBAlpha(222, 222, 222, 1.0);
    [self.view addSubview:_scrollPageView];
    
    
}
    
- (NSInteger)numberOfChildViewControllers {
    return _titleArr.count;
}
    
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UITableViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
     XXMyOrderTableViewController *all = (XXMyOrderTableViewController *)reuseViewController;
    
    if (all == nil) {
        all = [[XXMyOrderTableViewController alloc] init];
    }
    
    if (index == 0) {
        //全部
        
        all.orderType = nil;
    }else if(index == 1){
        // 待付款
        
        all.orderType = @"WAITPAY";
    }else if(index == 2){
        // 待发货
        
        all.orderType = @"WAITSEND";
    }else if(index == 3){
        // 待收货
     
        all.orderType = @"WAITRECEIVE";
    }else{
        // 待评价
        all.orderType = @"WAITCCOMMENT";
    
    }
    
    return all;
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

@end
