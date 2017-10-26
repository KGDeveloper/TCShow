//
//  XXTransactionManagementTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXTransactionManagementTableViewController.h"
#import "XXNotifierProPlusTableViewController.h"
#import "HostProfileTableViewCell.h"
#import "XXDetailAfterViewController.h"

@interface XXTransactionManagementTableViewController ()
{
    NSArray *_titleArr;
    NSDictionary * _manageDic;
}
@end

@implementation XXTransactionManagementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易管理";
    self.view.backgroundColor = RGB(241, 239, 250);
    _titleArr = @[@"待发货",@"已发货",@"全部订单"];
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_msg"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self updateManageSource];
}


-(void)updateManageSource{
    [[HUDHelper sharedInstance]syncLoading:@"正在加载"];
    [[Business sharedInstance] getStoreBusMangUid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        [[HUDHelper sharedInstance] syncStopLoading];
        _manageDic = data;
        [self.tableView reloadData];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
    }];
}

// 导航栏右按钮
-(void)rightAtemClick{
    ConversationListViewController * message = [[ConversationListViewController alloc]init];
    message.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HostCell"];
    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"HostCell" owner:self options:nil]lastObject];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HostCell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = RGB(69, 69, 69);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = RGB(69, 69, 69);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@件",_manageDic[@"waitsend"]];
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@件",_manageDic[@"waitreceive"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XXDetailAfterViewController *xxv = [[XXDetailAfterViewController alloc]init];
    xxv.sendTag = indexPath.row;
    [self.navigationController pushViewController:xxv animated:YES];
}



@end
