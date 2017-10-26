//
//  TCLiveGoodsView.m
//  TCShow
//
//  Created by tangtianshi on 16/12/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCLiveGoodsView.h"
#import "MJRefresh.h"
#import "MJExtension.h"

#import "GoosDeailHeader.h"
@implementation TCLiveGoodsView{
    MJRefreshNormalHeader *_header;
    UILabel * _stateLabel;
    TCAddGoodsForCart * _addCart;
}

- (void)addOwnViews{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _clearBg = [[UIView alloc] init];
    [self addSubview:_clearBg];
    
    _goodsTableView = [[UITableView alloc]init];
    _goodsTableView.delegate = self;
    _goodsTableView.dataSource = self;
    _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_goodsTableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_clearBg addGestureRecognizer:tap];
    [self setUpRefresh];
    _stateLabel = [UILabel label];
    _stateLabel.hidden = YES;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [_goodsTableView addSubview:_stateLabel];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _goodsTableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_goodsTableView.header beginRefreshing];
}

-(void)loadData{
    NSString *manageUid = [SARUserInfo userId];
    if (![self.merchantUid isEqualToString:manageUid]) {
        manageUid = self.merchantUid;
    }
    [[Business sharedInstance] storeGoodsList:[SARUserInfo userId] user_id:manageUid succ:^(NSString *msg, id data) {
            _stateLabel.hidden = YES;
            _dataArray = [TCGoodsManageModel mj_objectArrayWithKeyValuesArray:data context:nil];
        if (_dataArray.count == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"暂无商品"];
        }
        [_goodsTableView reloadData];
        [_goodsTableView.header endRefreshing];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
        _stateLabel.hidden = NO;
        _stateLabel.text = error;
        [_goodsTableView.header endRefreshing];
    }];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    _clearBg.frame = rect;
    
    _goodsTableView.frame = CGRectMake(0, kSCREEN_HEIGHT - 340, kSCREEN_WIDTH, 340);
    
    _stateLabel.frame = CGRectMake(0, (_goodsTableView.height - 40)/2.0, kSCREEN_WIDTH, 40);
}

- (void)onTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
}

- (void)close
{
#if kSupportFTAnimation
    [self animation:^(id selfPtr) {
        [self fadeOut:0.25 delegate:nil];
    } duration:0.3 completion:^(id selfPtr) {
        [self removeFromSuperview];
    }];
#else
    [self removeFromSuperview];
#endif
}

#pragma mark ------tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCLiveGoodsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LIVEGOODSCELL"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TCLiveGoodsTableCell" owner:nil options:nil] firstObject];
        cell.addCartDelegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsModel = _dataArray[indexPath.section];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCGoodsManageModel * manageModel = _dataArray[indexPath.row];
    //[self.goodsListDelegate inputGoodsDetailForModel:manageModel];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GOODSLISTDETAIL" object:manageModel]];
}


#pragma mark ---------cellDelegate
-(void)addGoodsForMyCart:(TCGoodsManageModel *)goodsModel{
    _addCart = [[[NSBundle mainBundle] loadNibNamed:@"TCAddGoodsForCart" owner:nil options:nil] firstObject];
    _addCart.addCartDelegate = self;
    _addCart.managerModel = goodsModel;
    _addCart.shopPrice = goodsModel.shop_price;
    _addCart.frame = CGRectMake(0, kSCREEN_HEIGHT - 356, kSCREEN_WIDTH, 356);
    [self addSubview:_addCart];
}


#pragma mark --------TCAddGoodsForCartDelegate
-(void)closeCartView{
    [_addCart removeFromSuperview];
}

-(void)inputOrderGoodsId:(NSString *)goods_id goods_number:(NSString *)goods_number{
    [_addCart removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"BUYGOODS" object:nil userInfo:@{@"goods_id":goods_id,@"goods_number":goods_number}]];
}
@end
