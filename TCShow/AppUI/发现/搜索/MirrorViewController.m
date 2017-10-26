//
//  MirrorViewController.m
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MirrorViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MirrorHeadView.h"
#import "XSearchFriendViewController.h"
#import "DragView.h"
#import "Business.h"
//#import "UserInfo.h"
//#import "MyLiveViewController.h"
#import "RRContributeListViewController.h"
//#import "ChatViewController.h"
@interface MirrorViewController ()<UITableViewDelegate,UITableViewDataSource,MirrorViewHeaderDelegate,ChooseDelegate>{
    UITableView * _tabelView;
//    UIImageView * _heroHeadImage;
//    UILabel * _signatureText;
    UILabel * _bottomLabel;
    UIImageView * _imageView;
    NSArray * _dataArray;
    NSDictionary * _userInfoDic;
    DragView * _view ;
    MirrorHeadView * _headView;
    NSMutableArray * _heroImageArray;
}

@end

@implementation MirrorViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _tabelView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YCColor(243, 243, 243, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"个人主页-导航栏-返回键"] style:UIBarButtonItemStylePlain target:self action:@selector(BlackCilck)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _heroImageArray = [NSMutableArray array];
    [self.navigationController.navigationBar setTranslucent:YES];
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        _tabelView.showsVerticalScrollIndicator = NO;
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tabelView];
    }
    _view = [[DragView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    _view.chooseDelegatel = self;
    _view.levelController = self;
//    _view.userInteractionEnabled = YES;
    [self.view addSubview:_view];
    _view.attendId = self.userId;
    
    _headView =[[[NSBundle mainBundle]loadNibNamed:@"MirrorHeadView" owner:nil options:nil]lastObject];
//    if (_userInfoDic.count!=0) {
//        [_headView updateView:_userInfoDic];
//    }
    _headView.mirDelegate = self;
    _headView.backgroundColor = YCColor(251, 86, 88, 1.0);
    _tabelView.tableHeaderView = _headView;
    [self requestUserInfo];
    
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _tabelView.delegate = nil;
//    [_view removeFromSuperview];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setTranslucent:NO];
}



#pragma mark ---DragView Delegate
-(void)getChooseIndex{
    IMAUser *user1 = [[IMAUser alloc]init];
    user1.userId = _userInfoDic[@"phone"];
    user1.icon = [NSString stringWithFormat:IMG_PREFIX,_userInfoDic[@"img"]];
    user1.nickName = _userInfoDic[@"nickname"];
    //跳转到聊天界面
    [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;

     [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:user1];
//    ChatViewController *chat = [[ChatViewController alloc] init];
//    chat.headImg = _userInfoDic[@"img"];
//    chat.to_user_name = _userInfoDic[@"username"];
//    chat.to_user_id = self.userId;
//    [self.navigationController pushViewController:chat animated:YES];注释by zxd 2016-09-07
}

#pragma mark - Private method
- (void)requestUserInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!self.userId) {
        self.userId = @"";
    }
    NSDictionary *dic = @{@"user_id":self.userId};
    __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] getUserInfoByPhone:self.userId succ:^(NSString *msg, id data) {
        
        [manager POST:GET_CORNTRIBUTE_LIST parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            hud.hidden = YES;
            if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
                [_heroImageArray removeAllObjects];
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *msgAry = [dic objectForKey:@"lists"];
                for (NSDictionary *dic in msgAry) {
                    [_heroImageArray addObject:dic[@"img"]];
                }
                if (_heroImageArray.count > 3) {
                    _heroImageArray = [[_heroImageArray subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
                }
            }
            [self fillInfo:data];
//            [_tabelView reloadData];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"请求失败，请稍后重试~";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//            [wh hideText:@"请求失败，请稍后重试~" atMode:MBProgressHUDModeText andDelay:1.f andCompletion:NULL];
        }];
        
    } fail:^(NSString *error) {
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [wh hideText:error atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
        _dataArray = @[@[@""],@[@"",@"",@"",@""],@[@""]];
    }];
}

- (void)fillInfo:(NSDictionary *)dic
{

    _userInfoDic = dic;
    if (_userInfoDic.count!=0) {
        [_headView updateView:_userInfoDic];
    }
    if ([dic[@"live_status"]integerValue]==1) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"个人主页-直播中"] style:UIBarButtonItemStylePlain target:self action:@selector(LiveCilck)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    [_view updateView:dic[@"is_fans"]];
    long long int date1 = (long long int)[dic[@"birthday"] intValue];
    NSDate *dateStamp = [NSDate dateWithTimeIntervalSince1970:date1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [formatter stringFromDate:dateStamp];
    //计算年龄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    _dataArray = @[@[@""],@[[NSString stringWithFormat:@"%d岁",age],dic[@"city"],dic[@"job"],dic[@"number"]],@[dic[@"personalized"]]];
    
    
    _view.phone = _userInfoDic[@"phone"];  // add by zxd on 2016-09-29  16:51

    [_tabelView reloadData];
}

#pragma mark ----TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
            if (section == 1) {
                return 4;
            }else{
                return 1;
            }
    }

    return [_dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count == 0) {
        return 3;
    }
//    return 3;
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

//    if (section == 0) {
//        return 264.0;
//    }else{
        return 0.01;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * titleArr = @[@[@"魅力贡献榜"],@[@"年龄",@"城市",@"职业",@"奇客号"],@[@"个性签名"]];
    NSArray * imageArray = @[@"",@"",@"",@"个人主页-内容栏-贡献榜进去"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
        UILabel *_signatureText = [[UILabel alloc]init];
        _signatureText.frame = CGRectMake(140, 5, SCREEN_WIDTH - 160 , 40);
        _signatureText.numberOfLines = 0;
        _signatureText.textColor = YCColor(152, 152, 152, 1.0);
        _signatureText.font = [UIFont systemFontOfSize:16];
        _signatureText.tag = 10;
        [cell.contentView addSubview:_signatureText];
    }
    cell.textLabel.text = titleArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = YCColor(44, 44, 44, 1.0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        if (indexPath.row !=3) {
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH - 30, 1.0)];
            line.backgroundColor = YCColor(152, 152, 152, 1.0);
            [cell.contentView addSubview:line];
        }
    }
    if (indexPath.section == 0) {
        for (int i =0; i<4; i++) {
            [[cell.contentView viewWithTag:100+i] removeFromSuperview];
            UIImageView *_heroHeadImage = [[UIImageView alloc]init];
            _heroHeadImage.frame = CGRectMake(SCREEN_WIDTH-30 - 40*i, 10, 30, 30);
            _heroHeadImage.tag = 100+i;
//            _heroImageArray = [@[@"/data/upload/avatar/574eaa16c5a8c.png",@"/data/upload/avatar/574eaa16c5a8c.png"]mutableCopy];
            if (_heroImageArray.count!=0 && i>0) { // 1 2 3
                if (_heroImageArray.count  >= i) {
                    NSString *urlStr = _heroImageArray[_heroImageArray.count - i ];
                    [_heroHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,urlStr]] placeholderImage:HOLDER_HEAD];
                }
            }else{ // 0
                _heroHeadImage.image = [UIImage imageNamed:imageArray[3-i]];
                _heroHeadImage.frame = CGRectMake(SCREEN_WIDTH-30 - 40*i, 25/2.0, 20, 25);
            }
            _heroHeadImage.layer.cornerRadius = 15;
            _heroHeadImage.layer.masksToBounds = YES;
            _heroHeadImage.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:_heroHeadImage];
        }
    }
    UILabel *_signatureText = [cell.contentView viewWithTag:10];
    if ([_dataArray[indexPath.section][indexPath.row] isEqualToString:@""]&&indexPath.section!=0) {
        _signatureText.text = @"未填写";
    }else{
    
     _signatureText.text = _dataArray[indexPath.section][indexPath.row];
    }
   
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (section == 0) {
//        _headView =[[[NSBundle mainBundle]loadNibNamed:@"MirrorHeadView" owner:nil options:nil]lastObject];
//        if (_userInfoDic.count!=0) {
//            [_headView updateView:_userInfoDic];
//        }
//        _headView.mirDelegate = self;
//        _headView.backgroundColor = YCColor(251, 86, 88, 1.0);
//        return _headView;
//        
//    }else{
//        
//        return nil;
//    }
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        RRContributeListViewController * contribute = [[RRContributeListViewController alloc]init];
        contribute.userID = _userInfoDic[@"id"];
        [self.navigationController pushViewController:contribute animated:YES];
    }
}

#pragma mark ----自定义视图代理
-(void)chooseClick:(NSString *)index{
    XSearchFriendViewController * firend = [[XSearchFriendViewController alloc]init];
    firend.type = index;
    firend.userId = _userInfoDic[@"id"];
    [self.navigationController pushViewController:firend animated:YES];
}

#pragma mark ---自定义导航栏按钮点击
-(void)BlackCilck{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LiveCilck{
    
    
//    if([[_userInfoDic objectForKey:@"userphone"] isEqualToString:[UserInfo sharedInstance].userPhone])
//    {
//        return;
//    }
// 从直播列表点入直播室所传参数在这里设置↓↓↓
//    MyLiveViewController *myLiveViewController = [[MyLiveViewController alloc ] init];
//    UserInfo *ui = [UserInfo sharedInstance];
//    [UserInfo sharedInstance].liveUserPhone = [_userInfoDic objectForKey:@"phone"]; // 手机号
//    ui.liveUserId = self.userId; // add by gcz 2016-06-12 16:01:13
//    [UserInfo sharedInstance].liveUserName = [_userInfoDic objectForKey:@"nickname"]; // 用户名
//    [UserInfo sharedInstance].liveUserLogo = [_userInfoDic objectForKey:@"img"]; // 头像地址
//    [UserInfo sharedInstance].liveRoomId = [[_userInfoDic objectForKey:@"roomnum"] integerValue]; // 直播id
//    [UserInfo sharedInstance].chatRoomId = [_userInfoDic objectForKey:@"groupid"]; // 聊天室id
//    [UserInfo sharedInstance].liveType = LIVE_WATCH; // 直播类型
//    [UserInfo sharedInstance].liveUserPhone = _userInfoDic[@"fans_num"];
//    myLiveViewController.liveImage = _headView.headImageView.image;
//    myLiveViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myLiveViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
