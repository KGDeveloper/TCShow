//
//  XXCommodityManagementViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXCommodityManagementViewController.h"
#import "ZJScrollPageView.h"
#import "XXSellTableViewController.h"

@interface XXCommodityManagementViewController ()<ZJScrollPageViewDelegate>
{
   
    NSArray *_titles;
}
@property(strong,nonatomic) ZJScrollPageView *scrollPageView;
@end

@implementation XXCommodityManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    self.view.backgroundColor = RGB(239, 241, 250);
    _titles = @[@"出售",@"已售商品"];
    
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
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) segmentStyle:style titles:_titles parentViewController:self delegate:self];
    _scrollPageView.isLoad = YES;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [_scrollPageView addSubview:lineView];
    lineView.backgroundColor=RGBAlpha(222, 222, 222, 1.0);
    [self.view addSubview:_scrollPageView];
   

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfChildViewControllers {
    return _titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UITableViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {

    if (index == 0) {
        //出售
        XXSellTableViewController *all = (XXSellTableViewController *)reuseViewController;
        
        if (all == nil) {
            all = [[XXSellTableViewController alloc] init];
        }
        all.goodsType = @"1";
        return all;
        
    }else{
        // 已售
        XXSellTableViewController *all = (XXSellTableViewController *)reuseViewController;
        
        if (all == nil) {
            all = [[XXSellTableViewController alloc] init];
        }
        all.goodsType = @"2";
        return all;
    }
}


-(BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

@end
