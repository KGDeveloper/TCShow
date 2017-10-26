//
//  LMShopHomeViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopHomeViewController.h"
#import "LMShopHomeViewCell1.h"
#import "LMShopHomeViewCell2.h"
#import "GoodsDeailController.h"
#import "LMShopModel.h"

@interface LMShopHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LMShopHomeViewController{
    
    NSMutableArray *_headDataArray;
    NSMutableArray *_dataArr;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoFooter *_footer;
    NSInteger _pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [NSMutableArray array];
    _headDataArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [self setUpRefresh];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAllData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
    _footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer = _footer;
}

- (void)loadMoreData {
    _pageIndex++;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [SARUserInfo userId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    
    [mgr POST:NEW_GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            _dataArr = [LMShopModel mj_objectArrayWithKeyValuesArray:arr];
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [self.tableView.footer endRefreshing];
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];

}

- (void)loadAllData {
    
    _pageIndex = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [SARUserInfo userId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    
    [mgr POST:GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            _headDataArray = [LMShopModel mj_objectArrayWithKeyValuesArray:arr];
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [self.tableView.header endRefreshing];
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];
    
    [mgr POST:NEW_GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            _dataArr = [LMShopModel mj_objectArrayWithKeyValuesArray:arr];
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [self.tableView.header endRefreshing];
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];
    
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return _dataArr.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backV.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    imageV.image = IMAGE(@"lemon_dian");
    [backV addSubview:imageV];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 60, 40)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:16];
    if (section == 0) {
        lab.text = @"爆款推荐";
    }else {
        lab.text = @"口碑排行";
    }
    [backV addSubview:lab];
    return backV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LMShopHomeViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"LMShopHomeViewCell1"];
        if (!cell) {
            cell = [[LMShopHomeViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LMShopHomeViewCell1"];
        }
        [cell refreshView:_headDataArray];
        __weak typeof(self) weakself = self;
        
        cell.btnClickBlock = ^(NSInteger index) {
            
            LMShopModel *model = _headDataArray[index];
            GoodsDeailController *vc = [[GoodsDeailController alloc] init];
            vc.goods_id = model.goods_id ;
            vc.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }else {
        LMShopHomeViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"LMShopHomeViewCell2"];
        if (!cell) {
            cell = [[LMShopHomeViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LMShopHomeViewCell2"];
        }
        LMShopModel *model = _dataArr[indexPath.row];
        [cell refreshUI:model];
        cell.carBtnClickBlock = ^{
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShopModel *model = _dataArr[indexPath.row];
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id = model.goods_id ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }else {
        return 150;
    }
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
