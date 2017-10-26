//
//  LemonPurseViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/9.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LemonPurseViewController.h"
#import "LemonPurseView.h"
#import "PayModel.h"
@interface LemonPurseViewController ()

@property (nonatomic, strong) LemonPurseView *purseView;

@end

@implementation LemonPurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _purseView = [[LemonPurseView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 5)];
    _purseView.dataArray = [AllPays AllPays];
    __weak typeof(self) weakself = self;
    _purseView.payBtnClickBlock = ^(PayModel *model) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakself.purseView animated:YES];
        hud.labelText = @"订单生成中...";
        
        [[Business sharedInstance] limoPayWithWexinWithParam:@{@"user_id":[SARUserInfo userId],@"lemon_id":model.mark} succ:^(NSString *msg, id data) {
            [hud hide:YES afterDelay:0];
            NSString *order_sn = [NSString stringWithFormat:@"%@",data[@"order_sn"]];
            [MXWechatPayHandler jumpToWxPayWithMoney: model.payMoney Order:order_sn type:1];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:@"订单生成失败,请重试!"];
            [hud hide:YES afterDelay:2];
            
        }];
    };
    [self.view addSubview:_purseView];
    [self getMyMoney];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(succ) name:WXPaySUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fail) name:WXPayFail object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getMyMoney {
    
    [[Business sharedInstance] getMyDiamondsWithParam:@{@"uid":[SARUserInfo userId]} succ:^(NSString *msg, id data) {
        
        [_purseView.diamondsCoinsLab setText:[NSString stringWithFormat:@"%@",data[@"diamonds_coins"]]];
        
    } fail:^(NSString *error) {
        [_purseView.diamondsCoinsLab setText:@"未获取"];
    }];
    
    [[Business sharedInstance] getMyIconWithParam:@{@"uid":[SARUserInfo userId]} succ:^(NSString *msg, id data) {
        [_purseView.lemonCoinsLab setText:[NSString stringWithFormat:@"%@",data[@"charm"]]];
    } fail:^(NSString *error) {
        [_purseView.lemonCoinsLab setText:@"未获取"];
    }];
}

-(void)succ{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    [self getMyMoney];
}
-(void)fail{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
