//
//  QZKExchangeViewController.m
//  TCShow
//
//  Created by  m, on 2017/9/15.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKExchangeViewController.h"
#import "QZKExchangeView.h"
#import "PayModel.h"
@interface QZKExchangeViewController ()

@property (nonatomic, strong) QZKExchangeView *purseView;

@end

@implementation QZKExchangeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"积分兑换";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _purseView = [[QZKExchangeView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 5)];
    _purseView.dataArray = @[@"10",@"20",@"50",@"100",@"500"];
    [self.view addSubview:_purseView];
   
}

-(void) back
{
    if ([self.ispushOrpop isEqualToString:@"push"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMyMoney];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getMyMoney {
    
    [[Business sharedInstance] getMyIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
        [_purseView.lemonCoinsLab setText:[NSString stringWithFormat:@"%@",data[@"integral"]]];
        
    } fail:^(NSString *error) {
        [_purseView.lemonCoinsLab setText:@"未获取"];
    }];
    
    [[Business sharedInstance] getMyDiamondsWithParam:@{@"uid":[SARUserInfo userId]} succ:^(NSString *msg, id data) {
        
        [_purseView.diamondsCoinsLab setText:[NSString stringWithFormat:@"%@",data[@"diamonds_coins"]]];
        
    } fail:^(NSString *error) {
        [_purseView.diamondsCoinsLab setText:@"未获取"];
    }];

    
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
