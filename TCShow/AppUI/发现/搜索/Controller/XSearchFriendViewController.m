//
//  XSearchFriendViewController.m
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XSearchFriendViewController.h"
#import "Macro.h"
#import "XSearchFriendCell.h"
#import "MBProgressHUD.h"
#import "Business.h"
#import "XSearchFriendModel.h"
#import "AFNetworking.h"
//#import "UserInfo.h"
#import "XFunListModel.h"
#import "MirrorViewController.h"
#import "MJBaseTableView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "TCUserDetailController.h"
@interface XSearchFriendViewController ()<UITableViewDelegate,UITableViewDataSource,cellDelegate,UISearchBarDelegate>{
    MJRefreshNormalHeader       *_header;           //下拉刷新
    MJRefreshBackNormalFooter   *_footer;
}

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSMutableArray *tabviewData;
@property (nonatomic,copy)NSString *searchStr;
@property (nonatomic)BOOL isConcern;
@end

@implementation XSearchFriendViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.type) {
        
        self.tableview.frame =CGRectMake(0, -54, SCREEN_WIDTH, SCREEN_HEIGHT + 44);
    }else{
        
         self.tableview.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
}

-(void)loadView{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
    
    self.tableview = [[UITableView alloc] init];
//                      WithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    
    if (self.type) {
        self.tableview.frame =CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT);
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//        _header.stateLabel.hidden = YES;
//        _header.lastUpdatedTimeLabel.hidden = YES;
        self.tableview.tableHeaderView = _header;
        
        //添加上拉加载
        _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _footer.stateLabel.hidden = YES;
        _footer.hidden = YES;
        self.tableview.tableFooterView = _footer;

    }else{
        
        self.tableview.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }

    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = VIEW_BACKGROUNDCOLOR;
}

-(void)refreshData{
    
    if (!_header.isRefreshing && !_footer.isRefreshing) {
        [_header beginRefreshing];
    }
    
    if ([self.type isEqualToString:@"1"]){
        [self funList:nil page:@"1"];
        
    }else if ([self.type isEqualToString:@"2"]){
        [self funList:@"2" page:@"1"];
        
    }
}


-(void)loadData{
    
    if (self.tabviewData.count < 15 || self.tabviewData.count % 15 != 0) {
        
        [_footer endRefreshing];
        _footer.hidden = YES;
//        _footer.mj_h = 0;
//        [_footer noticeNoMoreData];
//        _footer.stateLabel.text = @"没有更多数据";
        return;
    }
    NSUInteger page = self.tabviewData.count/15 + 1;
    NSString *pageStr = [@(page) stringValue];
    
    if ([self.type isEqualToString:@"1"]){
        [self funList:nil page:pageStr];
        
    }else if ([self.type isEqualToString:@"2"]){
        [self funList:@"2" page:pageStr];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isConcern = NO;
    self.tabviewData = [NSMutableArray array];
//    _hud = [[MBProgressHUD alloc] initWithView:self.tableview];
//    [self.view addSubview:_hud];

    if ([self.type isEqualToString:@"1"]){
        self.title = @"粉丝";
        [_header beginRefreshing];
//        [self funList:nil page:@"1"];
        
    }else if ([self.type isEqualToString:@"2"]){
        self.title = @"关注的人";
        [_header beginRefreshing];
//        [self funList:@"2" page:@"1"];

    }else{
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200 ,44)];
        searchBar.barTintColor = [UIColor clearColor];
        searchBar.tintColor = [UIColor whiteColor];
        searchBar.showsCancelButton = YES;
        searchBar.placeholder = @"请输入账号/昵称";
        searchBar.delegate = self;
        self.navigationItem.titleView = searchBar;

    }
    
        // Do any additional setup after loading the view.
    
    
//    self.tabBarController.tabBar.hidden=YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabviewData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
//    XFunListModel * model = _tabviewData[indexPath.row];
//    MirrorViewController * mirr = [[MirrorViewController alloc]init];
//    if ([_type isEqualToString:@"1"]) {
//        mirr.userId = model.user_id;
//    }else if ([_type isEqualToString:@"2"]){
//        mirr.userId = model.attention_user_id;
//    }else{
//        SDContactModel *sModel = (SDContactModel *)model;
//        mirr.userId = sModel.uid;
//    }
//    mirr.attentIs = model.is_attention;
    SDContactModel * model = self.tabviewData[indexPath.row];
    TCLiveUserList * userModel = [[TCLiveUserList alloc]init];
    userModel.is_live = model.is_live;
    userModel.phone = model.phone;
    userModel.headsmall = model.headsmall;
    userModel.uid = model.uid;
    userModel.nickname = model.nickname;
    userModel.personalized = model.personalized;
    userModel.province = @"";
    IMAUser *user = [[IMAUser alloc]init];
    user.userId = userModel.phone;
    user.icon = userModel.headsmall;
    user.remark = userModel.nickname;
    user.nickName = userModel.nickname;
    TCUserDetailController * detailController = [[TCUserDetailController alloc]init];
    detailController.user = user;
    detailController.userModel = userModel;
    [self.navigationController pushViewController:detailController animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XSearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[XSearchFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.indexpath = indexPath;
    cell.delegate = self;
    if (self.type == nil || [self.type isEqualToString:@""]) {
        SDContactModel *model = [self.tabviewData objectAtIndex:indexPath.row];

        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(model.headsmall)] placeholderImage:IMAGE(@"search_friend_head")];
        cell.nameL.text = model.nickname;
        cell.contentTitleL.text = [model.personalized length]>0?model.personalized:@"这家伙太懒，什么都没留下~";
        cell.addBtn.hidden = YES;
//        if ([model.guanzhu intValue] == 1) {
//            cell.addBtn.selected = YES;
//        }else{
//            cell.addBtn.selected = NO;
//        }
    }else{
        XFunListModel *model1 = [self.tabviewData objectAtIndex:indexPath.row];

        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,model1.img]] placeholderImage:HOLDER_HEAD];

        cell.nameL.text = model1.nickname;
        cell.contentTitleL.text = [model1.personalized length]>0?model1.personalized:@"这家伙太懒，什么都没留下~";
//        ([model1.personalized isEqualToString:@""] || model1.personalized == nil) == YES ? (cell.contentTitleL.text = @"未填写") : (cell.contentTitleL.text = model1.personalized);
        if ([self.type isEqualToString:@"2"]) {
            
            cell.addBtn.selected = YES;
        }else{
            
            if ([model1.is_attention intValue] == 0) {
                cell.addBtn.selected = NO;
            }else{
                cell.addBtn.selected = YES;
            }
        }
    
    }
    
    return cell;
    
}

#pragma mark -- 获取粉丝列表/获取我关注的列表
/* **获取粉丝列表/获取我关注的列表
 ** type 有值是我的关注列表，无值是粉丝列表
 */
-(void)funList:(NSString *)type page:(NSString *)page{
    NSDictionary *dic ;
    if (!self.userId) {
        self.userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];//注释by zxd on 2016.09.06 18:32
    }
//    NSString *uid = [UserInfo getUserId];
    if (type == nil) {
        dic = @{@"user_id":self.userId,@"page":page};
        
    }else{
        dic = @{@"user_id":self.userId,@"type":type,@"page":page};
    }
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:GET_FUN_LIST parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            [_hud hide:YES];
            if ([page intValue] == 1) {
                
                [self.tabviewData removeAllObjects];

            }
            
            NSArray *ary = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in ary) {
                XFunListModel *model = [[XFunListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.tabviewData addObject:model];
            }
            
            if (self.tabviewData.count > 14) {
                _footer.hidden = NO;
            }else{
                _footer.hidden = YES;
            }
            
            [self.tableview reloadData];
        }else{
            [_hud show:YES];

            _hud.labelText = [responseObject objectForKey:@"message"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _hud.hidden = YES;

            });
            
            
        }
        
        // 结束刷新
        [self endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self endRefreshing];

        _hud.labelText = @"请求失败，请检查网络~";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.hidden = YES;
            
        });
    }];
    
}


#pragma mark -- 添加关注 cell代理
-(void)addConcernDelegate:(NSIndexPath *)indexPath{
    NSString *accountId;
    IMAUser *user1= [[IMAUser alloc]init];
    if (self.type == nil || [self.type isEqualToString:@""]) {
        XSearchFriendModel *model = [[XSearchFriendModel alloc] init];
        model = [self.tabviewData objectAtIndex:indexPath.row];
        accountId = [NSString stringWithFormat:@"%@",model.id];
        user1.userId = model.phone;
    }else{
        XFunListModel *model1 = [self.tabviewData objectAtIndex:indexPath.row];
        accountId = [NSString stringWithFormat:@"%@",model1.user_id]; // attention_user_id -> user_id
        user1.userId = model1.phone;
    }
    
    
    [[IMAPlatform sharedInstance]asyncApplyAddFriend:user1 succ:^(NSArray *friends) {
    } fail:^(int code, NSString *msg) {
    }];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] concern:accountId uid:[SARUserInfo userId]  succ:^(NSString *msg, id data) {
        if ([self.type isEqualToString:@"1"]){
            self.title = @"粉丝";
            [self funList:nil page:@"1"];
            
        }else if ([self.type isEqualToString:@"2"]){
            self.title = @"关注的人";
            [self funList:@"2" page:@"1"];
            
        }else{
            self.isConcern = YES;
            // 刷新列表
            [self searchLiveList:self.searchStr];
        }
        
        _hud.labelText = msg;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.hidden = YES;
        });
        
    } fail:^(NSString *error) {
        _hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.hidden = YES;
        });
    }];
    
}



#pragma mark -- searchBar代理
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    self.searchStr =searchBar.text;
    if (!self.searchStr) {


        _hud.labelText = @"请输入搜索的关键字";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.hidden = YES;
        });
        return;
    }
    
    [self searchLiveList:self.searchStr];
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 获取搜索列表
-(void)searchLiveList:(NSString *)searchText{

  MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!self.isConcern) {
        hud.labelText = @"搜索中...";
    }
    [[Business sharedInstance] searchFriendFromMyList:[SARUserInfo userId] name:searchText succ:^(NSString *msg, id data) {
        [hud hide:YES];
//        [self.tabviewData removeAllObjects];
//        NSArray *listAry = data;
        self.tabviewData = [SDContactModel mj_objectArrayWithKeyValuesArray:data context:nil];
//        for (NSDictionary *dic in listAry) {
//            SDContactModel *model = [[SDContactModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.tabviewData addObject:model];
//        }
        [self.tableview reloadData];
        if (!self.isConcern) {
            [hud hide:YES];
        }
    } fail:^(NSString *error) {
        if (!self.isConcern) {
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
        }
    }];
}

-(void)endRefreshing{
    [_header endRefreshing];
    [_footer endRefreshing];
}

@end
