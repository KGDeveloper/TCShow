//
//  RRContributeListViewController.m
//  live
//
//  Created by admin on 16/6/7.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "RRContributeListViewController.h"
#import "RRContributeListTableView.h"
#import "AFNetworking.h"
//#import "UserInfo.h"
@interface RRContributeListViewController ()
@property(nonatomic,strong)RRContributeListTableView *tableview;

@end

@implementation RRContributeListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贡献榜";
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
    self.tableview = [[RRContributeListTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.view.frame.size.height - TABBAR_HEIGHT- STATUS_HEIGHT)];
    self.tableview.userID = self.userID;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.backgroundColor = VIEW_BACKGROUNDCOLOR;
    [self.view addSubview:self.tableview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
