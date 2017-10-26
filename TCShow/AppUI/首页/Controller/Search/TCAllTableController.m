//
//  TCAllTableController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCAllTableController.h"
#import "TCSearchCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TCSearchModel.h"
@interface TCAllTableController (){
    MJRefreshNormalHeader *_header;
}
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation TCAllTableController
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] homeSearchSucc:^(NSString *msg, id data) {
        _dataArr = [TCSearchModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        hud.hidden = YES;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(NSString *error) {
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [self.tableView.header endRefreshing];
        });
    } name:self.searchName goodsID:nil order:nil page:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSearchCell * searchCell = [tableView dequeueReusableCellWithIdentifier:@"TCSEARCHCELL"];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle] loadNibNamed:@"TCSearchCell" owner:nil options:nil] firstObject];
    }
    searchCell.searchModel = _dataArr[indexPath.row];
    return searchCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0;
}


@end
