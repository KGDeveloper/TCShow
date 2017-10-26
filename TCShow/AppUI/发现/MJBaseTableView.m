//
//  MJBaseTableView.m
//  live
//
//  Created by AlexiChen on 15/10/12.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "MJBaseTableView.h"
#import "WatchLiveTableViewCell.h"
//#import "MyLiveViewController.h"
#import "Macro.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
//#import "UserInfo.h"
//#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Category.h"
#import "SegmentView.h"
//#import "LiveTrailerTableViewCell.h"
#import "MBProgressHUD.h"
#import "Business.h"
//#import "TrailerAlertView.h"
#import "AppDelegate.h"

#import "XConcernCell.h"

//#import "WatchLiveViewController.h"
//#import "MultiVideoViewController.h"

//#import "LivePlaybackViewController.h"

//#import "BaseNavigationController.h"

@interface MJBaseTableView ()
{
    UIImageView *iconImgV_; // 无数据图标
    UILabel *titleLbl_; // 无数据标题
    
}
@end

@implementation MJBaseTableView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _datas = [NSMutableArray array];
        
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _header.stateLabel.hidden = YES;
        _header.lastUpdatedTimeLabel.hidden = YES;
        self.header = _header;
        
        //添加上拉加载
        _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _footer.stateLabel.hidden = YES;
        self.footer = _footer;
    }
    return self;
}

- (void)handleCellClick:(CellClickBlock)block
{
    _cBlock = block;
}

- (void)beginRefreshing
{
    if (!_header.isRefreshing && !_footer.isRefreshing) {
        [_header beginRefreshing];
    }
}

- (void)refreshData
{
    pageNo_ = 1;
}

- (void)loadData
{
    pageNo_++;
}


- (void)startRefreshTimer
{
//    [_refreshTimer invalidate];
//    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
}
- (void)stopRefreshTimer
{
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)showNoDataView:(NSString *)imgName title:(NSString *)title
{
    if (!iconImgV_) {
        // 图标
        iconImgV_ = [[UIImageView alloc] init];
        iconImgV_.frame = CGRectMake(0, 0, 60, 60);
        CGSize size = self.frame.size;
        iconImgV_.center = CGPointMake(size.width/2, size.height/2-25);
        iconImgV_.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImgV_];
        // 标题
        titleLbl_ = [[UILabel alloc] init];
        titleLbl_.font = [UIFont systemFontOfSize:13.f];
        titleLbl_.textColor = [UIColor colorWithRed:152./255 green:152./255 blue:152./255 alpha:1];
        titleLbl_.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl_];
    }
    iconImgV_.hidden = NO;
    titleLbl_.hidden = NO;
    iconImgV_.image = [UIImage imageNamed:imgName];
    titleLbl_.text = title;
    CGSize lblSize = [titleLbl_ sizeThatFits:CGSizeMake(self.frame.size.width-20, 100)];
    titleLbl_.frame = CGRectMake(0, 0, lblSize.width,lblSize.height);
    titleLbl_.center = CGPointMake(iconImgV_.center.x, CGRectGetMaxY(iconImgV_.frame)+lblSize.height/2+10);
    
}

- (void)hideNoDataView
{
    iconImgV_.hidden = YES;
    titleLbl_.hidden = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: overrider by subclass
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 2*SCREEN_WIDTH/3;
}
@end

@implementation MJBaseLiveTableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105+CELL_IMAGE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XConcernCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConcernCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XConcernCell" owner:self options:nil] lastObject];
        //        cell.delegate = self;
    }
  
//    cell.concernModel = _datas[indexPath.row];
    
    id<TCShowLiveRoomAble> room = _datas[indexPath.row];
    
    [cell configWith:room];
    
//    NSDictionary* dataDic = nil;
//    if (indexPath.row >= _datas.count)
//    {
//        return cell;
//    }
//    dataDic = [_datas objectAtIndex:indexPath.row];
//    
//    NSString* logoPath = [dataDic objectForKey:@"headimagepath"];
//    if([logoPath isEqualToString:@""])
//    {
//        cell.headIcon.image = HOLDER_HEAD;//[UIImage imageNamed:@"default_head.jpg"];
//    }
//    else
//    {
////        NSInteger width = cell.headIcon.frame.size.width*SCALE;
////        NSInteger height = width;
//        NSString *logoUrl = [NSString stringWithFormat:IMG_PREFIX,logoPath];
//        [cell.headIcon sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:HOLDER_HEAD];
//    }
//    
//    NSString* coverPath = [dataDic objectForKey:@"coverimagepath"];
//    if([coverPath isEqualToString:@""])
//    {
//        cell.cellImage.image = [UIImage imageNamed:@"liveimage"];
//    }
//    else
//    {
////        NSInteger width = cell.cellImage.frame.size.width*SCALE;
////        NSInteger height = cell.cellImage.frame.size.height*SCALE;
//        NSString *coverUrl = [NSString stringWithFormat:IMG_PREFIX,coverPath];
//        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:cell.cellImage.frame.size]];
//    }
//    cell.username.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"username"]];
//    cell.contntTitle.text = [dataDic objectForKey:@"subject"];
//    cell.heartNum.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"praisenum"]];
//    cell.giftNum.text = [NSString stringWithFormat:@"%@",dataDic[@"amount"]];
//    cell.liveInfo = dataDic;
//    cell.address.text = dataDic[@"addr"] && ![dataDic[@"addr"] isEqualToString:@"(null)"]? dataDic[@"addr"]: @"难道在火星？";
//    cell.watchNum.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"viewernum"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary* item = [_datas objectAtIndex:indexPath.row];
//    if([[item objectForKey:@"userphone"] isEqualToString:[UserInfo sharedInstance].userPhone])
//    {
//        return;
//    }
// 从直播列表点入直播室所传参数在这里设置↓↓↓
//    MyLiveViewController *myLiveViewController = [[MyLiveViewController alloc ] init];
//    UserInfo *ui = [UserInfo sharedInstance];
//    [UserInfo sharedInstance].liveUserPhone = [item objectForKey:@"userphone"]; // 手机号
//    ui.liveUserId = item[@"user_id"]; // add by gcz 2016-06-12 16:01:13
//    [UserInfo sharedInstance].liveUserName = [item objectForKey:@"username"]; // 用户名
//    [UserInfo sharedInstance].liveUserLogo = [item objectForKey:@"headimagepath"]; // 头像地址
//    [UserInfo sharedInstance].liveTime = [item objectForKey:@"begin_time"]; // 开始时间
//    [UserInfo sharedInstance].liveRoomId = [[item objectForKey:@"programid"] integerValue]; // 直播id
//    [UserInfo sharedInstance].chatRoomId = [item objectForKey:@"groupid"]; // 聊天室id
//    [UserInfo sharedInstance].liveTitle = [item objectForKey:@"subject"]; // 标题
//    [UserInfo sharedInstance].liveType = LIVE_WATCH; // 直播类型
//    [UserInfo sharedInstance].livePraiseNum = [item objectForKey:@"praisenum"]; // 点赞数
//    [UserInfo sharedInstance].isFollowed = [[item objectForKey:@"guanzhu"] boolValue]; // 0未关注 1已关注
//    [UserInfo sharedInstance].fans_num = item[@"fans_num"]; // 先写固定值~等yin写好后再获取 // add by gcz 2016-06-14 17:19:48
    
//    myLiveViewController.liveTitle = [item objectForKey:@"subject"];
//    XConcernCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    myLiveViewController.liveImage = cell.cellImage.image;
//    //    [self presentViewController:myLiveViewController animated:YES completion:nil];
////    [[AppDelegate sharedAppDelegate] presentViewController:myLiveViewController animated:YES completion:nil];
//    UINavigationController *nav = [(UITabBarController *)[AppDelegate sharedAppDelegate].window.rootViewController selectedViewController];
//    myLiveViewController.hidesBottomBarWhenPushed = YES;
//    [nav pushViewController:myLiveViewController animated:YES];
//
    
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        return;
    }
    // 进入直播间
    TCShowLiveListItem *item = _datas[indexPath.row];
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:[IMAPlatform sharedInstance].host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

@end

#pragma mark -- 直播列表
// 直播列表============================================================

@implementation MJLiveTableView

- (void)refreshData
{
//    [super refreshData];
    if (_isLoading)
    {
        return;
    }
    [self requestLiveData:@"1"];
}

- (void)loadData
{
//    [super loadData];
    if (_datas.count < 15 || _datas.count % 15 != 0) {
        [_footer endRefreshing];
        return;
    }
    page = [_datas count]/15 + 1;
    NSString *pageStr = [@(page) stringValue];
    [self requestLiveData:pageStr];
//    [_footer endRefreshing];
}

- (void)requestLiveData:(NSString*)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    [[Business sharedInstance] getLives:lastTime uid:[SARUserInfo userId] isConcernLives:NO  type:nil succ:^(NSString *msg, id data) {
        if([lastTime isEqualToString:@"1"])
        {
            //刷新，如果是加载更多不用删除旧数据
            [_datas removeAllObjects];
        }
        
//        _datas = [NSObject loadItem:[LiveItemInfo class] fromArrayDictionary:da]
        _datas = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data context:nil];
//        [_datas addObjectsFromArray:data];
        [_header endRefreshing];
        [_footer endRefreshing];
        [self reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        [self hideNoDataView];
    } fail:^(NSString *error) {
        if (_header.isRefreshing || _footer.isRefreshing) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//             [hud hideText:error atMode:MBProgressHUDModeText andDelay:2.f andCompletion:NULL];
        }
        if ([error hasPrefix:@"暂无"]) {
            [_datas removeAllObjects];
            [self reloadData];
        }
        if (_datas.count == 0) {
            [self showNoDataView:@"no_data_live" title:@"还没有人直播，快去直播吧！"];
        }else{
            [self hideNoDataView];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        
    }];
}



@end

//  直播列表结束============================================================


// 直播预告列表=============================================================
@implementation MJTrailerTableView

- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
    [self requestTrailerData:@"1"];
}

- (void)loadData
{
    
    if (_datas.count < 15 || _datas.count % 15 != 0) {
        [_footer endRefreshing];
        return;
    }
    page = [_datas count]/15 + 1;
    NSString *pageStr = [@(page) stringValue];
    [self requestTrailerData:pageStr];
}

- (void)requestTrailerData:(NSString *)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    [[Business sharedInstance] getLives:lastTime uid:[SARUserInfo userId]  isConcernLives:NO  type:@"1" succ:^(NSString *msg, id data) {
        if([lastTime isEqualToString:@"1"])
        {
            //刷新，如果是加载更多不用删除旧数据
            [_datas removeAllObjects];
        }
        _datas = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data context:nil];

        //        _datas = [NSObject loadItem:[LiveItemInfo class] fromArrayDictionary:da]
//        [_datas addObjectsFromArray:data];
        [_header endRefreshing];
        [_footer endRefreshing];
        [self reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        [self hideNoDataView];
    } fail:^(NSString *error) {
        if (_header.isRefreshing || _footer.isRefreshing) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//            [hud hideText:error atMode:MBProgressHUDModeText andDelay:2.f andCompletion:NULL];
        }
        if ([error hasPrefix:@"暂无"]) {
            [_datas removeAllObjects];
            [self reloadData];
        }
        if (_datas.count == 0) {
            [self showNoDataView:@"no_data_live" title:@"还没有人直播，快去直播吧！"];
        }else{
            [self hideNoDataView];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        
    }];
}




@end

// 预告列表结束============================================================


@implementation MJVideoTableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
    [self requestLiveData:@""];
}

- (void)loadData
{
    //[self requestLiveData:[[liveArray lastObject] objectForKey:@"begin_time"]];
    [_footer endRefreshing];
}

- (void)requestLiveData:(NSString*)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    [[Business sharedInstance] getLives:lastTime uid:[SARUserInfo userId]  isConcernLives:NO  type:nil succ:^(NSString *msg, id data) {
        if([lastTime isEqualToString:@""])
        {
            //刷新，如果是加载更多不用删除旧数据
            [_datas removeAllObjects];
        }
        [_datas addObjectsFromArray:data];
        [_header endRefreshing];
        [_footer endRefreshing];
        [self reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
    } fail:^(NSString *error) {
        if (_header.isRefreshing || _footer.isRefreshing) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//            [hud hideText:error atMode:MBProgressHUDModeText andDelay:2.f andCompletion:NULL];
        }
        if ([error hasPrefix:@"暂无"]) {
            [_datas removeAllObjects];
            [self reloadData];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSDictionary* dataDic = [_datas objectAtIndex:indexPath.row];
    WatchLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoLiveCell"];
    if(cell == nil){
        cell = [[WatchLiveTableViewCell alloc] initVideoWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoLiveCell"];
        //        cell.delegate = self;
    }
    
//    NSString* logoPath = [dataDic objectForKey:@"headimagepath"];
//    if([logoPath isEqualToString:@""])
//    {
//        cell.userLogoImageView.image = [UIImage imageNamed:@"default_head.jpg"];
//    }
//    else
//    {
//        NSInteger width = cell.userLogoImageView.frame.size.width*SCALE;
//        NSInteger height = width;
//        NSString *logoUrl = [NSString stringWithFormat:URL_IMAGE,logoPath,width,height];
//        [cell.userLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:cell.userLogoImageView.frame.size]];
//    }
//    
//    NSString* coverPath = [dataDic objectForKey:@"coverimagepath"];
//    if([coverPath isEqualToString:@""])
//    {
//        cell.liveImageView.image = [UIImage imageNamed:@"liveimage"];
//    }
//    else
//    {
//        NSInteger width = cell.liveImageView.frame.size.width*SCALE;
//        NSInteger height = cell.liveImageView.frame.size.height*SCALE;
//        NSString *coverUrl = [NSString stringWithFormat:URL_IMAGE,coverPath,width,height];
//        [cell.liveImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:cell.liveImageView.frame.size]];
//    }
//    cell.userNameLabel.text = [NSString stringWithFormat:@"@%@",[dataDic objectForKey:@"username"]];
//    cell.liveTitleLabel.text = [dataDic objectForKey:@"subject"];
//    cell.praiseNumLabel.text = [dataDic objectForKey:@"praisenum"];
//    cell.audienceNumLabel.text = [dataDic objectForKey:@"viewernum"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary* item = [_datas objectAtIndex:indexPath.row];
//    if([[item objectForKey:@"userphone"] isEqualToString:[UserInfo sharedInstance].userPhone])
//    {
//        return;
//    }
    
//    LivePlaybackViewController *vc = [[LivePlaybackViewController alloc] init];//注释by zxd 2016.09.06 18:22
    
    
//    [UserInfo sharedInstance].liveUserPhone = [item objectForKey:@"userphone"];
//    [UserInfo sharedInstance].liveUserName = [item objectForKey:@"username"];
//    [UserInfo sharedInstance].liveUserLogo = [item objectForKey:@"headimagepath"];
//    [UserInfo sharedInstance].liveTime = [item objectForKey:@"begin_time"];
//    [UserInfo sharedInstance].liveRoomId = [[item objectForKey:@"programid"] integerValue];
//    [UserInfo sharedInstance].chatRoomId = [item objectForKey:@"groupid"];
//    [UserInfo sharedInstance].liveTitle = [item objectForKey:@"subject"];
//    [UserInfo sharedInstance].liveType = LIVE_WATCH;
//    [UserInfo sharedInstance].livePraiseNum = [item objectForKey:@"praisenum"];
    //    [self presentViewController:myLiveViewController animated:YES completion:nil];
    
   // [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];//注释by zxd 2016.09.06 18:22
   
    
}

@end
#pragma mark -- 关注列表
// 关注列表开始 *********************************************************
@implementation MJConcernTableView

- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
    [self requestLiveData:@""];
}

- (void)loadData
{
    //[self requestLiveData:[[liveArray lastObject] objectForKey:@"begin_time"]];
    [_footer endRefreshing];
}

- (void)requestLiveData:(NSString *)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    [[Business sharedInstance] concernList:[SARUserInfo userId] type:@"1"  succ:^(NSString *msg, id data) {
        if([lastTime isEqualToString:@""])
        {
            //刷新，如果是加载更多不用删除旧数据
            [_datas removeAllObjects];
        }
        NSArray *arr = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data];
        //        _datas = [NSObject loadItem:[LiveItemInfo class] fromArrayDictionary:da]
        [_datas addObject:arr];
        [_header endRefreshing];
        [_footer endRefreshing];
        [self reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        [self hideNoDataView];
    } fail:^(NSString *error) {
        if (_header.isRefreshing || _footer.isRefreshing) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//            [hud hideText:error atMode:MBProgressHUDModeText andDelay:2.f andCompletion:NULL];
        }
        if ([error hasPrefix:@"暂无"]) {
            [_datas removeAllObjects];
            [self reloadData];
        }
        
        if (_datas.count == 0) {
            [self showNoDataView:@"no_data_live" title:@"您关注的人还没有直播"];
        }else{
            [self hideNoDataView];
        }
        
        [_header endRefreshing];
        [_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isLoading = NO;
        });
        
    }];
}

@end


// 关注列表结束 *********************************************************
