//
//  SelectAdressViewController.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/19.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "SelectAdressViewController.h"
#import "SelectAddressCell.h"
#import "AdressController.h"
#import "MJRefresh.h"
@interface SelectAdressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArr;
    BOOL _isDef;
}
@end

@implementation SelectAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收货地址";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSArray array];
    [self createData];
    [self createTableView];
    
    UIButton* rightBun = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBun.frame = CGRectMake(0, 0, 40, 30);
    [rightBun setTitle:@"管理" forState:UIControlStateNormal];
    rightBun.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBun addTarget:self action:@selector(management) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithCustomView:rightBun];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)createData{
    _isDef = false;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载...";
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
//            hud.hidden = YES;
       });
        
        
    }];
    
}

- (void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self setUpRefresh];

}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectAddressCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil] lastObject];
    }
    if ([_dataArr[indexPath.row][@"is_default"] doubleValue] == 1) {
       // 10 54 21
        UILabel *defLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 75, 21)];
        defLabel.text = @"[默认地址]";
        
        defLabel.textColor = [UIColor redColor];
        defLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:defLabel];
        
        cell.address.frame = CGRectMake(85, 54, kSCREEN_WIDTH - 136, 21);
        
    }
    cell.name.text = _dataArr[indexPath.row][@"consignee"];
    cell.phone.text = _dataArr[indexPath.row][@"mobile"];
    cell.address.text = _dataArr[indexPath.row][@"address"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
// 协议
    [self.delegate returnAdress:_dataArr[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;

}

- (void)management{
    AdressController *adress = [[AdressController alloc] init];
    [self.navigationController pushViewController:adress animated:YES];

}
// 刷新
-(void)setUpRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView.header beginRefreshing];
    
}

- (void)loadData{

    [self createData];
    
}

@end
