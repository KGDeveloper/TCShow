//
//  XXMyShopTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXMyShopTableViewController.h"
#import "XXNotifierProPlusTableViewController.h"
#import "XXReleaseCommodityTableViewController.h"
#import "XXTransactionManagementTableViewController.h"
#import "XXCommodityManagementViewController.h"
#import "XXContactCustomerServiceTableViewController.h"
#import "XXAfterSaleManagementTableViewController.h"


@interface XXMyShopTableViewController ()
//@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *orderViews;
@property (weak, nonatomic) IBOutlet UIImageView *img; // 头像
@property (weak, nonatomic) IBOutlet UILabel     *storeName; // 店铺名
@property (weak, nonatomic) IBOutlet UILabel     *concern;  // 关注人数
@property (weak, nonatomic) IBOutlet UILabel     *obligation;//待付款
@property (weak, nonatomic) IBOutlet UILabel     *receiving;//待发货
@property (weak, nonatomic) IBOutlet UILabel     *drawback;//退款中
@property (weak, nonatomic) IBOutlet UILabel     *order;//今日订单
@property (weak, nonatomic) IBOutlet UILabel     *money;//今日成交额
@property (weak, nonatomic) IBOutlet UILabel     *sellNumber;//已售商品

@end

@implementation XXMyShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_img cornerViewWithRadius:30];
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_msg"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;

    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self tapForOderViews];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//颜色
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];//透明度
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = RGB(251, 62, 50);
    //    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//颜色
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];//透明度
}



// 导航栏右按钮
-(void)rightAtemClick{
    
    ConversationListViewController * message = [[ConversationListViewController alloc]init];
    message.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark ------数据请求
-(void)loadData{
//    NSString * uidStr = [SARUserInfo userId];
//    if ([self.storeType integerValue] == 1) {
//        uidStr = _stroeUid;
//    }
    
    
    
    [[Business sharedInstance] getStoreInfoUid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        [self updateView:data];
        [self.tableView reloadData];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
}

-(void)updateView:(NSDictionary *)userInfoDic{
    [_img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(userInfoDic[@"headsmall"])] placeholderImage:IMAGE(@"mine_placeholder")];
    _storeName.text = userInfoDic[@"nickname"];
    _concern.text = [NSString stringWithFormat:@"%@人关注",userInfoDic[@"focus_num"]];
    _obligation.text = userInfoDic[@"waitpay"];
    _receiving.text = userInfoDic[@"waitsend"];
    _drawback.text = userInfoDic[@"refunding"];
    _order.text = userInfoDic[@"today_order"];
    _money.text = userInfoDic[@"today_order_money"];
    _sellNumber.text = userInfoDic[@"is_sales"];
}


-(void)tapForOderViews{
//    for (UIView * orderView in self.orderViews) {
//        UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewTap:)];
//        [orderView addGestureRecognizer:viewTap];
//    }
}


#pragma mark -------订单选项
-(void)orderViewTap:(UITapGestureRecognizer *)tapView{
    NSInteger  tapTag = tapView.view.tag;
    switch (tapTag) {
        case 800:
            break;
        case 801:
            break;
        case 802:
            break;
        case 803:
            break;
        case 804:
            break;
        case 805:
            break;
        default:
            break;
    }
}

-(void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if(indexPath.row == 1){
        // 交易管理
            
            XXTransactionManagementTableViewController *tra = [[XXTransactionManagementTableViewController alloc] init];
            [self.navigationController pushViewController:tra animated:YES];
        }else if (indexPath.row == 2){
        // 商品管理
            XXCommodityManagementViewController *comm = [[XXCommodityManagementViewController alloc] init];
            [self.navigationController pushViewController:comm animated:YES];
        }else if (indexPath.row == 3){
            
        // 联系客服
            XXContactCustomerServiceTableViewController *contact = [[XXContactCustomerServiceTableViewController alloc] init];
            [self.navigationController pushViewController:contact animated:YES];
        }else if (indexPath.row == 4){
        // 售后管理
            XXAfterSaleManagementTableViewController *after = [[XXAfterSaleManagementTableViewController alloc] init];
            after.giveStatus = @"商家";
            [self.navigationController pushViewController:after animated:YES];
        }
        else if (indexPath.row == 5){
            // 售后管理
            XXAfterSaleManagementTableViewController *after = [[XXAfterSaleManagementTableViewController alloc] init];
            [self.navigationController pushViewController:after animated:YES];
        }

}

@end
