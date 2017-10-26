//
//  XXBlacklistTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXBlacklistTableViewController.h"
#import "XXBlackListTableViewCell.h"
#import "TCBlacklAddViewController.h"
#import "TCLiveUserList.h"
#import "TCUserDetailController.h"
@interface XXBlacklistTableViewController ()
{
    NSArray *_dataArr;
}
@end

@implementation XXBlacklistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"黑名单";
    self.view.backgroundColor = RGB(241, 239, 250);
    _dataArr = [NSArray array];
    [self setUpRefresh];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXBlackListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXBlackListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXBlackListTableViewCell" owner:self options:nil]lastObject];
    }
   
    [cell.img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_dataArr[indexPath.row][@"headsmall"])]];
    cell.img.layer.masksToBounds = YES;
    cell.img.layer.cornerRadius = 20;
    cell.nickName.text = _dataArr[indexPath.row][@"nickname"];
    cell.phone.text = _dataArr[indexPath.row][@"phone"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCLiveUserList * model= [[TCLiveUserList alloc] init];
    model.phone = _dataArr[indexPath.row][@"phone"];
    model.nickname = _dataArr[indexPath.row][@"nickname"];
    model.headsmall = _dataArr[indexPath.row][@"headsmall"];
    model.uid = _dataArr[indexPath.row][@"uid"];
    model.is_live = @"0";
    model.province = @"";
    IMAUser *user = [[IMAUser alloc]init];
    user.userId = model.phone;
    user.icon = model.headsmall;
    user.remark = model.nickname;
    user.nickName = model.nickname;
    //跳转到AIO
    //        [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
    //        [self pushToChatViewControllerWith:user];
    
    TCUserDetailController * detailController = [[TCUserDetailController alloc]init];
    detailController.user = user;
    detailController.userModel = model;
    [self.navigationController pushViewController:detailController animated:YES];
    

}


- (void)createData{

    NSDictionary *para = @{@"uid":[ SARUserInfo userId]};
    [RequestData requestWithUrl:BLACK_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0 ) {
            _dataArr = dic[@"data"];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        }
        [self.tableView.header endRefreshing];
    }fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
    


}

-(void)setUpRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    [self.tableView.header beginRefreshing];
    
}

@end
