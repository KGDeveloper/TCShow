//
//  AdressController.m
//  FineQuality
//
//  Created by tangtianshi on 16/5/23.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "AdressController.h"
#import "AddressTableViewCell.h"
#import "NewAddressViewController.h"
#import "MJRefresh.h"
@interface AdressController ()<UITableViewDelegate,UITableViewDataSource,AddressTableViewCellDelegate>
{
    NSMutableArray *_dataArr;
    NSString *_uid;
    BOOL _isDef;
    NSMutableDictionary * _dataDic;
    MJRefreshNormalHeader *_header;
}

@end

@implementation AdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    self.view.backgroundColor = RGB(241, 239, 250);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray arrayWithCapacity:0];
//    _uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    /**获取省市区请求*/
//    [self address];
//    [self createData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //设置分割线的风格
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tableview没有数据的时候不显示线
    _tableView.tableFooterView = [[UIView alloc] init];
    
    
    UIButton *newAddress = [[UIButton alloc] initWithFrame:CGRectMake(10, kSCREEN_HEIGHT - 40, kSCREEN_WIDTH - 20, 36)];
    [newAddress setTitle:@"新增地址" forState:UIControlStateNormal];
    [newAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newAddress.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    newAddress.layer.cornerRadius = 17;
    newAddress.backgroundColor = LEMON_MAINCOLOR;
    [self.view addSubview:newAddress];
    [newAddress addTarget:self action:@selector(newAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpRefresh];

}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**获取省市区请求*/
- (void)address{

//    [RequestData requestWithUrl:GetAddresURL Complete:^(NSData *data) {
//       
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//        
//    } fail:^(NSError *error) {
//        
//    }];

}

-(void)setUpRefresh{
    
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_tableView.header beginRefreshing];

}

- (void)loadData{
    [self createData];
}

- (void)createData{
    _isDef = false;

    
    
    NSDictionary *para = @{@"user_id":[SARUserInfo userId]};
    [RequestData requestWithUrl:GET_ADDRESS_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            _dataArr = dic[@"data"];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }else{
            // 出错
            
            
        }
        
    } fail:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
        });
        
        
    }];
    
    
    
    
    
    
    
    
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
        if ([_dataArr[indexPath.section][@"is_default"] doubleValue] == 1) {
            cell.Default.image = [UIImage imageNamed:@"iconfont-zhengque"];
            [cell.setDef setTitle:@"默认地址" forState:UIControlStateNormal];
            [cell.setDef setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
        }else{
            cell.Default.image = [UIImage imageNamed:@"灰圆"];
            [cell.setDef setTitle:@"设为默认" forState:UIControlStateNormal];
        }
    
    cell.name.text = _dataArr[indexPath.section][@"consignee"];
    cell.phoneNumber.text =  _dataArr[indexPath.section][@"mobile"];
    cell.address.text =  _dataArr[indexPath.section][@"address"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
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
//    [self showHudInView:self.view hint:@"正在加载..."];
    NSString *aid = _dataArr[indexPath.section][@"aid"];
    NSDictionary *para = @{@"aid":aid,@"uid":_uid};
//    [RequestData requestWithUrl:JZDelAddressURL para:para Complete:^(NSData *data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSString *code = dic[@"status"];
//        if ([code intValue] == 1) {
//            [self hideHud];
//            [self createData];
//            [_tableView.mj_header endRefreshing];
//            
//        }else{
//            [self showHint:@"删除失败"];
//        }
//        
//    } fail:^(NSError *error) {
//        
//    }];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
    
}

- (void)newAddress{
    
    NewAddressViewController *newAddress = [[NewAddressViewController alloc] init];
    [self.navigationController pushViewController:newAddress animated:YES];
    
}
#pragma mark - 代理
- (void)btnClick:(UITableViewCell *)cell angFlag:(int)flag{
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    if (flag == 20) {
        for (int i = 0; i<_dataArr.count; i++) {
            NSMutableDictionary * dic  = [NSMutableDictionary dictionaryWithDictionary:_dataArr[i]];
            if ([dic[@"is_default"] integerValue]==1) {
                [dic setValue:@"0" forKey:@"is_default"];
                [_dataArr replaceObjectAtIndex:i withObject:dic];
            }
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:_dataArr[index.section]];
        [dic setValue:@"1" forKey:@"is_default"];
        [_dataArr replaceObjectAtIndex:index.section withObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArr forKey:@"addressList"];
        [self createData];
        [_tableView.header endRefreshing];
//        [self showHudInView:self.view hint:@"正在设置..."];
        // 设为默认
//         NSString * iii = _dataArr[index.section][@"address_id"];
//       NSDictionary *para = @{@"user_id":_uid,@"address_id":iii,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
//        [RequestData requestWithUrl:JZSetDefaultURL para:para Complete:^(NSData *data) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//           
//            if ([dic[@"status"] doubleValue] != 1) {
//                [self showHint:@"设置默认地址失败"];
//            }else{
//                [self createData];
//                [_tableView reloadData];
//                [self showHint:@"设置默认地址成功"];
//            }
//        } fail:^(NSError *error) {
//            
//        }];
        
    }else if (flag == 21){
        
        NewAddressViewController *modify = [[NewAddressViewController alloc] init];
        modify.isModify = YES;
        modify.selectDic = index.section;
        modify.arr = [[NSMutableDictionary alloc] init];
        [modify.arr setDictionary:_dataArr[index.section]];
        NSString *place = [NSString stringWithFormat:@"%@ %@ %@",_dataArr[index.section][@"province"],_dataArr[index.section][@"city"],_dataArr[index.section][@"district"]];
       [modify.arr setObject:place forKey:@"place"];
        modify.provinceStr = _dataArr[index.section][@"province"];
         modify.cityStr = _dataArr[index.section][@"city"];
         modify.districtStr = _dataArr[index.section][@"district"];
        modify.aid = _dataArr[index.section][@"address_id"];
        [self.navigationController pushViewController:modify animated:YES];
        // 编辑
    }else if (flag == 22){
        // 删除
//        NSString *aid = _dataArr[index.section][@"address_id"];
//        NSDictionary *para = @{@"address_id":aid,@"user_id":_uid};
//        [RequestData requestWithUrl:JZDelAddressURL para:para Complete:^(NSData *data) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSString *code = dic[@"status"];
//            if ([code intValue] == 1) {
//                
//                [self createData];
//                [_tableView reloadData];
//                
//            }else{
//                
//            }
//            
//        } fail:^(NSError *error) {
//            
//        }];
        
        [_dataArr removeObjectAtIndex:index.section];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArr forKey:@"addressList"];
//        [self createData];
        [_tableView reloadData];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_dataArr) {
        [self setUpRefresh];
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

@end
