//
//  TCStoreGoodsListController.m
//  TCShow
//
//  Created by tangtianshi on 17/1/13.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCStoreGoodsListController.h"
#import "TCGoodsManageModel.h"
#import "GoodsDeailController.h"
@interface TCStoreGoodsListController ()<AddGoodsCartDelegate>{
    MJRefreshNormalHeader *_header;
    NSMutableArray * _dataSource;
}
@end

@implementation TCStoreGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@的店铺",self.goodsDic[@"storeInfo"][@"nickname"]];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self setUpRefresh];
}

-(void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}


-(void)loadData{
    [[HUDHelper sharedInstance] syncLoading];
    [[Business sharedInstance] storeGoodsList:[SARUserInfo userId] user_id:_goodsDic[@"goodInfo"][@"uid"] succ:^(NSString *msg, id data) {
        [[HUDHelper sharedInstance] syncStopLoading];
        _dataSource = [TCGoodsManageModel mj_objectArrayWithKeyValuesArray:data context:nil];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
        [self.tableView.header endRefreshing];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCLiveGoodsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LIVEGOODSCELL"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TCLiveGoodsTableCell" owner:nil options:nil] firstObject];
        cell.addCartDelegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsModel = _dataSource[indexPath.section];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCGoodsManageModel * manageModel = _dataSource[indexPath.row];
    GoodsDeailController * detail = [[GoodsDeailController alloc]init];
    detail.goods_id = manageModel.goods_id;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark ---------cellDelegate
-(void)addGoodsForMyCart:(TCGoodsManageModel *)goodsModel{
    [[HUDHelper sharedInstance] syncLoading];
    [[Business sharedInstance] goodsAddCartUid:[SARUserInfo userId] goods_id:goodsModel.goods_id goods_num:@"1" succ:^(NSString *msg, id data) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"商品已加入购物车"];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
    }];
}


@end
