//
//  SearchResultController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SearchResultController.h"
#import "ZJScrollPageView.h"
#import "TCAllTableController.h"
#import "TCTariffTableController.h"
#import "TCSalesTableController.h"
@interface SearchResultController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSMutableArray *titles;
@property(strong,nonatomic)NSArray *childVC;
@property(strong,nonatomic) ZJScrollPageView *scrollPageView;

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshNavi];
    self.titles = [NSMutableArray arrayWithArray:@[@"综合",@"价格",@"销量"]];
    [self addSubViewController];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = RGBA(152, 152, 152, 1.0);
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = NO;
}


-(void)addSubViewController{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleFont = [UIFont systemFontOfSize:15];
    style.normalTitleColor = RGBAlpha(71, 71, 71, 1.0);
    style.selectedTitleColor = RGBAlpha(255, 87, 64, 1.0);
    style.adjustCoverOrLineWidth = YES;
    style.scrollContentView = YES;
    style.autoAdjustTitlesWidth = YES;
    style.segmentHeight = 48.0;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(12, 44, kSCREEN_WIDTH - 24, 1)];
    [_scrollPageView addSubview:lineView];
    lineView.backgroundColor=RGBAlpha(222, 222, 222, 1.0);
    [self.view addSubview:_scrollPageView];
}

-(void)refreshNavi{
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(12, 15, kSCREEN_WIDTH - 100, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView cornerViewWithRadius:5];
    self.navigationItem.titleView = searchView;
    
    
    UIImageView * searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
    searchImageView.image = IMAGE(@"search");
    [searchView addSubview:searchImageView];
    
    UILabel * searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 3, 0, searchView.width - CGRectGetMaxX(searchImageView.frame) - 3, 30)];
    searchLabel.text = self.searchName;
    searchLabel.textColor = RGBA(152, 152, 152, 1.0);
    searchLabel.font = [UIFont systemFontOfSize:15.0];
    [searchView addSubview:searchLabel];
    
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UITableView<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
//    if (!childVc) {
//        return  _childVC[index];
//    }
//    return childVc;
    if (index == 0) {
        TCAllTableController *childVc = (TCAllTableController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TCAllTableController alloc] init];
            childVc.searchName = self.searchName;
        }
        return childVc;
        
    } else if (index == 1) {
        TCTariffTableController *childVc = (TCTariffTableController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TCTariffTableController alloc] init];
            childVc.searchName = self.searchName;
            childVc.searchType = @"sales_sum";
        }
        
        return childVc;
    } else{
        TCSalesTableController *childVc = (TCSalesTableController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TCSalesTableController alloc] init];
            childVc.searchName = self.searchName;
            childVc.searchType = @"shop_price";
        }
        return childVc;
    }

}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}



@end
