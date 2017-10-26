//
//  TCCharmShowViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCCharmShowViewController.h"
#import "TCCharmModel.h"
#import "TCCharmTableViewCell.h"

@interface TCCharmShowViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TCCharmShowViewController {
    
    NSMutableArray *_dataArr;
    MJRefreshNormalHeader *_header;
}

/**
 首页的
 */
/**
 排行榜
 */
/**
 搜索
 */
/**
 实现controller
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _dataArr = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    if (self.uid) {
        self.title = @"贡献榜";
        [self loadData];
    }else {
        self.title = @"排行榜";
        [self setUpRefresh];
    }
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
    if (!self.uid) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAllData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

- (void)loadAllData {
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *param = @{@"uid":[SARUserInfo userId], @"page":@"1"};
    
    [manager POST:GIFT_ALLRANKING parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [_dataArr removeAllObjects];
            NSArray *arr = responseObject[@"data"];
            for (int i = 0; i < arr.count; i++) {
                TCCharmModel *model = [TCCharmModel mj_objectWithKeyValues:arr[i]];
                [_dataArr addObject:model];
            }
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }else{
            [[HUDHelper sharedInstance] tipMessage:@"暂无数据"];
            [_tableView.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"暂无数据"];
        [_tableView.header endRefreshing];
    }];

}

- (void)loadData {
    
    NSDictionary *dic = @{@"uid":self.uid, @"user_id":[SARUserInfo userId]};
    
    [[Business sharedInstance] postCharmsRankWithParam:dic succ:^(NSString *msg, id data) {
        NSArray *arr = data;
        if (arr.count > 0) {
            for (int i = 0; i < arr.count; i++) {
                TCCharmModel *model = [TCCharmModel mj_objectWithKeyValues:arr[i]];
                [_dataArr addObject:model];
            }
            [_tableView reloadData];
        }else {
            [[HUDHelper sharedInstance] tipMessage:@"暂无数据"];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCharmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TCCharmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TCCharmModel *model = _dataArr[indexPath.row];
    [cell initUIWith:model index:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }else {
        return 50;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//}

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
