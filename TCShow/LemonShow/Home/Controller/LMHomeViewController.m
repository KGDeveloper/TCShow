//
//  LMHomeViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/8.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeViewController.h"
#import "LMHomeTopSliderView.h"
#import "SearchViewController.h"
#import "TCCharmShowViewController.h"
#import "LMRankViewController.h"
#import "LMHomeView.h"

@interface LMHomeViewController ()

@property (nonatomic, strong) LMHomeTopSliderView *homeTopSliderV;

@property (nonatomic, strong) LMHomeView *backV;

@end

@implementation LMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [btn setImage:IMAGE(@"lemon_paihang") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [btn2 setImage:IMAGE(@"lemon_search") forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _homeTopSliderV = [[LMHomeTopSliderView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 160, 44)];
    self.navigationItem.titleView = _homeTopSliderV;
    
    _backV = [[LMHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    
    [self.view addSubview:_backV];
    
    __weak typeof(_homeTopSliderV) weakTopV = _homeTopSliderV;
    __weak typeof(_backV) weakBackV = _backV;
    _homeTopSliderV.btnClickBlock = ^(NSInteger index) {
        weakBackV.backScrollView.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
    };
    _backV.slideBlock = ^(NSInteger index) {
        CGFloat aaa = (CGFloat)index / (CGFloat)SCREEN_WIDTH;
        weakTopV.bottomLineV.frame = CGRectMake(((SCREEN_WIDTH - 160) / 3) * aaa + ((SCREEN_WIDTH - 160) / 3 - 50) / 2, 44 - 1, 50, 1);
    };
    
    _backV.slideEndBlock = ^(NSInteger index) {
        
        for (int i = 0; i < weakTopV.subviews.count; i++) {
            
            if ([weakTopV.subviews[i] isKindOfClass:[UIButton class]]) {
                UIButton * btn = weakTopV.subviews[i];
                if (btn.tag == (index + 10)) {
                    [btn setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
                    btn.enabled = NO;
                }else {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.enabled = YES;
                }
            }
            
        }
        
    };
    
    _backV.itemClickBlock = ^(TCShowLiveListItem *item) {
        id<TCShowLiveRoomAble> itemA = item;
        IMAHost *host = [IMAPlatform sharedInstance].host;
        TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:itemA user:host];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    };
    
}

- (void)leftItemClick {
    TCCharmShowViewController *vc = [[TCCharmShowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightItemClick {
    LMRankViewController * search = [[LMRankViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
