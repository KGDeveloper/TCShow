//
//  GoodsDeailController.m
//  TCShow
//
//  Created by liberty on 2017/1/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GoodsDeailController.h"
#import "ItemDetailsImageTableCell.h"
#import "XXMyShopTableViewController.h"
#import "GoosDeailHeader.h"
#import "TCAddGoodsForCart.h"
#import "TCLiveUserList.h"
#import "ConfirmOrderViewController.h"
#import "TCUserDetailController.h"
#import "TCStoreGoodsListController.h"
#import "SDCycleScrollView.h"
#import "LMShopTypeSelView.h"
#import "LMShopModel.h"
#import "LMCommentViewController.h"
//#import "Collection.h"
@interface GoodsDeailController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,AddCartViewDelegate,SDCycleScrollViewDelegate>
{
    GoosDeailHeader *_headerView;
    MJRefreshNormalHeader *_header;
    NSString *_path;
    NSString * _storeUid;
    TCAddGoodsForCart * _addCart;
    NSDictionary * _goodsDic;
    
    NSMutableArray *_pinglunArray;
    NSMutableArray *_leixingArray;
}

@property(strong,nonatomic)NSString *Detailspicture;
@property(strong,nonatomic)NSString *remoakPicture;
@property(strong,nonatomic)NSArray *DetailspictureArray;
@property(strong,nonatomic)NSArray *remorkpictureArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *collection;

@end

@implementation GoodsDeailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _pinglunArray = [NSMutableArray array];
    _leixingArray = [NSMutableArray array];
    self.title = @"物品详情";
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"GoosDeailHeader" owner:self options:nil]lastObject];
    __weak typeof(self) ws = self;
    _headerView.pingjiaBtnClickBlock = ^{
        LMCommentViewController *comment = [[LMCommentViewController alloc] init];
        comment.goods_id = self.goods_id;
        [ws.navigationController pushViewController:comment animated:YES];
    };
    _headerView.diannpuBtnClickBlock = ^{
        TCStoreGoodsListController * goodsList = [[TCStoreGoodsListController alloc]init];
        goodsList.goodsDic = _goodsDic;
        [ws.navigationController pushViewController:goodsList animated:YES];
    };
    _headerView.leixingBtnClickBlock = ^{
        LMShopTypeSelView *view = [[LMShopTypeSelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        LMShopModel * manahe = [[LMShopModel alloc]init];
        manahe.goods_id = ws.goods_id;
        manahe.original_img = _goodsDic[@"goodInfo"][@"original_img"];
        manahe.shop_price = _goodsDic[@"goodInfo"][@"shop_price"];
        manahe.store_count = _goodsDic[@"goodInfo"][@"store_count"];
        view.managerModel = manahe;
        view.shopPrice = _goodsDic[@"goodInfo"][@"shop_price"];
        [view refreshUI:manahe];
        [view createLeiXing:_goodsDic[@"goodInfo"][@"goods_standard"]];
        [ws.view addSubview:view];
    };
    _headerView.loockTopBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    _headerView.inputChatBlock = ^{
        [ws inputChatView];
    };
    self.tableView.tableHeaderView = _headerView;
    [self setUpRefresh];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    

 
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark ------进入聊天页面
-(void)inputChatView{
    TCLiveUserList * model= [[TCLiveUserList alloc] init];
    model.uid = _goodsDic[@"goodInfo"][@"uid"];
    model.phone = _goodsDic[@"storeInfo"][@"store_phone"];
    model.nickname = _goodsDic[@"storeInfo"][@"nickname"];
    model.headsmall = _goodsDic[@"storeInfo"][@"headsmall"];
    model.is_live = @"0";
    model.province = @"";
    IMAUser *user = [[IMAUser alloc]init];
    user.userId = model.phone;
    user.icon = model.headsmall;
    user.remark = model.nickname;
    user.nickName = model.nickname;
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userList = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([userDef objectForKey:@"chatList"]) {
        userList = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:@"chatList"]];
    }
    [userList setObject:@{@"userName":user.nickName,@"userIcon":user.icon} forKey:user.userId];
    [[NSUserDefaults standardUserDefaults] setObject:userList forKey:@"chatList"];
    
    
    //跳转到AIO
    //        [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
    //        [self pushToChatViewControllerWith:user];
    
    TCUserDetailController * detailController = [[TCUserDetailController alloc]init];
    detailController.user = user;
    detailController.userModel = model;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Table view data source
-(void)setUpRefresh{
    
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _DetailspictureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemDetailsImageTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemDetailsImageTableCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemDetailsImageTableCell" owner:self options:nil]lastObject];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PREFIX,_DetailspictureArray[indexPath.row]]];
    [cell.ImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headurl"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}



#pragma mark ------数据请求
- (void)loadNewData{
    
    [[HUDHelper sharedInstance] syncLoading];
    [[Business sharedInstance] goodsDetailUid:[SARUserInfo userId] goods_id:_goods_id succ:^(NSString *msg, id data) {
        _goodsDic = data;

        
        _Detailspicture = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"original_img"]];
        _DetailspictureArray = [_Detailspicture componentsSeparatedByString:@";"];
        _headerView.goodsName.text = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"goods_name"]];
        _headerView.price.text = [[Business sharedInstance] is_NullStringChange:[NSString stringWithFormat:@"¥%@",data[@"goodInfo"][@"shop_price"]]];
        _remoakPicture = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"goods_remark"]];
        _remorkpictureArray = [_remoakPicture componentsSeparatedByString:@";"];
        _headerView.commLab.text = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"goods_remark"]];
        _headerView.userName.text = [[Business sharedInstance] is_NullStringChange:data[@"storeInfo"][@"nickname"]];
        [self goodsScrollView];
        _headerView.saleNumber.text = [[Business sharedInstance] is_NullStringChange:[NSString stringWithFormat:@"月销%@笔",data[@"goodInfo"][@"sales_sum"]]];
        _headerView.province.text = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"province"]];
        _headerView.allNumber.text = [[Business sharedInstance] is_NullStringChange:data[@"storeInfo"][@"allgoods_num"]];
        _headerView.collection.text = [[Business sharedInstance] is_NullStringChange:data[@"storeInfo"][@"focus_num"]];
        NSString *imgStr = [[Business sharedInstance] is_NullStringChange:data[@"storeInfo"][@"headsmall"]];
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_headerView.userIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"headurl"]];
        if ([data[@"goodInfo"][@"is_collect"] integerValue] == 1) {
            [self.collection setImage:[UIImage imageNamed:@"my_store_collection"] forState:UIControlStateNormal];
        }else{
            [self.collection setImage:[UIImage imageNamed:@"my_store_favourite"] forState:UIControlStateNormal];
        }
        _storeUid = [[Business sharedInstance] is_NullStringChange:data[@"goodInfo"][@"uid"]];
        [[HUDHelper sharedInstance] syncStopLoading];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] syncLoading:error];
        [self.tableView.header endRefreshing];
    }];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_id"] = [SARUserInfo userId];
    dic[@"pageSize"] = @"1";
    dic[@"goods_id"] = self.goods_id;
    
    [mgr POST:COMMENT_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        _pinglunArray = responseObject[@"data"];
        
        if (_pinglunArray.count != 0) {
            NSDictionary *dict = _pinglunArray[0];
            _headerView.appraiseDes.hidden = NO;
            _headerView.appraiseIcon.hidden = NO;
            _headerView.appraiseName.hidden = NO;
            _headerView.appraiseZanwu.hidden = YES;
            
            _headerView.appraiseDes.text = dict[@"content"];
            _headerView.appraiseName.text = dict[@"username"];
            NSString *imgStr =dict[@"img"];
            if ([imgStr isEqual:[NSNull null]] || imgStr ==nil) {
                
                imgStr =@"";
                
                if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                    imgStr = IMG_APPEND_PREFIX(imgStr);
                }
                
            }
            [_headerView.appraiseIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
            
        }else {
            _headerView.appraiseDes.hidden = YES;
            _headerView.appraiseIcon.hidden = YES;
            _headerView.appraiseName.hidden = YES;
            _headerView.appraiseZanwu.hidden = NO;
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];
    
    
}


#pragma mark ------添加商品图片轮播图
-(void)goodsScrollView{
//    [_headerView.fmImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_DetailspictureArray[0])] placeholderImage:IMAGE(@"headurl")];
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, _headerView.fmImage.height) delegate:self placeholderImage:IMAGE(@"001")];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_headerView.fmImage addSubview:cycleScrollView];
    NSMutableArray * imgAry = [NSMutableArray arrayWithCapacity:0];
    for (NSString *imagePath in _DetailspictureArray) {
        [imgAry addObject:IMG_APPEND_PREFIX(imagePath)];
    }
    cycleScrollView.imageURLStringsGroup = imgAry;
}





#pragma mark ------收藏
- (IBAction)collect:(UIButton *)sender {
    [[HUDHelper sharedInstance]syncLoading];
    [[Business sharedInstance] goodsCollectState:[SARUserInfo userId] goods_id:self.goods_id succ:^(NSString *msg, id data) {
        if ([data integerValue] == 0) {
            [self.collection setImage:[UIImage imageNamed:@"my_store_collection"] forState:UIControlStateNormal];
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"收藏成功"];
        }else if([data integerValue]== 1){
            [self.collection setImage:[UIImage imageNamed:@"my_store_favourite"] forState:UIControlStateNormal];
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"取消收藏"];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance]syncStopLoadingMessage:error];
    }];
}


#pragma mark -----------客服
- (IBAction)customer:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10086", nil];
    action.tag = 1;
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * url = [NSString stringWithFormat:@"telprompt://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
        
        [self openMyUrl:url];
    }
    
}

#pragma mark - 调用方法
- (void)openMyUrl:(NSString *)url{
    //转换为NSURL类型
    NSURL * myUrl = [NSURL URLWithString:url];
    
    //应判断设备是否支持功能,或者设备上是否安装该应用程序
    UIApplication * app = [UIApplication sharedApplication];
    
    if (![app canOpenURL:myUrl]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备无此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }else{
        
        [app openURL:myUrl];
    }
}


#pragma mark --------店铺
- (IBAction)store:(UIButton *)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MyInfoStoryboard" bundle:[NSBundle mainBundle]];
//    XXMyShopTableViewController *mevc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([XXMyShopTableViewController class])];
//    mevc.storeType = @"1";
//    mevc.stroeUid = _storeUid;
//    [self.navigationController pushViewController:mevc animated:YES];
    TCStoreGoodsListController * goodsList = [[TCStoreGoodsListController alloc]init];
    goodsList.goodsDic = _goodsDic;
    [self.navigationController pushViewController:goodsList animated:YES];
}


#pragma mark -------加入购物车
- (IBAction)addCart:(UIButton *)sender {
//    _addCart = [[[NSBundle mainBundle] loadNibNamed:@"TCAddGoodsForCart" owner:nil options:nil] firstObject];
//    _addCart.addCartDelegate = self;
//    TCGoodsManageModel * manahe = [[TCGoodsManageModel alloc]init];
//    manahe.goods_id = self.goods_id;
//    manahe.original_img = _goodsDic[@"goodInfo"][@"original_img"];
//    manahe.shop_price = _goodsDic[@"goodInfo"][@"shop_price"];
//    manahe.store_count = _goodsDic[@"goodInfo"][@"store_count"];
//    _addCart.managerModel = manahe;
//    _addCart.shopPrice = _goodsDic[@"goodInfo"][@"shop_price"];
//    _addCart.frame = CGRectMake(0, kSCREEN_HEIGHT - 356, kSCREEN_WIDTH, 356);
//    [self.view addSubview:_addCart];
    LMShopTypeSelView *view = [[LMShopTypeSelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    LMShopModel * manahe = [[LMShopModel alloc]init];
    manahe.goods_id = self.goods_id;
    manahe.original_img = _goodsDic[@"goodInfo"][@"original_img"];
    manahe.shop_price = _goodsDic[@"goodInfo"][@"shop_price"];
    manahe.store_count = _goodsDic[@"goodInfo"][@"store_count"];
    view.managerModel = manahe;
    view.shopPrice = _goodsDic[@"goodInfo"][@"shop_price"];
    [view refreshUI:manahe];
    [view createLeiXing:_goodsDic[@"goodInfo"][@"goods_standard"]];
    
    [self.view addSubview:view];
}

-(void)closeCartView{
    [_addCart removeFromSuperview];
}

#pragma mark ------加入购物车中立即购买
-(void)inputOrderGoodsId:(NSString *)goods_id goods_number:(NSString *)goods_number{
    ConfirmOrderViewController * order = [[ConfirmOrderViewController alloc]init];
    order.goods_num = goods_number;
    order.isCart = NO;
    order.goods_id = goods_id;
    [_addCart removeFromSuperview];
    [self.navigationController pushViewController:order animated:YES];
}

#pragma mark -------立即购买页面
- (IBAction)buy:(UIButton *)sender {
    _addCart = [[[NSBundle mainBundle] loadNibNamed:@"TCAddGoodsForCart" owner:nil options:nil] firstObject];
    _addCart.addCartDelegate = self;
    TCGoodsManageModel * manahe = [[TCGoodsManageModel alloc]init];
    manahe.goods_id = self.goods_id;
    manahe.original_img = _goodsDic[@"goodInfo"][@"original_img"];
    manahe.shop_price = _goodsDic[@"goodInfo"][@"shop_price"];
    manahe.store_count = _goodsDic[@"goodInfo"][@"store_count"];
    _addCart.managerModel = manahe;
    _addCart.shopPrice = _goodsDic[@"goodInfo"][@"shop_price"];
    _addCart.frame = CGRectMake(0, kSCREEN_HEIGHT - 356, kSCREEN_WIDTH, 356);
    [self.view addSubview:_addCart];
}



@end
