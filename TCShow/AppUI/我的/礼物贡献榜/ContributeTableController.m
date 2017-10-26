//
//  ContributeTableController.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContributeTableController.h"
#import "ContributeTableViewCell.h"
#import "NothingnessView.h"
@interface ContributeTableController (){
    NSMutableArray * _dataArray;
    NothingnessView * _noSourceView;
}
@end

@implementation ContributeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼物贡献榜";
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noSourceView = [[NothingnessView alloc]initWithFrame:CGRectMake(0 ,(kSCREEN_HEIGHT - 200)/2.0, kSCREEN_WIDTH, 130)];
    _noSourceView.noSourceimageView.image = [UIImage imageNamed:@"noContribute"];
    _noSourceView.noSourceLabel.text = @"还没有给你送礼,快去直播";
    [self.view addSubview:_noSourceView];
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContributeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContributeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContributeTableViewCell" owner:nil options:nil]firstObject];
    }
    if (_dataArray.count > 0) {
        cell.myRankLabel.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row + 1];
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

@end
