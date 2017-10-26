//
//  CartViewController.m
//  Delicate
//
//  Created by tangtianshi on 16/5/18.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "CartViewController.h"
//#import "GoodsDetailsViewController.h"
#import "ConfirmOrderViewController.h"
#import "CartTableViewCell.h"
#import "CartListModel.h"
#import "MJRefresh.h"
//int i = 0;
//#import "LoginViewController.h"
@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate>
{
    UIButton *_allSelect;
    UIButton *_select;
    UILabel *_totalPrice;
    UIButton *_settlement;
    BOOL _isAllSelect;
    double _allPrice;
    NSInteger _num;
    
    NSMutableArray *_dataArr;
    CartListModel *_model;
    
    UIImageView *_all;
    
    __block   NSMutableArray *dataArray;
    
    // 传给订单的数组
    NSMutableArray *_coderArr;
    // 结算的cart_form_data字符串
    NSMutableString *_cart_form_dataStr;
    
    UILabel *_count;  // 共多少件
    int _allCount;
    
// 右导航栏上的文字
    NSString *_rightStr;
    BOOL _isEdit;
    
    UILabel *_combined;  // 合计字样
    
    UIView *_bottomView;
    
}

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [[NSMutableArray alloc] init];
    NSString *uid = [SARUserInfo userId];
    if (uid) {
        _rightStr = @"编辑";
        _isEdit = NO;
        [self nav];
        [self createData];
        
        dataArray = [[NSMutableArray alloc] init];
//         订单
        _coderArr = [[NSMutableArray alloc] init];
        
        // 结算的cart_form_data数组
        _cart_form_dataStr = [NSMutableString string];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 110) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        //设置分割线的风格
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //tableview没有数据的时候不显示线
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self createUI];
        [self setUpRefresh];

        
    }else{
    
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH - 190) / 2.0, 214, 190, 134)];
        imageView.image = [UIImage imageNamed:@"shopping"];
        [self.view addSubview:imageView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kSCREEN_WIDTH - 200) / 2, CGRectGetMaxY(imageView.frame) + 15, 200, 44);
        button.backgroundColor = YCColor(157, 5, 13, 1.0);
        [button setTitle:@"去逛逛" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shopp) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [self.view addSubview:button];
        
        UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame)+ 10, 200, 40)];
        [login setTitleColor:YCColor(157, 5, 13, 1.0) forState:UIControlStateNormal];
        [login setTitle:@"立即登录" forState:UIControlStateNormal];
        [self.view addSubview:login];
        [login addTarget:self action:@selector(details) forControlEvents:UIControlEventTouchUpInside];
    }
   
}


-(void)details{

//    LoginViewController * login = [[LoginViewController alloc]init];
//
//    [self.navigationController pushViewController:login animated:YES];
}


#pragma mark ---去逛逛
-(void)shopp{

//    JZLog(@"去逛逛");
}

#pragma mark ----导航栏按钮
-(void)right{

    
}

-(void)setUpRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView.header beginRefreshing];
    
  
    
}
- (void)loadData{
    [_dataArr removeAllObjects];
    [dataArray removeAllObjects];
    [_coderArr removeAllObjects];
    _cart_form_dataStr = [NSMutableString string];
    _allPrice = 0;
    [self price];
    _isAllSelect = NO;
    [self all];
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
            [self price];
            
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
                [dataArray addObject:dict];
                [dict setObject:@"0" forKey:@"selected"];
                [_coderArr addObject:dict];
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

- (void)createUI{
    
    float height;
    float top;
//    if (_isJump) {
        top = kSCREEN_HEIGHT - 50;
        height = 50;
//    }else{
//       top = kSCREEN_HEIGHT - 93;
//        height = 91;
//    }
    
   _bottomView
    = [[UIView alloc] initWithFrame:CGRectMake(0, top, kSCREEN_WIDTH, height)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _allSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelect.frame = CGRectMake(10, 15, 20, 20);
    [_allSelect addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_allSelect];
    _all = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_allSelect addSubview:_all];
    [self all];
    _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(140 , 7, kSCREEN_WIDTH - 205,15)];
    
    _totalPrice.textColor = [UIColor redColor];
    
    _totalPrice.textAlignment = NSTextAlignmentLeft;
    _totalPrice.font = [UIFont systemFontOfSize:15];
    [self price];
    [_bottomView addSubview:_totalPrice];
    _select = [UIButton buttonWithType:UIButtonTypeCustom];
    _select.frame = CGRectMake(40, 15, 40, 20);
    [_select addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_select];
    [_select setTitle:@"全选" forState:UIControlStateNormal];
    [_select setTitleColor:RGB(69, 69, 69) forState:UIControlStateNormal];
    _select.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _combined = [[UILabel alloc] initWithFrame:CGRectMake(90 , 7, 40, 15)];
    _combined.text = @"合计:";
    _combined.textColor = YCColor(152, 152, 152, 1);
    [_bottomView addSubview:_combined];
    _combined.font = [UIFont systemFontOfSize:15];
    
    _count = [[UILabel alloc] initWithFrame:CGRectMake(90 , 28, kSCREEN_WIDTH - 205, 15)];
//    _count.text = [NSString stringWithFormat:@"共0件"];
    _count.textColor = YCColor(152, 152, 152, 1);
    [_bottomView addSubview:_count];
    _count.font = [UIFont systemFontOfSize:15];
    
    _settlement = [UIButton buttonWithType:UIButtonTypeCustom];
    _settlement.frame = CGRectMake(kSCREEN_WIDTH - 105, 0, 105, 50);
    [_settlement setTitle:@"结算" forState:UIControlStateNormal];
    [_settlement addTarget:self action:@selector(settlement) forControlEvents:UIControlEventTouchUpInside];
    [_settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settlement.backgroundColor = kNavBarThemeColor;
    _settlement.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomView addSubview:_settlement];
}
// 时时刷新的
- (void)price{
    
    _totalPrice.text = [NSString stringWithFormat:@"¥ %.2f",_allPrice];
    _count.text =  [NSString stringWithFormat:@"共%d件",_allCount];
    
}

- (void)all{
    
    if (_isAllSelect == YES) {
        _all.image = [UIImage imageNamed:@"paySelect"];
    }else{
        _all.image = [UIImage imageNamed:@"灰圆"];
    }
    
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CartTableViewCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    [cell addValue:_dataArr[indexPath.section]];
    
    [cell.select addTarget:self action:@selector(Select:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.select.tag = indexPath.section + 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)Select:(UIButton *)sender{
    
    
    CartListModel *model = _dataArr[sender.tag - 1];
    model.isSelect = !model.isSelect;
    if (model.isSelect == YES) {
        
        _allPrice += [model.goods_price doubleValue] * [model.goods_num intValue];
        _coderArr[sender.tag -1][@"selected"] = @"1";
        _allCount += 1;
        
    }else{
        
        _isAllSelect = NO;
        [self all];
        _allPrice -= [model.goods_price doubleValue] * [model.goods_num intValue];
        _allCount -= 1;
        _coderArr[sender.tag -1][@"selected"] = @"0";
    }
    [self price];
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    JZLog(@"查看商品详情");
//    GoodsDetailsViewController *details = [[GoodsDetailsViewController alloc] init];
//    details.goodsID = _coderArr[indexPath.section][@"goods_id"];
//    [self.navigationController pushViewController:details animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (void)settlement{
    
        NSMutableString *ids = [NSMutableString string];
         for (int i = 0; i < _coderArr.count; i++) {
         NSString *isSelect = _coderArr[i][@"selected"];
         
             if ([isSelect isEqualToString:@"1"]) {
                 [ids appendString:_coderArr[i][@"id"]];
                 [ids appendString:@","];
             }
             
         }
        if (ids.length) {
         [ids deleteCharactersInRange:NSMakeRange(ids.length - 1, 1)];
         NSString *url;
         if (_isEdit) {
        // 删除
          url = DELETE_CART;
        }else{
        // 结算
          url = CLEARING_CART;
        }
         NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"ids":ids};
         [RequestData requestWithUrl:url para:para Complete:^(NSData *data) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         if ([dic[@"code"] doubleValue] == 0) {
             if (_isEdit) {
                 [_tableView.header beginRefreshing];
             }else{
                 ConfirmOrderViewController *con = [[ConfirmOrderViewController alloc] init];
//                 con.dataDic = dic[@"data"];
                 con.ids = ids;
                 con.isCart = YES;
                 [self.navigationController pushViewController:con animated:YES];
             }
         }else {
             [[HUDHelper sharedInstance] tipMessage:dic[@"message"]];
         }
         } fail:^(NSError *error) {
         
         }];
    }else{
    // 选择商品
    }
    
    
    

}
- (void)allSelect:(UIButton *)sender{
    
    _isAllSelect = !_isAllSelect;
    [self all];
    
    _allPrice = 0.00;
    _allCount = 0;
    for (int i = 0; i < _dataArr.count; i++) {
        CartListModel *model = _dataArr[i];
        if (_isAllSelect == YES) {
            model.isSelect = YES;
            _coderArr[i][@"selected"] = @"1";
            _allPrice += [model.goods_price doubleValue] * [model.goods_num intValue];
            _allCount += 1;
            
        }else{
            model.isSelect = NO;
            _coderArr[i][@"selected"] = @"0";
            
            _allPrice = 0.00;
            _allCount = 0;
        }
    }
    [self price];
    [_tableView reloadData];
    
}
#pragma mark - 增加减少的代理方法
- (void)btnClick:(UITableViewCell *)cell angFlag:(int)flag{
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    if (flag == 11) {
        // +
        CartListModel *model = _dataArr[index.section];
        
        int num = [model.goods_num intValue];
        num ++;
        
        [dataArray[index.section] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"goods_num"];
        
        model.goods_num = [NSString stringWithFormat:@"%d",num];
        [self modifyNum:index.section num:num];
        if (model.isSelect) {
            _allPrice += [model.goods_price doubleValue];
        }
        
    }else if (flag == 10){
        // -
        CartListModel *model = _dataArr[index.section];
        int num = [model.goods_num intValue];
        if (num > 1) {
            num --;
            
            if (model.isSelect) {
                _allPrice -= [model.goods_price doubleValue];
            }
            
        }
        [self modifyNum:index.section num:num];
        [dataArray[index.section] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"goods_num"];
        model.goods_num = [NSString stringWithFormat:@"%d",num];
        
    }
    
   
    
}

// 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView setEditing:NO animated:YES];
    
   
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"ids":_coderArr[indexPath.section][@"id"]};
    [RequestData requestWithUrl:DELETE_CART para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            
            // 刷新当前的section
            CartListModel *model = _dataArr[indexPath.section];
            [_dataArr removeObjectAtIndex:indexPath.section];
            [dataArray removeObjectAtIndex:indexPath.section];
            [_coderArr removeObjectAtIndex:indexPath.section];
            
            if (model.isSelect) {
                _allPrice -= [model.goods_num doubleValue] * [model.goods_price doubleValue];
                [self price];
                
            }
            [_tableView.header beginRefreshing];
            [_tableView reloadData];


        }
    } fail:^(NSError *error){
        
    }];

    
    
    
    
   
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
    
}

- (void)nav{
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithTitle:_rightStr style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;
}

- (void)rightAtemClick{
    _isEdit = !_isEdit;
   
    self.navigationItem.rightBarButtonItem = nil;
    if (_isEdit) {
        _rightStr = @"完成";
        [_settlement setTitle:@"删除商品" forState:UIControlStateNormal];
        _combined.hidden = YES;
        _totalPrice.hidden = YES;
        _count.hidden = YES;
    }else{
         _rightStr = @"编辑";
        [_settlement setTitle:@"结算" forState:UIControlStateNormal];
        _combined.hidden = NO;
        _totalPrice.hidden = NO;
        _count.hidden = NO;
    }
    [self nav];
}
// 修改商品数量
- (void)modifyNum:(NSInteger)section num:(int)num{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"cart_id":_coderArr[section][@"id"],@"goods_num":[NSString stringWithFormat:@"%d",num]};
    [RequestData requestWithUrl:MODIFY_CART_NUM para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
        
            [self price];
//            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
