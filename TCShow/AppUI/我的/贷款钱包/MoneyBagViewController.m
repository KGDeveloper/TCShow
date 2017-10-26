//
//  MoneyBagViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MoneyBagViewController.h"
#import "MoneyRecordTableController.h"
@interface MoneyBagViewController ()
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UIButton *withdrawButton;
- (IBAction)payButtobClick:(UIButton *)sender;

@end

@implementation MoneyBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贷款钱包";
    self.payButton.layer.cornerRadius = 6;
    self.payButton.layer.masksToBounds = YES;
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.layer.cornerRadius = 6;
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.borderWidth = 1.0f;
    self.withdrawButton.layer.borderColor = YCColor(201, 199, 205, 1.0).CGColor;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"钱包明细" style:UIBarButtonItemStylePlain target:self action:@selector(moneyList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


-(void)moneyList{
    MoneyRecordTableController * list = [[MoneyRecordTableController alloc]init];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)payButtobClick:(UIButton *)sender {
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时不支持充值与提现." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alter show];
}
@end
