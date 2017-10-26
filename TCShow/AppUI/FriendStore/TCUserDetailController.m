//
//  TCUserDetailController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCUserDetailController.h"
#import "TCUserInfoCell.h"
#import "TCFansCell.h"
#import "TCRegionCell.h"
#import "TCSendMessageCell.h"
#import "TCBlacklAddViewController.h"
#import "MJRefresh.h"
@interface TCUserDetailController (){
    MJRefreshNormalHeader *_header;
}
@end

@implementation TCUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = setItem;
    [self updateUserInfo];
    [self setUpRefresh];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateUserInfo)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
}



#pragma mark -------更新个人信息数据
-(void)updateUserInfo{
    [[Business sharedInstance] getUserInfoByUid:[SARUserInfo userId] userid:self.userModel.uid succ:^(NSString *msg, id data) {
        self.userModel.is_live = data[@"is_live"];
        self.userModel.fans = data[@"fans"];
        self.userModel.follows = data[@"follows"];
        self.userModel.province = data[@"province"];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
        [self.tableView.header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setting{
    TCBlacklAddViewController * black = [[TCBlacklAddViewController alloc]init];
    black.userPhone = self.userModel.phone;
    
    [self.navigationController pushViewController:black animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCUserInfoCell * userInfo = [tableView dequeueReusableCellWithIdentifier:@"USERINFOCELL"];
    TCFansCell * fansCell = [tableView dequeueReusableCellWithIdentifier:@"FANSCELL"];
    TCRegionCell * regionCell = [tableView dequeueReusableCellWithIdentifier:@"REGIONCELL"];
    TCSendMessageCell * sendMessageCell = [tableView dequeueReusableCellWithIdentifier:@"SENDMESSAGECELL"];
    if (userInfo == nil) {
        userInfo = [[[NSBundle mainBundle] loadNibNamed:@"TCUserInfoCell" owner:nil options:nil] firstObject];
        userInfo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (fansCell == nil) {
        fansCell = [[[NSBundle mainBundle] loadNibNamed:@"TCFansCell" owner:nil options:nil]firstObject];
        fansCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (regionCell == nil) {
        regionCell = [[[NSBundle mainBundle]loadNibNamed:@"TCRegionCell" owner:nil options:nil]firstObject];
        regionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (sendMessageCell == nil) {
        sendMessageCell = [[[NSBundle mainBundle] loadNibNamed:@"TCSendMessageCell" owner:nil options:nil]firstObject];
        sendMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        userInfo.userModel = self.userModel;
        return userInfo;
    }else if (indexPath.section == 1){
        if (self.userModel.fans) {
            fansCell.fansNumber.text = self.userModel.fans;
        }
        if (self.userModel.follows) {
            fansCell.concernNumber.text = self.userModel.follows;
        }
        return fansCell;
    }else if (indexPath.section == 2){
        if (self.userModel.province.length>0) {
            regionCell.regionLabel.text = self.userModel.province;
        }
        return regionCell;
    }
    sendMessageCell.sendMessage = ^{
        [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
        [self pushToChatViewControllerWith:self.user];
    };
    return sendMessageCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 85.0;
    }else if (indexPath.section == 1){
        return 50.0;
    }else if (indexPath.section == 2){
        return 45.0;
    }
    return 45.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}


- (void)pushToChatViewControllerWith:(IMAUser *)user{
#if kTestChatAttachment
    // 无则重新创建
    ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc withBackTitle:@"" animated:YES];
}


@end
