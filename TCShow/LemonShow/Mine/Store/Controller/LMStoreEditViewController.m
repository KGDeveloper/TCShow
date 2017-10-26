//
//  LMStoreEditViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMStoreEditViewController.h"
#import "LMStoreEditViewCell.h"
#import "XXReleaseCommodityTableViewController.h"
#import "XXCommodityManagementViewController.h"
#import "XXTransactionManagementTableViewController.h"
#import "LMStoreOpenViewController.h"
#import "XXAfterSaleManagementTableViewController.h"

@interface LMStoreEditViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LMStoreEditViewController {
    UIScrollView *_backScrollV;
    UIView *_backTopV;
    UIImageView *_iconImageV;
    UILabel *_nameLab;
    UILabel *_phoneLab;
    UITableView *_tableView;
    NSArray *_dataArr;
    NSArray *_titleArr;
    NSMutableDictionary *_dataDict;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];//透明度
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];//透明度
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的店铺";
    _dataDict = [NSMutableDictionary dictionary];
    _backScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _backScrollV.contentSize = CGSizeMake(SCREEN_WIDTH, 630);
    _backScrollV.showsVerticalScrollIndicator = NO;
    _backScrollV.showsHorizontalScrollIndicator = NO;
    _backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backScrollV];
    // Do any additional setup after loading the view.
    _backTopV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    _backTopV.backgroundColor = LEMON_MAINCOLOR;
    [_backScrollV addSubview:_backTopV];
    
    _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 77, 80, 80)];
    _iconImageV.image = [UIImage imageNamed:@"zanwu"];
    _iconImageV.layer.cornerRadius = 40;
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.userInteractionEnabled = YES;
    [_backScrollV addSubview:_iconImageV];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 87, SCREEN_WIDTH - 130, 30)];
    _nameLab.text = @"三四五八";
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [_backScrollV addSubview:_nameLab];
    
    _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 120, SCREEN_WIDTH - 130, 30)];
    _phoneLab.text = @"13513318438";
    _phoneLab.textColor = [UIColor grayColor];
    _phoneLab.font = [UIFont systemFontOfSize:14];
    _phoneLab.textAlignment = NSTextAlignmentLeft;
    [_backScrollV addSubview:_phoneLab];
    
    _dataArr = @[@"lemon_kaidianxuzhi",@"lemon_fabubaobei",@"lemon_shangpinguanli",@"lemon_jiaoyiguanli",@"lemon_guanfang"];
    _titleArr = @[@"开店须知",@"发布宝贝",@"商品管理",@"交易管理",@"售后管理",@"联系客服"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 60 - 190)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_backScrollV addSubview:_tableView];
    [self createData];
}

- (void)createData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [SARUserInfo userId];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:URL_GETUSER parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            
            _dataDict = responseObject[@"data"];
            NSString *imgStr = _dataDict[@"headsmall"];
            if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                imgStr = IMG_APPEND_PREFIX(imgStr);
            }
            [_iconImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
            _nameLab.text = _dataDict[@"nickname"];
            _phoneLab.text = _dataDict[@"phone"];
        }else{
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请检查网络状况"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMStoreEditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMStoreEditViewCell"];
    if (!cell) {
        cell = [[LMStoreEditViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LMStoreEditViewCell"];
    }
    if (indexPath.row == 6) {
        [cell refreshViewWithImage:_dataArr[indexPath.row] Title:_titleArr[indexPath.row] Detail:@"123456789"];
    }else {
        [cell refreshViewWithImage:_dataArr[indexPath.row] Title:_titleArr[indexPath.row] Detail:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            //开店须知
            LMStoreOpenViewController *vc = [[LMStoreOpenViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            //发布宝贝
            //将我们的storyBoard实例化，“Main”为StoryBoard的名称
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MyInfoStoryboard" bundle:nil];
            
            //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
            XXReleaseCommodityTableViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"XXReleaseCommodityTableViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //商品管理
            XXCommodityManagementViewController *comm = [[XXCommodityManagementViewController alloc] init];
//            comm.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comm animated:YES];
        }
            break;
        case 3:
        {
            //交易管理
            XXTransactionManagementTableViewController *tra = [[XXTransactionManagementTableViewController alloc] init];
//            tra.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tra animated:YES];
        }
            break;
        case 4:
        {
            //售后管理
            XXAfterSaleManagementTableViewController *after = [[XXAfterSaleManagementTableViewController alloc] init];
//            after.givename = @"售后";
            [self.navigationController pushViewController:after animated:YES];
        }
            break;
            
        default:
            break;
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
