//
//  XDMineController.m
//  TCShow
//
//  Created by tangtianshi on 2016/10/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XDMineController.h"
#import "SettingViewController.h"
#import "ConversationListViewController.h"
#import "FansTableViewController.h"
#import "XXBrowsHistoryTableController.h"
#import "MoneyRecordTableController.h"
#import "CartViewController.h"
#import "XXNotifierProPlusTableViewController.h"
#import "XXMyShopTableViewController.h"
#import "XXOrderBaseTableViewController.h"
#import "LemonPurseViewController.h"
@interface XDMineController ()
{
    UIButton *_settingBtn;
//    NSArray *_fansArr;
    NSArray *_focusArr;
    
}
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab; //  昵称
@property (weak, nonatomic) IBOutlet UILabel *usernameLab; // 账号
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLab; // 粉丝数
@property (weak, nonatomic) IBOutlet UILabel *focusNumLab; // 关注数
@property (weak, nonatomic) IBOutlet UIView *fansView;  // 粉丝View
@property (weak, nonatomic) IBOutlet UIView *focusView;  // 关注View
@property (weak, nonatomic) IBOutlet UIView *bmgView;
@property (weak, nonatomic) IBOutlet UILabel *CoinsNumLab; // 钻石数
@property (weak, nonatomic) IBOutlet UIView *conisView; // 钻石 View

@end

@implementation XDMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
   
//    _fansArr = [NSArray array];
    _focusArr = [NSArray array];
    [self configUI];
//    [self createData:@"1"];
//    [self createData:@"2"];
    UIBarButtonItem *leftAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAtemClick)];
//    self.navigationItem.leftBarButtonItem = leftAtem;
    
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_msg"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.frame = CGRectMake(kSCREEN_WIDTH - 90, -2, 44, 44);
    [_settingBtn setImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_settingBtn];
    [_settingBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _settingBtn.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//颜色
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];//透明度
    [self loadViewForSource];
}

-(void)viewWillDisappear:(BOOL)animated{
    _settingBtn.hidden = YES;
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = RGB(251, 62, 50);
    //    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//颜色
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];//透明度
}



#pragma mark ------数据请求
-(void)loadViewForSource{
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [SARUserInfo userId];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:URL_GETUSER parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSString *imgStr = responseObject[@"data"][@"headsmall"];
            if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                imgStr = IMG_APPEND_PREFIX(imgStr);
            }
            [_img sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"default_head"]];
            self.nicknameLab.text = responseObject[@"data"][@"nickname"];
            self.usernameLab.text = responseObject[@"data"][@"phone"];
            self.fansNumLab.text = responseObject[@"data"][@"fans_num"];
            self.focusNumLab.text = responseObject[@"data"][@"follow_num"];
            self.CoinsNumLab.text = responseObject[@"data"][@"diamonds_coins"];
            [SARUserInfo saveUserInfo:responseObject[@"data"]];
        }else{
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请检查网络状况"];
    }];

}


#pragma mark ------界面搭建
-(void)configUI{

    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _nicknameLab.text = [SARUserInfo nickName];
    _usernameLab.text = [SARUserInfo userPhone];
    if ([[SARUserInfo gainUserInfo] objectForKey:@"follow_num"]) {
        _focusNumLab.text = [[SARUserInfo gainUserInfo] objectForKey:@"follow_num"];
    }
    if ([[SARUserInfo gainUserInfo] objectForKey:@"fans_num"]) {
           _fansNumLab.text = [[SARUserInfo gainUserInfo] objectForKey:@"fans_num"];
    }
    if ([SARUserInfo headUrl]) {
        NSString *imgStr = [SARUserInfo headUrl];
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
         [_img sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"mine_placeholder")];
    }
    [_img cornerViewWithRadius:30];
    _fansView.tag = 55;
    _focusView.tag = 56;
    UITapGestureRecognizer *tapFans = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fans:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fans:)];
    UITapGestureRecognizer *tapCoins = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coinsViewClick:)];
    [_conisView addGestureRecognizer:tapCoins];
    [_fansView addGestureRecognizer:tapFans];
    [_focusView addGestureRecognizer:tap];
    ;
}

- (void)coinsViewClick:(id)sender {
    LemonPurseViewController *purseVc = [[LemonPurseViewController alloc] init];
    [self.navigationController pushViewController:purseVc animated:YES];
}


-(void)setting{

    SettingViewController *vc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 导航栏右按钮
-(void)rightAtemClick{
    
//    XXNotifierProPlusTableViewController * message = [[XXNotifierProPlusTableViewController alloc]init];
//    [self.navigationController pushViewController:message animated:YES];
    ConversationListViewController * message = [[ConversationListViewController alloc]init];
    message.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
    
}
// 导航栏左按钮
- (void)leftAtemClick{

}

- (IBAction)orderClick:(UIButton *)sender {
    if (sender.tag == 66) {
        // 待付款
        XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
        order.selectedIndex = 1;
        
        [self.navigationController pushViewController:order animated:YES];

    }else if (sender.tag == 67){
    // 待收货
        XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
        order.selectedIndex = 2;
        [self.navigationController pushViewController:order animated:YES];

    }else if (sender.tag == 68){
        // 待评价
        XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
        order.selectedIndex = 3;
        [self.navigationController pushViewController:order animated:YES];

    }else{
    // 退款
        XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
        order.selectedIndex = 4;
        [self.navigationController pushViewController:order animated:YES];

    }
}

- (void)fans:(UITapGestureRecognizer *)tap{
    FansTableViewController *fans = [[FansTableViewController alloc] init];
    
    if (tap.view.tag == 55) {
        fans.titleStr = @"粉丝";
//        fans.dataArr = _fansArr;
        fans.type = @"2";
    }else{
              
    // 关注
        fans.titleStr = @"关注";
//        fans.dataArr = _focusArr;
        fans.type = @"1";
        
    }
    [self.navigationController pushViewController:fans animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 全部订单
        XXOrderBaseTableViewController *order = [[XXOrderBaseTableViewController alloc] init];
        order.selectedIndex = 0;
        [self.navigationController pushViewController:order animated:YES];

        
    }else if (indexPath.row == 0){
        CartViewController *shop = [[CartViewController alloc] init];
        [self.navigationController pushViewController:shop animated:YES];
 
    // 购物车
    }else if (indexPath.row == 1){
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MyInfoStoryboard" bundle:[NSBundle mainBundle]];
//        XXMyShopTableViewController *mevc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([XXMyShopTableViewController class])];
//         [self.navigationController pushViewController:mevc animated:YES];
//        
       

        // 我的店铺
    }else if (indexPath.row == 2){
        // 账单明细
        MoneyRecordTableController *money = [[MoneyRecordTableController alloc] init];
        [self.navigationController pushViewController:money animated:YES];

    }else if (indexPath.row == 3){
        // 收藏
        XXBrowsHistoryTableController *brows = [[XXBrowsHistoryTableController alloc] init];
        brows.titleStr = @"收藏";
        [self.navigationController pushViewController:brows animated:YES];

    }else{
    // 浏览足记
        XXBrowsHistoryTableController *brows = [[XXBrowsHistoryTableController alloc] init];
        brows.titleStr = @"浏览足记";
        [self.navigationController pushViewController:brows animated:YES];
    }






}




@end
