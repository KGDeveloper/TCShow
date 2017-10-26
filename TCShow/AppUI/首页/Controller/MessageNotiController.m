


//
//  MessageNotiController.m
//  TCShow
//
//  Created by tangtianshi on 16/10/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MessageNotiController.h"
#import "MessageNotiCell.h"
@interface MessageNotiController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
}

@end

@implementation MessageNotiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YCColor(241, 239, 250, 1.0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息通知";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84, kSCREEN_WIDTH, kSCREEN_HEIGHT - 84) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
    
    
#pragma mark -------tabelViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
    
#pragma mark --------tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageNotiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageNotiCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
