//
//  XXSellTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXSellTableViewController.h"
#import "XXBrowsHistoryTableCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TCGoodsManageModel.h"
#import "GoodsDeailController.h"
@interface XXSellTableViewController ()
{
    MJRefreshNormalHeader *_header;
}
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation XXSellTableViewController
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 241, 250);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUpRefresh];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

-(void)loadData{
    [[HUDHelper sharedInstance] syncLoading:@"正在加载"];
    [[Business sharedInstance] goodsManageUid:[SARUserInfo userId] type:_goodsType succ:^(NSString *msg, id data) {
        _dataArr = [TCGoodsManageModel mj_objectArrayWithKeyValuesArray:data context:nil];
        [[HUDHelper sharedInstance] syncStopLoading];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } page:nil fail:^(NSString *error) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
        [self.tableView.header endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXBrowsHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXBrowsHistoryTableCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXBrowsHistoryTableCell" owner:self options:nil]lastObject];
    }
    TCGoodsManageModel * model = _dataArr[indexPath.section];
    cell.goodsModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCGoodsManageModel *model = _dataArr[indexPath.section];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.goods_id forKey:@"goods_id"];
    [dic setValue:[SARUserInfo userId] forKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:DELE_GOODS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    // 删除模型
    [_dataArr removeObjectAtIndex:indexPath.section];
    
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];

}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCGoodsManageModel * manageModel = _dataArr[indexPath.section];
    GoodsDeailController * detail = [[GoodsDeailController alloc]init];
    detail.goods_id = manageModel.goods_id;
    [self.navigationController pushViewController:detail animated:YES];
}



@end
