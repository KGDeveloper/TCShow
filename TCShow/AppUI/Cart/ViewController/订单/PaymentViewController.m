//
//  PaymentViewController.m
//  ShoppingCart
//
//  Created by tangtianshi on 16/11/1.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayTableViewCell.h"
#import "MXWechatPayHandler.h"
@interface PaymentViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
    NSMutableArray * _cellArray;
    NSInteger _selIndex;
}

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YCColor(241, 239, 250, 1.0);
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 20, 15);
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
//    backImageView.image = [UIImage imageNamed:@"btn-left"];
//    [back addSubview:backImageView];
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    _cellArray = [NSMutableArray arrayWithCapacity:0];
    self.title = @"支付订单";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 75)];
    bottomView.backgroundColor = [UIColor clearColor];
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(10, 30, kSCREEN_WIDTH - 20, 45);
    payButton.backgroundColor = kNavBarThemeColor;
    payButton.layer.cornerRadius = 6;
    payButton.layer.masksToBounds = YES;
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payButton];
    _tableView.tableFooterView = bottomView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(succ) name:WXPaySUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fail) name:WXPayFail object:nil];
}

-(void)succ{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
//    [self getMyMoney];
}
-(void)fail{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)payClick{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
    [dic setValue:_order_sns forKey:@"order_sn"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:COMMIT_ORDER_CART4 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *succDic = responseObject[@"data"];
        if ([succDic[@"order_amount"] integerValue]== 0) {
            NSString *order_amout = [NSString stringWithFormat:@"%ld",[[[succDic[@"order_amount"] componentsSeparatedByString:@"."] lastObject] integerValue]];
            [MXWechatPayHandler jumpToWxPayWithMoney:order_amout Order:succDic[@"order_sn"] type:2];
        }else{
            NSString *order_amout = [NSString stringWithFormat:@"%ld",[succDic[@"order_amount"] integerValue]*100];
            [MXWechatPayHandler jumpToWxPayWithMoney:order_amout Order:succDic[@"order_sn"] type:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark--------tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    PayTableViewCell * payCell = [tableView dequeueReusableCellWithIdentifier:@"PayChanceCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (payCell == nil) {
        payCell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil]firstObject];
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"订单金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@",self.payMoney];
        cell.detailTextLabel.textColor = kNavBarThemeColor;
        return cell;
    }
    if (indexPath.row == 0) {
        payCell.payImage.image = [UIImage imageNamed:@"wxPay"];
        payCell.payName.text = @"微信支付";
        payCell.paySelectImage.image = [UIImage imageNamed:@"paySelect"];
    }
    [_cellArray addObject:payCell];
    return payCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0;
    }else if (section == 1){
        return 33.0;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kSCREEN_WIDTH - 30, 23)];
        label.text = @"    选择支付方式";
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        return label;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PayTableViewCell * cell = _cellArray[indexPath.row];
//    cell.paySelectImage.image = [UIImage imageNamed:@"paySelect"];
//    for (PayTableViewCell * payCell in _cellArray) {
//        if (cell != payCell) {
//            payCell.paySelectImage.image = [UIImage imageNamed:@"payUnselect"];
//        }
//    }
//    _selIndex = indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
