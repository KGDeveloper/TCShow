//
//  LMMineViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/14.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMMineViewController.h"
#import "HostProfileViewController.h"
#import "FansTableViewController.h"
#import "LemonPurseViewController.h"
#import "XXFeedbackTableViewController.h"
#import "LMStoreEditViewController.h"
#import "LMShopCarViewController.h"
#import "XXOrderBaseTableViewController.h"
#import "XXAfterSaleManagementTableViewController.h"
#import "LMStoreApplyViewController.h"
#import "LMMineView.h"
#import "XXContactCustomerServiceTableViewController.h"
#import "QZKExchangeViewController.h"


@interface LMMineViewController ()

@property (strong, nonatomic) LMMineView * mineV;

@end

@implementation LMMineViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    
    _mineV = [[LMMineView alloc] initWithFrame:self.view.frame];
    __weak typeof(self) weakself = self;
    _mineV.orderClickBlock = ^(NSInteger index) {
        if (index == 5) {
            
            XXAfterSaleManagementTableViewController *after = [[XXAfterSaleManagementTableViewController alloc]init];
            after.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:after animated:YES];
            
            
        }else {
            XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
            order.selectedIndex = (int)index;
            order.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:order animated:YES];
        }
        
    };
    _mineV.clickBlock = ^(NSInteger index) {
        switch (index) {
            case 0:
            {
                //个人资料
                HostProfileViewController *host = [[HostProfileViewController alloc] init];
                [weakself.navigationController pushViewController:host animated:YES];
            }
                break;
            case 1:
            {
                //粉丝
                FansTableViewController *fans = [[FansTableViewController alloc] init];
                fans.titleStr = @"粉丝";
                fans.type = @"2";
                [weakself.navigationController pushViewController:fans animated:YES];
            }
                break;
            case 2:
            {
                //关注
                FansTableViewController *fans = [[FansTableViewController alloc] init];
                fans.titleStr = @"关注";
                fans.type = @"1";

                [weakself.navigationController pushViewController:fans animated:YES];
            }
                break;
            case 3:
            {
                //魅力值
            }
                break;
            case 4:
            {
                //等级
                
            }
                break;
            case 5:
            {
                //充值
                LemonPurseViewController *host = [[LemonPurseViewController alloc] init];
                [weakself.navigationController pushViewController:host animated:YES];
            }
                break;
            case 6:
            {
                //兑换
                QZKExchangeViewController *qzk = [[QZKExchangeViewController alloc]init];
                qzk.ispushOrpop = @"push";
                [weakself.navigationController pushViewController:qzk animated:YES];
            }
                break;
            case 7:
            {
                //店铺
                [weakself dianpuClick];
            }
                break;
            case 8:
            {
                //官方QQ
                
            }
                break;
            case 9:
            {
                //建议
                XXFeedbackTableViewController *feedback = [[XXFeedbackTableViewController alloc] init];
                [weakself.navigationController pushViewController:feedback animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_mineV];
}

- (void)dianpuClick {
    
//    LMStoreApplyViewController *vc = [[LMStoreApplyViewController alloc] initWithNibName:@"LMStoreApplyViewController" bundle:[NSBundle mainBundle]];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    LMStoreEditViewController *seVc = [[LMStoreEditViewController alloc] init];
//    seVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:seVc animated:YES];
    

//    
   NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"uid"] = [SARUserInfo userId];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:STORE_CLICK parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        __weak typeof(self) weakself = self;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        
    if (code == 0) {
        
        LMStoreEditViewController *seVc = [[LMStoreEditViewController alloc] init];
        seVc.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:seVc animated:YES];
        
    }else {
        
        LMStoreApplyViewController *vc = [[LMStoreApplyViewController alloc] initWithNibName:@"LMStoreApplyViewController" bundle:[NSBundle mainBundle]];
        vc.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:vc animated:YES];
        
       }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];

    
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
    [self loadViewForSource];
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

-(void)loadViewForSource{
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [SARUserInfo userId];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:URL_GETUSER parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
 
        if (code == 0) {
            [_mineV refreshView:responseObject];
            [SARUserInfo saveUserInfo:responseObject[@"data"]];
        }else{
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请检查网络状况"];
    }];
    
}


-(void)setting{
    
    HostProfileViewController *host = [[HostProfileViewController alloc] init];
    [self.navigationController pushViewController:host animated:YES];
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
