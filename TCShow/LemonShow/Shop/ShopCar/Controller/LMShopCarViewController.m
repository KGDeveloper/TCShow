//
//  LMShopCarViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopCarViewController.h"
#import "LMShopCarViewCell.h"
#import "CartListModel.h"
#import "ConfirmOrderViewController.h"
#import "AdressController.h"

@interface LMShopCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LMShopCarViewController {
    
    NSMutableArray *_dataArr;
    NSMutableArray *_selDataArr;
    MJRefreshNormalHeader *_header;
    
    UIButton *_allBtn;
    UILabel *_allPriceLab;
    UIButton *_payBtn;
    float _allPriceNum;
    NSInteger _selNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _allPriceNum = 00.00;
    _selNum = 0;
    // Do any additional setup after loading the view.  
    _dataArr = [NSMutableArray array];
    _selDataArr = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 60)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [self setUpRefresh];
    
    //调用
    [self createBottomView];
}


//创建底层View
- (void)createBottomView {
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 50 - 64, SCREEN_WIDTH, 50)];
    bottomV.backgroundColor = [UIColor whiteColor];
    _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 20)];
    [_allBtn setImage:IMAGE(@"lemon_yuan") forState:UIControlStateNormal];
    [_allBtn setImage:IMAGE(@"lemon_yuanxuanzhong") forState:UIControlStateSelected];
    [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _allBtn.selected = NO;
    [_allBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:_allBtn];
    
    _allPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, SCREEN_WIDTH - 175, 20)];
    _allPriceLab.text = @"合计：00.00元";
    _allPriceLab.textAlignment = NSTextAlignmentLeft;
    _allPriceLab.textColor = [UIColor blackColor];
    _allPriceLab.font = [UIFont systemFontOfSize:16];
    [bottomV addSubview:_allPriceLab];
    
    _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 50)];
    _payBtn.backgroundColor = [UIColor redColor];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_payBtn addTarget:self action:@selector(paybtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:_payBtn];

    [self.view addSubview:bottomV];
    
}

- (void)paybtnClick:(id)sender {
    NSMutableString *ids = [NSMutableString string];
    for (int i = 0; i < _dataArr.count; i++) {
        CartListModel *model = _dataArr[i];
        if (model.isSelect) {
            [ids appendString:model.cart_id];
            [ids appendString:@","];
        }
        
    }
    
    if (ids.length) {
        [ids deleteCharactersInRange:NSMakeRange(ids.length - 1, 1)];
        NSString *url = CLEARING_CART;
        __weak typeof(self) weakself = self;
        NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"ids":ids};
        [RequestData requestWithUrl:url para:para Complete:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] doubleValue] == 0) {
                ConfirmOrderViewController *con = [[ConfirmOrderViewController alloc] init];
                    //                 con.dataDic = dic[@"data"];
                con.ids = ids;
                con.isCart = YES;
                con.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:con animated:YES];
                
            }else if ([dic[@"message"] isEqualToString:@"请填写收货地址"]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写收货地址" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *shureBtu = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    AdressController *vc = [[AdressController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *canaleBtu = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:shureBtu];
                [alert addAction:canaleBtu];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [[HUDHelper sharedInstance] tipMessage:dic[@"message"]];
            }
        } fail:^(NSError *error) {
            [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
        }];
    }else{
        [[HUDHelper sharedInstance] tipMessage:@"请选择商品"];
    }
}

- (void)selBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        _allBtn.selected = NO;
        for (int i = 0; i < _dataArr.count; i++) {
            CartListModel *model = _dataArr[i];
            model.isSelect = NO;
            [_dataArr replaceObjectAtIndex:i withObject:model];
        }
        [_tableView reloadData];
        _allPriceNum = 00.00;
        _selNum = 0;
        _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f元",_allPriceNum];
    }else {
        [self selAll];
    }
}

- (void)selAll {
    _allPriceNum = 00.00;
    _selNum = _dataArr.count;
    _allBtn.selected = YES;
    for (int i = 0; i < _dataArr.count; i++) {
        CartListModel *model = _dataArr[i];
        model.isSelect = YES;
        [_dataArr replaceObjectAtIndex:i withObject:model];
        _allPriceNum += [model.goods_price floatValue] * [model.goods_num integerValue];
        
    }
    [_tableView reloadData];
    _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f元",_allPriceNum];
}

-(void)setUpRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    _tableView.header.
    [_tableView.header beginRefreshing];
    
    
    
}
- (void)loadData{
    [_dataArr removeAllObjects];
    [_selDataArr removeAllObjects];
    _allBtn.selected = NO;
    _allPriceLab.text = @"合计：00.00元";
//    _cart_form_dataStr = [NSMutableString string];
//    _allPrice = 0;
//    [self price];
//    _isAllSelect = NO;
//    [self all];
    [self createData];
    
}

- (void)createData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    NSDictionary *para = @{@"user_id":[SARUserInfo userId]};
    [RequestData requestWithUrl:CART_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            
            //            _allPrice = [dic[@"result"][@"total_price"][@"total_fee"] doubleValue];
//            [self price];
            
            NSArray *code = dic[@"data"];
            if (!code.count) {
                hud.labelText = @"购物车为空";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
                [_tableView reloadData];
                [_tableView.header endRefreshing];
            }else{
                
                hud.hidden = YES;
                
                for (int i = 0; i < [code count]; i++) {
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    dict = [code[i] mutableCopy];
//                    [_dataArr addObject:dict];
                    [dict setObject:@"0" forKey:@"selected"];
//                    [_coderArr addObject:dict];
                    CartListModel *model = [[CartListModel alloc] initWithDict:dict];
                    [_dataArr addObject:model];
                    
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
                [_tableView reloadData];
                [_tableView.header endRefreshing];
                
            }
        }else{
            hud.labelText = @"出错";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            [_tableView.header endRefreshing];
        }
        
    } fail:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        
    }];
    
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LMShopCarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMShopCarViewCell"];
    if (!cell) {
        cell = [[LMShopCarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LMShopCarViewCell"];
    }
    CartListModel *model = _dataArr[indexPath.row];
    [cell refreshView:model];
    cell.removeBtnClickBlock = ^{
        [_tableView.header beginRefreshing];
    };
    cell.priceNumChangeBlock = ^(NSString *string) {
        NSInteger num = [string integerValue] - [model.goods_num integerValue];
        model.goods_num = string;
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:model];
        if (cell.selBtn.selected == YES) {
            _allPriceNum += [model.goods_price floatValue] * num;
            _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f元",_allPriceNum];
        }
    };
    cell.selBtnClickBlock = ^(BOOL bl) {
        if (bl) {
            model.isSelect = YES;
            [_dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            _allPriceNum += [model.goods_price floatValue] * [model.goods_num integerValue];
            _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f元",_allPriceNum];
            _selNum += 1;
            if (_selNum == _dataArr.count) {
                _allBtn.selected = YES;
            }
        }else {
            model.isSelect = NO;
            [_dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            _allPriceNum -= [model.goods_price floatValue] * [model.goods_num integerValue];
            _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f元",_allPriceNum];
            _selNum -= 1;
            if (_selNum != _dataArr.count) {
                _allBtn.selected = NO;
            }
        }
    };
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
