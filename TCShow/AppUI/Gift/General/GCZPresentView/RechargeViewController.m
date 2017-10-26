//
//  RechargeViewController.m
//  TCShow
//
//  Created by wxt on 2017/6/1.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "RechargeViewController.h"
#import "PayListCell.h"
#import "PayModel.h"
//#import "MXWechatPayHandler.h"
@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
/** <#注释#> */
@property (nonatomic,strong) UITableView *tab;
/** <#注释#> */
@property (nonatomic,strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
/** <#注释#> */
@property (nonatomic,strong) UIButton *payBtn;



@end

@implementation RechargeViewController

#pragma mark - Lifecycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tab = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tab  setDelegate:self];
    self.tab.dataSource = self;
    [self.view addSubview:self.tab];
    self.tab.tableFooterView = [UIView new];
    [self.tab registerClass:[PayListCell class] forCellReuseIdentifier:NSStringFromClass([PayListCell class])];
    
    self.title = @"充值";
    self.dataArray = [AllPays AllPays];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.backgroundColor = [UIColor redColor];
    [self.payBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    self.payBtn.layer.cornerRadius = 5.f;
    [self.view addSubview:self.payBtn];
    [self.payBtn setFrame:CGRectMake(50, kMainScreenHeight-200, kMainScreenWidth-100, 44)];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(succ) name:WXPaySUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fail) name:WXPayFail object:nil];

}
-(void)succ{
    [self AlertViewMessage:@"提示" buttonTitle:@"确定"];
}
-(void)fail{
    [self AlertViewMessage:@"提示" buttonTitle:@"OK"];
}
-(void)payAction{
    
    if (self.selectedIndexPath) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"订单生成中...";
        PayModel * pay = self.dataArray[self.selectedIndexPath.row];
        
        [[Business sharedInstance] limoPayWithWexinWithParam:@{@"user_id":[SARUserInfo userId],@"lemon_id":pay.mark} succ:^(NSString *msg, id data) {
            [hud hide:YES afterDelay:0];
            NSString *order_sn = [NSString stringWithFormat:@"%@",data[@"order_sn"]];
            [MXWechatPayHandler jumpToWxPayWithMoney: pay.payMoney Order:order_sn type:1];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:@"订单生成失败,请重试!"];
            [hud hide:YES afterDelay:2];
            
        }];
    }

}

- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:but];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark---------- tableViewDelegate -------wxt

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * sss = @"sss";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:sss];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sss];
    }
    PayModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.money;
    cell.detailTextLabel.text = model.limo;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [tableView reloadData];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPath isEqual:indexPath]) {
        return UITableViewCellAccessoryCheckmark;
    }return UITableViewCellAccessoryNone;
}
@end
