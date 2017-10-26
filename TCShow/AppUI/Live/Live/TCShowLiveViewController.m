//
//  TCShowLiveViewController.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveViewController.h"
#import "AFNetworking.h"
#import "GoodsDeailController.h"
#import "ConfirmOrderViewController.h"
#import "TCCharmShowViewController.h"
#import <UShareUI/UShareUI.h>
#import "TCLiveUserList.h"
#import "QZKExchangeViewController.h"
#import "TCAVBaseRoomEngine.h"
#import "QZKHeartView.h"
#import "QZKRechargeView.h"
#import "QZKPlayNiuNiuGames.h"


@implementation TCShowLiveUIViewController
{
    QZKUserIntoMessageView *qzk;
}

#if kSupportSwitchRoom

#define KSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define KSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
/**
 这里是主播界面，点击直播的时候进来的界面
 */
- (void)viewDidLoad{
    [super viewDidLoad];
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    self.timerNumber = 45;
    self.secondTimer = 1;
    self.intToTimer = 0;
    self.butShow = 1;
    self.avLiveTime = 0;
    self.sendavLiveTime = 0;
    self.exitOrPush = YES;
    self.isFirst = YES;
    self.imageArr = [NSMutableArray array];
    [self GamesView];
    [self topRechargeView];
//    [self createNiuniuGamesBtuTitle];
    qzk = [[QZKUserIntoMessageView alloc]initWithFrame:CGRectMake(0, 90, KSCREEN_WIDTH, 38)];
    [self.view addSubview:qzk];
    
    QZKUserEnterMsgView *kui = [[QZKUserEnterMsgView alloc]initWithFrame:CGRectMake(0, 130, KSCREEN_WIDTH, 42)];
    [self.view addSubview:kui];
    
    QZKManayChangeMsg *min = [[QZKManayChangeMsg alloc]initWithFrame:CGRectMake(0, 175, KSCREEN_WIDTH, 42)];
    [self.view addSubview:min];
    
    setStetasToServer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startSendState) userInfo:nil repeats:YES];
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH - 115, 350, 90, 45)];
    self.changeView.backgroundColor = [UIColor clearColor];
    self.changeView.hidden = YES;
    [self.view addSubview:self.changeView];
    UIButton *shaziBtu = [[UIButton alloc]initWithFrame:CGRectMake(8, self.changeView.frame.size.height - 39, 24, 24)];
    shaziBtu.backgroundColor = [UIColor clearColor];
    [shaziBtu setBackgroundImage:[UIImage imageNamed:@"touziBtu"] forState:UIControlStateNormal];
    [shaziBtu addTarget:self action:@selector(shazibtuTouchdown:) forControlEvents:UIControlEventTouchDown];
    [self.changeView addSubview:shaziBtu];
    UILabel *shaziLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.changeView.frame.size.height -  15 , 40, 15)];
    shaziLab.font = [UIFont systemFontOfSize:12];
    shaziLab.text = @"投色子";
    shaziLab.textAlignment = NSTextAlignmentCenter;
    shaziLab.backgroundColor = [UIColor clearColor];
    shaziLab.textColor = [UIColor whiteColor];
    [self.changeView addSubview:shaziLab];
    UIButton *pokenBtu = [[UIButton alloc]initWithFrame:CGRectMake(self.changeView.frame.size.width - 32, self.changeView.frame.size.height - 39, 24, 24)];
    pokenBtu.backgroundColor = [UIColor clearColor];
    [pokenBtu setBackgroundImage:[UIImage imageNamed:@"pokenBtu"] forState:UIControlStateNormal];
    [pokenBtu addTarget:self action:@selector(pokenBtuTouchdown:) forControlEvents:UIControlEventTouchDown];
    [self.changeView addSubview:pokenBtu];
    UILabel *pokenLab = [[UILabel alloc]initWithFrame:CGRectMake(self.changeView.frame.size.width - 40, self.changeView.frame.size.height -  15 , 40, 15)];
    pokenLab.font = [UIFont systemFontOfSize:12];
    pokenLab.text = @"扑克";
    pokenLab.textAlignment = NSTextAlignmentCenter;
    pokenLab.backgroundColor = [UIColor clearColor];
    pokenLab.textColor = [UIColor whiteColor];
    [self.changeView addSubview:pokenLab];
    [self creatplayGamesView];
    [self creatUserPlayGamesView];
    self.niuniuGames = [[QZKPlayNiuNiuGames alloc]initWithFrame:CGRectMake(0, 90, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    self.niuniuGames.room_id = [NSString stringWithFormat:@"%d",showItem.avRoomId];
    self.niuniuGames.delegate = self;
    self.niuniuGames.hidden = YES;
    [self.view addSubview:self.niuniuGames];
    _topView = [[QZKRechargeView alloc]initWithFrame:CGRectMake(0, KSCREEN_HEIGHT/2, KSCREEN_WIDTH, KSCREEN_HEIGHT/2)];
    _topView.hidden = YES;
    _topView.tag = 1;
    _topView.av_room_id = [NSString stringWithFormat:@"%d",[showItem avRoomId]];
    [self.view addSubview:_topView];
    //开启监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ForceQuitLive:) name:@"ForceQuitLive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsDetail:) name:@"GOODSLISTDETAIL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyGoods:) name:@"BUYGOODS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPay:) name:@"weChatPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeTopChanged:) name:@"GAMESVIEWHIDE" object:nil];

}

- (void)alertViewTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        qzk.clickButtonEnterAvRoom = ^(NSArray *arr) {
            id<TCShowLiveRoomAble> itemA = arr[0];
            TCShowLiveListItem *showItem = (TCShowLiveListItem *)weakSelf.liveController.roomInfo;
            if ([[NSString stringWithFormat:@"%d",itemA.liveAVRoomId] isEqualToString:[NSString stringWithFormat:@"%d",showItem.avRoomId]]) {
                [[HUDHelper sharedInstance] tipMessage:@"您已经在当前直播间"];
            }else{
                [myV.loveTimer invalidate];
                myV.loveTimer = nil;
                [weakSelf.niuniuGames.timerNmb invalidate];
                weakSelf.niuniuGames.timerNmb = nil;
                [_heartTimer invalidate];
                _heartTimer = nil;
                [userIntoRoom invalidate];
                userIntoRoom = nil;
                [setStetasToServer invalidate];
                setStetasToServer = nil;
                weakSelf.navigationController.navigationBarHidden = NO;
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                IMAHost *host = [IMAPlatform sharedInstance].host;
                TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:itemA user:host];
                [[AppDelegate sharedAppDelegate] pushViewController:vc];
            }
        };
    }];
    
    UIAlertAction *cancl = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sure];
    [alert addAction:cancl];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)shazibtuTouchdown:(UIButton *)sender{
    self.niuniuGames.hidden = YES;
    [self.niuniuGames.timerNmb invalidate];
    self.niuniuGames.timerNmb = nil;
    [self showView];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GAMESVIEWHIDE" object:self]];
}

- (void)pokenBtuTouchdown:(UIButton *)sender{
    self.niuniuGames.hidden = NO;
    self.niuniuGames.timerNmb = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self.niuniuGames selector:@selector(startSendState) userInfo:nil repeats:YES];
    [self hideView];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GAMESVIEWHIDE" object:self]];
}

- (void) pushToViewcontroller:(QZKExchangeViewController *)controller{
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:controller];
    self.exitOrPush = NO;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void) topRechargeView{
    _topBtu = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, 50, 50)];
    [_topBtu setBackgroundImage:[UIImage imageNamed:@"T-O-P"] forState:UIControlStateNormal];
    _topBtu.backgroundColor = [UIColor clearColor];
    [_topBtu addTarget:self action:@selector(codeTopViewShowOrHide:) forControlEvents:UIControlEventTouchDown];
    _topBtu.hidden = YES;
    [self.view addSubview:_topBtu];
}

- (void) GamesView{
    UIButton *gameBtu = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH - 75, 300, 40, 32)];
    [gameBtu setBackgroundImage:[UIImage imageNamed:@"gamesBtu"] forState:UIControlStateNormal];
    gameBtu.backgroundColor = [UIColor clearColor];
    [gameBtu addTarget:self action:@selector(gamesViewShowOrHide:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:gameBtu];
}

- (void) gamesViewShowOrHide:(UIButton *)sender{
    if (self.changeView.hidden == YES) {
        self.changeView.hidden = NO;
    }else{
        self.changeView.hidden = YES;
    }
}

- (void) codeTopViewShowOrHide:(UIButton *)sender{
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    [_topView createData:[NSString stringWithFormat:@"%d",showItem.avRoomId]];
    [_topView.dataArr removeAllObjects];
    if (_topView.hidden == YES) {
        _topView.hidden = NO;
    }else{
        _topView.hidden = YES;
    }
}
/**
 玩骰子游戏
 */
- (void) creatplayGamesView{
    self.playGamesView = [[UIView alloc]initWithFrame:CGRectMake(10, 90, 100, 150)];
    self.playGamesView.backgroundColor = [UIColor clearColor];
    self.playGamesView.layer.borderWidth = 2.0f;
    self.playGamesView.layer.cornerRadius = 5.0f;
    self.playGamesView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:self.playGamesView];
    UILabel *bankerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.playGamesView.frame.size.width, 20)];
    bankerLabel.backgroundColor = [UIColor clearColor];
    bankerLabel.text = @"庄家";
    bankerLabel.textAlignment = NSTextAlignmentCenter;
    bankerLabel.textColor = [UIColor whiteColor];
    [self.playGamesView addSubview:bankerLabel];
    self.showPoint = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, self.playGamesView.frame.size.width, 20)];
    self.showPoint.backgroundColor = [UIColor clearColor];
    self.showPoint.textColor = [UIColor whiteColor];
    self.showPoint.text = @"点数";
    self.showPoint.textAlignment = NSTextAlignmentCenter;
    [self.playGamesView addSubview:self.showPoint];
    //显示骰子图片的imageview
    self.pointImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(self.playGamesView.frame.size.width/2 - 20, self.playGamesView.frame.size.height/2 - 18, 40, 40)];
    self.pointImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(self.playGamesView.frame.size.width/2 - 38, self.playGamesView.frame.size.height/2, 40, 40)];
    self.pointImageViewThreen = [[UIImageView alloc]initWithFrame:CGRectMake(self.playGamesView.frame.size.width/2 , self.playGamesView.frame.size.height/2, 40, 40)];
    self.pointImageViewOne.backgroundColor = [UIColor clearColor];
    self.pointImageViewTwo.backgroundColor =[UIColor clearColor];
    self.pointImageViewThreen.backgroundColor =[UIColor clearColor];
    self.pointImageViewOne.image = [UIImage imageNamed:@"dice_1"];
    self.pointImageViewTwo.image = [UIImage imageNamed:@"dice_2"];
    self.pointImageViewThreen.image = [UIImage imageNamed:@"dice_3"];
    [self.playGamesView addSubview:self.pointImageViewOne];
    [self.playGamesView addSubview:self.pointImageViewTwo];
    [self.playGamesView addSubview:self.pointImageViewThreen];
}
/**
 显示玩家玩游戏的界面
 */
- (void)showView{
    [[Business sharedInstance] getMyIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data[@"integral"]];
    } fail:^(NSString *error) {
    }];
        self.userPlayGamesView.hidden = NO;
        self.playGamesView.hidden = NO;
    if ([SARUserInfo.userPhone isEqualToString:[[_liveController.roomInfo liveHost] imUserId]]) {
    }else{
        setStetasToServer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startSendState) userInfo:nil repeats:YES];
    }
}

/**
 隐藏玩家玩游戏的界面
 */
- (void)hideView{
    if (self.userPlayGamesView.hidden == YES) {
    }else{
        self.userPlayGamesView.hidden = YES;
        self.playGamesView.hidden = YES;
        if ([SARUserInfo.userPhone isEqualToString:[[_liveController.roomInfo liveHost] imUserId]]) {
        }else{
            [setStetasToServer invalidate];
            setStetasToServer = nil;
        }
    }
}

/**
 创建显示玩家玩游戏的View
 */
- (void) creatUserPlayGamesView{
    self.userPlayGamesView = [[UIView alloc]initWithFrame:CGRectMake(0, (KSCREEN_HEIGHT/3)*2, KSCREEN_WIDTH, KSCREEN_HEIGHT/3)];
    self.userOneView = [[UIView alloc]initWithFrame:CGRectMake(5, 35, (KSCREEN_WIDTH - 30)/3, self.userPlayGamesView.frame.size.height - 85)];
    self.userTwoView = [[UIView alloc]initWithFrame:CGRectMake((KSCREEN_WIDTH - 30)/3 + 15, 35, (KSCREEN_WIDTH - 30)/3, self.userPlayGamesView.frame.size.height - 85)];
    self.userThreenView = [[UIView alloc]initWithFrame:CGRectMake(((KSCREEN_WIDTH - 30)/3)*2 + 25, 35, (KSCREEN_WIDTH - 30)/3, self.userPlayGamesView.frame.size.height - 85)];
    
    UIImageView *pokerImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 40, 35)];
    pokerImage.backgroundColor = [UIColor clearColor];
    pokerImage.image = [UIImage imageNamed:@"touziBtu"];
    [self.userPlayGamesView addSubview:pokerImage];
    
    //设置一号桌
    self.userOneView.backgroundColor = [UIColor clearColor];
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userOneView.layer.borderWidth = 1.0f;
    self.userOneView.layer.cornerRadius = 10.0f;
    [self.userPlayGamesView addSubview:self.userOneView];
    //设置一号桌的显示点数
    self.userOnepointImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 20, (self.userOneView.frame.size.height)/2 - 36, 40, 40)];
    self.userOnepointImageViewOne.image = [UIImage imageNamed:@"dice_2"];
    self.userOnepointImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 36, (self.userOneView.frame.size.height)/2 , 40, 40)];
    self.userOnepointImageViewTwo.image = [UIImage imageNamed:@"dice_4"];
    self.userOnepointImageViewThreen = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 , (self.userOneView.frame.size.height)/2, 40, 40)];
    self.userOnepointImageViewThreen.image = [UIImage imageNamed:@"dice_1"];
    self.userOneInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.userOneView.frame.size.height - 20, self.userOneView.frame.size.width, 20)];
    self.userOneInfoLab.textAlignment = NSTextAlignmentCenter;
    self.userOneInfoLab.textColor = [UIColor whiteColor];
    self.userOneInfoLab.backgroundColor = [UIColor clearColor];
    self.userOneInfoLab.text = @"点数";
    self.userOneManay = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userOneView.frame.size.width - 40, 20)];
    self.userOneManay.backgroundColor = [UIColor whiteColor];
    self.userOneManay.textColor = [UIColor yellowColor];
    self.userOneManay.text = @"0/0";
    self.userOneManay.font = [UIFont systemFontOfSize:12.0f];
    self.userOneManay.textAlignment = NSTextAlignmentCenter;
    self.userOneManay.layer.borderWidth = 1.0f;
    self.userOneManay.layer.cornerRadius = 10.f;
    self.userOneManay.layer.masksToBounds = YES;
    self.userOneManay.layer.borderColor = [[UIColor yellowColor] CGColor];
    //添加到父窗体
    [self.userOneView addSubview:self.userOnepointImageViewOne];
    [self.userOneView addSubview:self.userOnepointImageViewTwo];
    [self.userOneView addSubview:self.userOnepointImageViewThreen];
    [self.userOneView addSubview:self.userOneInfoLab];
    [self.userOneView addSubview:self.userOneManay];
    UITapGestureRecognizer *oneTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTopSelect)];
    oneTop.numberOfTapsRequired = 1;
    oneTop.numberOfTouchesRequired = 1;
    [self.userOneView addGestureRecognizer:oneTop];
    //设置二号桌
    self.userTwoView.backgroundColor = [UIColor clearColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderWidth = 1.0f;
    self.userTwoView.layer.cornerRadius = 10.0f;
    [self.userPlayGamesView addSubview:self.userTwoView];
    //设置二号桌的显示点数
    self.userTwopointImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 20, (self.userOneView.frame.size.height)/2 - 36, 40, 40)];
    self.userTwopointImageViewOne.image = [UIImage imageNamed:@"dice_1"];
    self.userTwopointImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 36, (self.userOneView.frame.size.height)/2, 40, 40)];
    self.userTwopointImageViewTwo.image = [UIImage imageNamed:@"dice_5"];
    self.userTwopointImageViewThreen = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2, (self.userOneView.frame.size.height)/2, 40, 40)];
    self.userTwopointImageViewThreen.image = [UIImage imageNamed:@"dice_2"];
    self.userTwoInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.userTwoView.frame.size.height - 20, self.userTwoView.frame.size.width, 20)];
    self.userTwoInfoLab.textAlignment = NSTextAlignmentCenter;
    self.userTwoInfoLab.textColor = [UIColor whiteColor];
    self.userTwoInfoLab.backgroundColor = [UIColor clearColor];
    self.userTwoInfoLab.text = @"点数";
    self.userTwoManay = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userTwoView.frame.size.width - 40, 20)];
    self.userTwoManay.backgroundColor = [UIColor whiteColor];
    self.userTwoManay.textColor = [UIColor blueColor];
    self.userTwoManay.text = @"0/0";
    self.userTwoManay.font = [UIFont systemFontOfSize:12.0f];
    self.userTwoManay.textAlignment = NSTextAlignmentCenter;
    self.userTwoManay.layer.borderWidth = 1.0f;
    self.userTwoManay.layer.cornerRadius = 10.f;
    self.userTwoManay.layer.masksToBounds = YES;
    self.userTwoManay.layer.borderColor = [[UIColor blueColor] CGColor];
    //添加到父窗体
    [self.userTwoView addSubview:self.userTwopointImageViewOne];
    [self.userTwoView addSubview:self.userTwopointImageViewTwo];
    [self.userTwoView addSubview:self.userTwopointImageViewThreen];
    [self.userTwoView addSubview:self.userTwoInfoLab];
    [self.userTwoView addSubview:self.userTwoManay];
    UITapGestureRecognizer *twoTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTopSelect)];
    twoTop.numberOfTapsRequired = 1;
    twoTop.numberOfTouchesRequired = 1;
    [self.userTwoView addGestureRecognizer:twoTop];
    //设置三号桌
    self.userThreenView.backgroundColor = [UIColor clearColor];
    self.userThreenView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreenView.layer.borderWidth = 1.0f;
    self.userThreenView.layer.cornerRadius = 10.0f;
    [self.userPlayGamesView addSubview:self.userThreenView];
    //设置三号桌的显示点数
    self.userThreenpointImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 20, (self.userOneView.frame.size.height)/2 - 36, 40, 40)];
    self.userThreenpointImageViewOne.image = [UIImage imageNamed:@"dice_3"];
    self.userThreeenpointImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 36, (self.userOneView.frame.size.height)/2, 40, 40)];
    self.userThreeenpointImageViewTwo.image = [UIImage imageNamed:@"dice_3"];
    self.userThreenpointImageViewThreen = [[UIImageView alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2, (self.userOneView.frame.size.height)/2, 40, 40)];
    self.userThreenpointImageViewThreen.image = [UIImage imageNamed:@"dice_1"];
    self.userThreeInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.userThreenView.frame.size.height - 20, self.userThreenView.frame.size.width, 20)];
    self.userThreeInfoLab.textAlignment = NSTextAlignmentCenter;
    self.userThreeInfoLab.textColor = [UIColor whiteColor];
    self.userThreeInfoLab.backgroundColor = [UIColor clearColor];
    self.userThreeInfoLab.text = @"点数";
    self.userThreeManay = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userThreenView.frame.size.width - 40, 20)];
    self.userThreeManay.backgroundColor = [UIColor whiteColor];
    self.userThreeManay.textColor = [UIColor redColor];
    self.userThreeManay.text = @"0/0";
    self.userThreeManay.font = [UIFont systemFontOfSize:12.0f];
    self.userThreeManay.textAlignment = NSTextAlignmentCenter;
    self.userThreeManay.layer.borderWidth = 1.0f;
    self.userThreeManay.layer.cornerRadius = 10.f;
    self.userThreeManay.layer.masksToBounds = YES;
    self.userThreeManay.layer.borderColor = [[UIColor redColor] CGColor];
    //添加到父窗体
    [self.userThreenView addSubview:self.userThreenpointImageViewOne];
    [self.userThreenView addSubview:self.userThreeenpointImageViewTwo];
    [self.userThreenView addSubview:self.userThreenpointImageViewThreen];
    [self.userThreenView addSubview:self.userThreeInfoLab];
    [self.userThreenView addSubview:self.userThreeManay];
    UITapGestureRecognizer *threeTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(threeTopSelect)];
    threeTop.numberOfTapsRequired = 1;
    threeTop.numberOfTouchesRequired = 1;
    [self.userThreenView addGestureRecognizer:threeTop];
    //设置玩家游戏窗体
    self.userPlayGamesView.backgroundColor = [UIColor clearColor];
    self.userPlayGamesView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userPlayGamesView.layer.borderWidth = 1.0f;
    //押注按钮
    self.userOneBut = [[UIButton alloc]initWithFrame:CGRectMake((self.userOneView.frame.size.width)/2 - 25, (self.userOneView.frame.size.height)/2 - 25, 50, 50)];
    [self.userOneBut setTitle:@"押注" forState:UIControlStateNormal];
    self.userOneBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.userOneBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.userOneBut setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    self.userOneBut.layer.cornerRadius = 25.0f;
    self.userOneBut.clipsToBounds = YES;
    [self.userOneBut addTarget:self action:@selector(userOneButDidTouchUp:) forControlEvents:UIControlEventTouchDown];
    [self.userOneView addSubview:self.userOneBut];
    self.userTwoBut = [[UIButton alloc]initWithFrame:CGRectMake((self.userTwoView.frame.size.width)/2 - 25, (self.userTwoView.frame.size.height)/2 - 25, 50, 50)];
    [self.userTwoBut setTitle:@"押注" forState:UIControlStateNormal];
    self.userTwoBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.userTwoBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.userTwoBut setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    self.userTwoBut.layer.cornerRadius = 25.0f;
    self.userTwoBut.clipsToBounds = YES;
    [self.userTwoBut addTarget:self action:@selector(userTwoButDidTouchUp:) forControlEvents:UIControlEventTouchDown];
    [self.userTwoView addSubview:self.userTwoBut];
    self.userThreenBut = [[UIButton alloc]initWithFrame:CGRectMake((self.userThreenView.frame.size.width)/2 - 25, (self.userThreenView.frame.size.height)/2 - 25, 50, 50)];
    [self.userThreenBut setTitle:@"押注" forState:UIControlStateNormal];
    self.userThreenBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.userThreenBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.userThreenBut setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    self.userThreenBut.layer.cornerRadius = 25.0f;
    self.userThreenBut.clipsToBounds = YES;
    [self.userThreenBut addTarget:self action:@selector(userThreenButDidTouchUp:) forControlEvents:UIControlEventTouchDown];
    [self.userThreenView addSubview:self.userThreenBut];
    //显示积分的lable
    self.chipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.userPlayGamesView.frame.size.height - 44, KSCREEN_WIDTH/2 - 94, 44)];
    self.chipLable.text = @"积分:12345";
    self.chipLable.textColor = [UIColor whiteColor];
    self.chipLable.backgroundColor = [UIColor clearColor];
    self.chipLable.textAlignment = NSTextAlignmentCenter;
    [self.userPlayGamesView addSubview:self.chipLable];
    //充值按钮
    self.chipBut = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2 - 94,self.userPlayGamesView.frame.size.height - 44, 94, 38)];
    [self.chipBut setTitle:@"充值>" forState:UIControlStateNormal];
    [self.chipBut addTarget:self action:@selector(chipButDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:self.chipBut];
    //10积分下注按钮
    self.chipOne = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2, self.userPlayGamesView.frame.size.height - 44, 38, 38)];
    [self.chipOne setTitle:@"10" forState:UIControlStateNormal];
    self.chipOne.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipOne setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipOne.tag = 10;
    [self.chipOne setBackgroundImage:[UIImage imageNamed:@"chip10"] forState:UIControlStateNormal];
    [self.chipOne addTarget:self action:@selector(chipOneDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:self.chipOne];
    //25积分下注按钮
    self.chipTwo = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/8 + KSCREEN_WIDTH/2, self.userPlayGamesView.frame.size.height - 44, 38, 38)];
    [self.chipTwo setBackgroundImage:[UIImage imageNamed:@"chip25"] forState:UIControlStateNormal];
    [self.chipTwo setTitle:@"50" forState:UIControlStateNormal];
    self.chipTwo.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipTwo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipTwo.tag = 50;
    self.chipTwo.alpha = 0.5f;
    [self.chipTwo addTarget:self action:@selector(chipTwoDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:self.chipTwo];
    //50积分下注按钮
    self.chipThreen = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/4 + KSCREEN_WIDTH/2, self.userPlayGamesView.frame.size.height - 44, 38, 38)];
    [self.chipThreen setBackgroundImage:[UIImage imageNamed:@"chip50"] forState:UIControlStateNormal];
    [self.chipThreen setTitle:@"100" forState:UIControlStateNormal];
    self.chipThreen.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipThreen setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipThreen.tag = 100;
    self.chipThreen.alpha = 0.5f;
    [self.chipThreen addTarget:self action:@selector(chipThreenDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:self.chipThreen];
    //100积分下注按钮
    self.chipFour = [[UIButton alloc]initWithFrame:CGRectMake((KSCREEN_WIDTH/8)*3 + KSCREEN_WIDTH/2, self.userPlayGamesView.frame.size.height - 44, 38, 38)];
    [self.chipFour setBackgroundImage:[UIImage imageNamed:@"chip100"] forState:UIControlStateNormal];
    [self.chipFour setTitle:@"500" forState:UIControlStateNormal];
    self.chipFour.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipFour setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipFour.tag = 500;
    self.chipFour.alpha = 0.5f;
    [self.chipFour addTarget:self action:@selector(chipFourDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:self.chipFour];
    self.userOneLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.userPlayGamesView.frame.size.width, 35)];
    self.userOneLab.text = @"倒计时:10s";
    self.userOneLab.textColor = [UIColor whiteColor];
    self.userOneLab.backgroundColor = [UIColor clearColor];
    self.userOneLab.textAlignment = NSTextAlignmentCenter;
    [self.userPlayGamesView addSubview:self.userOneLab];
    UIButton *clackBut = [[UIButton alloc]initWithFrame:CGRectMake(self.userPlayGamesView.frame.size.width - 55, 0, 35, 35)];
    [clackBut setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [clackBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clackBut.backgroundColor = [UIColor clearColor];
    clackBut.layer.cornerRadius = 17.5f;
    clackBut.layer.masksToBounds = YES;
    [clackBut addTarget:self action:@selector(buttonDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.userPlayGamesView addSubview:clackBut];
    self.userPlayGamesView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.userPlayGamesView];
    self.userOneBut.hidden = YES;
    self.userTwoBut.hidden = YES;
    self.userThreenBut.hidden = YES;
    self.userPlayGamesView.hidden = NO;
}

- (void) oneTopSelect{
    self.userOneView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor whiteColor] CGColor];
    if (self.chipOne.alpha == 1) {
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void) twoTopSelect{
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor whiteColor] CGColor];
    if (self.chipOne.alpha == 1) {
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void) threeTopSelect{
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor redColor] CGColor];
    if (self.chipOne.alpha == 1) {
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self paylerMusice:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void)buttonDidTouchDown:(UIButton *)sender{
    [self hideView];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GAMESVIEWHIDE" object:self]];
}

/**
 充值按钮点击事件
 @param sender
 */
- (void)chipButDidTouchDown:(UIButton *)sender{
    QZKExchangeViewController *qzk = [[QZKExchangeViewController alloc]init];
    self.exitOrPush = NO;
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:qzk];
    [self presentViewController:nv animated:YES completion:nil];
}

/**
 10积分按钮点击事件
 @param sender
 */
- (void)chipOneDidTouchDown:(UIButton *)sender{
    self.chipTwo.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

/**
 25积分按钮点击事件
 @param sender
 */
- (void)chipTwoDidTouchDown:(UIButton *)sender{
    self.chipOne.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

/**
 50积分按钮点击事件
 @param sender
 */
- (void)chipThreenDidTouchDown:(UIButton *)sender{
    self.chipTwo.alpha = 0.5f;
    self.chipOne.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

/**
 100积分按钮点击事件
 @param sender
 */
- (void)chipFourDidTouchDown:(UIButton *)sender{
    self.chipTwo.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipOne.alpha = 0.5f;
}

- (void) AlertViewMessage:(NSString *)message shureBut:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:but];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void) changeViewLabelState:(UIButton *)sender{
    [[Business sharedInstance] getMyIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data[@"integral"]];
    } fail:^(NSString *error) {
    }];
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    NSString *room_id = [NSString stringWithFormat:@"%d",showItem.avRoomId];
    NSInteger manay = [[[[[self.chipLable.text componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    __weak typeof(self) weakSelf = self;
    if (self.userThreenView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor yellowColor] CGColor]) {
        if (sender.tag > manay) {
            [[HUDHelper sharedInstance] tipMessage:@"余额不足，请充值！"];
            
        }else{
            NSInteger num = [[[self.userOneManay.text componentsSeparatedByString:@"/"] firstObject] integerValue];
            NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
            [[Business sharedInstance] sendBetInfoToServer:[SARUserInfo userId] bet_money:bet_money room_id:room_id table_number:@"1" succ:^(NSString *msg, id data) {
                self.userOneManay.text = [NSString stringWithFormat:@"%ld/0",num + sender.tag];
            } fail:^(NSString *error) {
            }];
            UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
            image.tag = sender.tag;
            image.frame = sender.frame;
            [self.userPlayGamesView addSubview:image];
            [UIView animateWithDuration:0.2 animations:^{
                NSInteger rectmake = arc4random()%10;
                image.frame = CGRectMake(self.userOneView.frame.size.width/2 - rectmake, self.userOneView.frame.size.height/2 - rectmake, 20, 20);
                [self.userOneView addSubview:image];
            }];
        }
    }else if (self.userThreenView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor blueColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor whiteColor] CGColor]){
        if (sender.tag > manay) {
            [[HUDHelper sharedInstance] tipMessage:@"余额不足，请充值！"];
            
        }else{
        NSInteger num = [[[self.userTwoManay.text componentsSeparatedByString:@"/"] firstObject] integerValue];
        NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        [[Business sharedInstance] sendBetInfoToServer:[SARUserInfo userId] bet_money:bet_money room_id:room_id table_number:@"2" succ:^(NSString *msg, id data) {
            self.userTwoManay.text = [NSString stringWithFormat:@"%ld/0",num + sender.tag];
        } fail:^(NSString *error) {
        }];
        UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
        image.tag = sender.tag;
        image.frame = CGRectMake(sender.frame.origin.x - (KSCREEN_WIDTH - 30)/3 - 38, sender.frame.origin.y - 38, sender.frame.size.width, sender.frame.size.height);
        [self.userPlayGamesView addSubview:image];
        [UIView animateWithDuration:0.2 animations:^{
            NSInteger rectmake = arc4random()%10;
            image.frame = CGRectMake(self.userTwoView.frame.size.width/2 - rectmake, self.userTwoView.frame.size.height/2 - rectmake, 20, 20);
            [self.userTwoView addSubview:image];
        }];
        }
    }else if (self.userThreenView.layer.borderColor == [[UIColor redColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor whiteColor] CGColor]){
        if (sender.tag > manay) {
            [[HUDHelper sharedInstance] tipMessage:@"余额不足，请充值！"];
            
        }else{
        NSInteger num = [[[self.userThreeManay.text componentsSeparatedByString:@"/"] firstObject] integerValue];
        NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        [[Business sharedInstance] sendBetInfoToServer:[SARUserInfo userId] bet_money:bet_money room_id:room_id table_number:@"3" succ:^(NSString *msg, id data) {
            self.userThreeManay.text = [NSString stringWithFormat:@"%ld/0",num + sender.tag];
        } fail:^(NSString *error) {
        }];
        UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
        image.tag = sender.tag;
        image.frame = CGRectMake(sender.frame.origin.x - ((KSCREEN_WIDTH - 30)/3)*2 - 38 , sender.frame.origin.y - 38, sender.frame.size.width, sender.frame.size.height);
        [self.userPlayGamesView addSubview:image];
        [UIView animateWithDuration:0.2 animations:^{
            NSInteger rectmake = arc4random()%10;
            image.frame = CGRectMake(self.userThreenView.frame.size.width/2 - rectmake, self.userThreenView.frame.size.height/2 - rectmake, 20, 20);
             [self.userThreenView addSubview:image];
        }];
        }
    }
    [[Business sharedInstance] getMyIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data[@"integral"]];
    } fail:^(NSString *error) {
    }];
    [[Business sharedInstance]getUserManayToBetroom_id:room_id succ:^(NSString *msg, id data) {
        NSArray *arr = data;
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"table_number"] integerValue] == 1) {
                NSString *str = [[weakSelf.userOneManay.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userOneManay.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }else if ([dic[@"table_number"] integerValue] == 2) {
                NSString *str = [[weakSelf.userTwoManay.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userTwoManay.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }else if ([dic[@"table_number"] integerValue] == 3) {
                NSString *str = [[weakSelf.userThreeManay.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userThreeManay.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }
        }
    } fail:^(NSString *error) {
    }];
}

/**
 一号桌按钮的点击事件
 @param sender
 */
- (void)userOneButDidTouchUp:(UIButton *)sender{
    sender.hidden = YES;
    self.userOneView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

/**
 二号桌按钮的点击事件
 @param sender
 */
- (void)userTwoButDidTouchUp:(UIButton *)sender{
    sender.hidden = YES;
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

/**
 三号桌按钮的点击事件
 @param sender
 */
- (void)userThreenButDidTouchUp:(UIButton *)sender{
    sender.hidden = YES;
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreenView.layer.borderColor = [[UIColor redColor] CGColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    myV = [[QZKHeartView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    [self.view addSubview:myV];
    [self.view insertSubview:myV atIndex:0];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.exitOrPush == YES) {
        [myV.loveTimer invalidate];
        myV.loveTimer = nil;
        [self.niuniuGames.timerNmb invalidate];
        self.niuniuGames.timerNmb = nil;
        [_heartTimer invalidate];
        _heartTimer = nil;
        [userIntoRoom invalidate];
        userIntoRoom = nil;
        [setStetasToServer invalidate];
        setStetasToServer = nil;
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    _liveView = nil;
}

#pragma mark -----------人气排行榜
- (void)chargeTopChanged:(NSNotification *)noti{
    if (_niuniuGames.hidden == YES && _playGamesView.hidden == YES) {
        _topBtu.hidden = NO;
    }else{
        _topBtu.hidden = YES;
    }
}

#pragma mark -----------微信支付成功后回调
- (void)weChatPay:(NSNotification *)noti{
    
}

#pragma mark --------直播商品列表进入详情页
-(void)goodsDetail:(NSNotification *)noti{
    TCGoodsManageModel * manageModel = noti.object;
    GoodsDeailController * detail = [[GoodsDeailController alloc]init];
    detail.goods_id = manageModel.goods_id;
    self.exitOrPush = NO;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -----购买商品
-(void)buyGoods:(NSNotification *)noti{
    ConfirmOrderViewController * order = [[ConfirmOrderViewController alloc]init];
    order.goods_num = noti.userInfo[@"goods_num"];
    order.isCart = NO;
    order.goods_id = noti.userInfo[@"goods_id"];
    self.exitOrPush = NO;
    [self.navigationController pushViewController:order animated:YES];
}

#pragma mark -------后台强制退出直播
- (void)ForceQuitLive:(NSNotification*)noti{
    [self clearTopGamesInfo];
    [_niuniuGames clearTopGamesInfo];
    if ([noti.userInfo[@"state"] integerValue] == 1) {
        if (self.isPostLiveStart){
            [_heartTimer invalidate];
            _heartTimer = nil;
            [_liveView pauseLive];
#if kSupportTimeStatistics
            NSDate *startTime = [NSDate date];
            TCAVIMLog(@"主播退出直播间上报开始:%@", [kTCAVIMLogDateFormatter stringFromDate:startTime]);
#endif
            TCShowLiveListItem *hostAtem = (TCShowLiveListItem *)[self.roomEngine getRoomInfo];
                [self showLiveResult:hostAtem];
            self.isPostLiveStart = NO;
        }else{
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)onSwitchToPreRoom:(UIGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateEnded){
        [self switchToRoom:YES];
    }
}

- (void)onSwitchToNextRoom:(UIGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateEnded){
        [self switchToRoom:NO];
    }
}

- (void)switchToRoom:(BOOL)preRoom{
    __weak typeof(self) ws = self;
    LiveListRequest *req = [[LiveListRequest alloc] initWithHandler:^(BaseRequest *request) {
        LiveListRequest *wreq = (LiveListRequest *)request;
        TCShowLiveList *resp = (TCShowLiveList *)wreq.response.data;
        [ws switchToRoom:preRoom atList:resp.recordList];
    } failHandler:^(BaseRequest *request) {
    }];
    req.pageItem = [[RequestPageParamItem alloc] init];
    [[WebServiceEngine sharedEngine] asyncRequest:req wait:YES];
}

- (void)switchToRoom:(BOOL)preRoom atList:(NSArray *)arry{
    if (arry.count){
        NSString *curLiveHostID = [[_liveController.roomInfo liveHost] imUserId];
        TCShowLiveListItem *curItem = nil;
        for (TCShowLiveListItem *item in  arry){
            if ([[item.liveHost imUserId] isEqualToString:curLiveHostID]){
                curItem = item;
                break;
            }
        }
        if (arry.count == 1 && curItem != nil){
            // 列表中只有当前直播间
            [[HUDHelper sharedInstance] tipMessage:@"没有其他直播间用于切换"];
            return;
        }
        if (curItem){
            NSInteger idx = [arry indexOfObject:curItem];
            if (preRoom){
                if (idx >= 1){
                    idx--;
                }else{
                    // 有可能切换到列表的最后方导致切换不成功
                    idx = arry.count - 1;
                }
            }else{
                if (idx == arry.count - 1){
                    idx = 0;
                }else{
                    // 有可能切换到列表的最后方导致切换不成功
                    idx++;
                }
            }
            BOOL succ = [_liveController switchToLive:arry[idx]];
            if (!succ){
            }
        }else{
            BOOL succ = [_liveController switchToLive:arry[0]];
            if (!succ){
            }
        }
    }else{
        // 打到当前的直播间在列表中的位置
        [[HUDHelper sharedInstance] tipMessage:@"没有其他直播间用于切换"];
    }
}

- (void)switchToLiveRoom:(id<AVRoomAble>)room{
    [_liveView changeRoomInfo:(id<TCShowLiveRoomAble>)room];
}

#endif

- (void)addOwnViews{
    id<AVRoomAble> room = [_liveController roomInfo];
    _liveView = [[TCShowLiveView alloc] initWith:(id<TCShowLiveRoomAble>)room];
    __weak typeof(self) weakself = self;
    _liveView.charmViewClickBlock = ^{
        TCCharmShowViewController *charmVC = [[TCCharmShowViewController alloc] init];
        charmVC.uid = [room liveHostId];
        weakself.exitOrPush = NO;
        [weakself.navigationController pushViewController:charmVC animated:YES];
    };
    _liveView.shareViewClickBlock = ^{
        [weakself onSwitchShare];
    };
    _liveView.sendMsgBtnClickBlock = ^(TCLiveUserList *user) {
        [weakself sendmessagePush:user];
    };
    _liveView.topView.delegate = self;
    [self.view addSubview:_liveView];
}

//私信
- (void)sendmessagePush:(TCLiveUserList *)model {
    IMAUser *user = [[IMAUser alloc]init];
    user.userId = model.phone;
    user.icon = model.headsmall;
    user.remark = model.nickname;
    user.nickName = model.nickname;
#if kTestChatAttachment
    // 无则重新创建
    ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    vc.hidesBottomBarWhenPushed = YES;
    self.exitOrPush = NO;
    [self.navigationController pushViewController:vc withBackTitle:@"返回" animated:YES];
}

//分享
-(void)onSwitchShare{
    //    TCLiveShareView * shareView = [[[NSBundle mainBundle] loadNibNamed:@"TCLiveShareView" owner:nil options:nil] firstObject];
    //    shareView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    //    shareView.shareItem = ^(NSInteger itemTag){
    //        NSArray * itemArray = @[@"微博",@"QQ",@"空间",@"微信"];
    //        [[HUDHelper sharedInstance] tipMessage:itemArray[itemTag]];
    //    };
    //    [self.superview addSubview:shareView];
    
    __weak typeof(self) weakself = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakself shareWebPageToPlatformType:platformType];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UIImage *image = [UIImage imageNamed:@"shareIcon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"柠檬秀" descr:@"大家好,我正在直播哦!喜欢我的朋友赶紧来哦" thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =@"http://www.ningmengtv.net/wap_ningmengtv.html";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
        }else{
        }
    }];
}


- (BOOL)isPureMode{
    return [_liveView isPureMode];
}

#if kSupportIMMsgCache

- (void)onUIRefreshIMMsg:(AVIMCache *)cache{
    [_liveView.msgView insertCachedMsg:cache];
}
- (void)onUIRefreshPraise:(AVIMCache *)cache{
    [_liveView onRecvPraise:cache];
}

#endif

- (void)uiStartLive{
    __weak TCShowLiveUIViewController *ws = self;
    #if kSupportTimeStatistics
        NSDate *startTime = [NSDate date];
        TCAVIMLog(@"主播进入直播间上报开始:%@", [kTCAVIMLogDateFormatter stringFromDate:startTime]);
    #endif
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    [[Business sharedInstance]insertLive:showItem.title latitude:[showItem.lbs latitude]  room:showItem.avRoomId longitude:[showItem.lbs longitude]  addr:[showItem.lbs address] chat_room_id:showItem.chatRoomId cover:nil live_type:showItem.live_type  succ:^(NSString *msg, id data) {
#if kSupportTimeStatistics
        NSDate *date = [NSDate date];
        TCAVIMLog(@"主播进入直播间上报开始:%@ 成功回调时间:%@ 接口耗时:%0.3f (s)", [kTCAVIMLogDateFormatter stringFromDate:startTime], [kTCAVIMLogDateFormatter stringFromDate:date], [date timeIntervalSinceDate:startTime]);
#endif
        ws.isPostLiveStart = YES;
    } fail:^(NSString *error) {
#if kSupportTimeStatistics
        NSDate *date = [NSDate date];
        TCAVIMLog(@"主播进入直播间上报开始:%@ 失败回调时间:%@ 接口耗时:%0.3f (s)", [kTCAVIMLogDateFormatter stringFromDate:startTime], [kTCAVIMLogDateFormatter stringFromDate:date], [date timeIntervalSinceDate:startTime]);
#endif
        // 上传失败
        [[HUDHelper sharedInstance] tipMessage:error delay:2 completion:^{
            [ws.liveController alertExitLive];
        }];
    }];
}


- (void)showLiveResult:(TCShowLiveListItem *)item{
    [_liveController willExitLiving];
    __weak TCShowLiveUIViewController *ws = self;
    TCShowLiveResultView *resultview = [[TCShowLiveResultView alloc] initWith:item completion:^(id<MenuAbleItem> menu) {
//        ws.navigationController.navigationBarHidden = NO;
//        [ws.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.selectedIndex = 0;
    }];
    [self.view addSubview:resultview];
    [resultview setFrameAndLayout:self.view.bounds];
#if kSupportFTAnimation
    [resultview fadeIn:0.3 delegate:nil];
#endif
}

- (void)onStartPush:(BOOL)succ pushRequest:(TCAVLiveRoomPushRequest *)req{
    [_liveView.topView onRefrshPARView:(TCAVLiveRoomEngine *)_roomEngine];
}

- (void)onStartRecord:(BOOL)succ recordRequest:(TCAVLiveRoomRecordRequest *)req{
    [_liveView.topView onRefrshPARView:(TCAVLiveRoomEngine *)_roomEngine];
}

- (void)uiEndLive{
    if (self.isPostLiveStart){
        [_heartTimer invalidate];
        _heartTimer = nil;
        [_liveView pauseLive];
#if kSupportTimeStatistics
        NSDate *startTime = [NSDate date];
        TCAVIMLog(@"主播退出直播间上报开始:%@", [kTCAVIMLogDateFormatter stringFromDate:startTime]);
#endif
        __weak TCShowLiveUIViewController *ws = self;
       TCShowLiveListItem *hostAtem = (TCShowLiveListItem *)[ws.roomEngine getRoomInfo];
        [[Business sharedInstance]closeRoom:hostAtem.avRoomId succ:^(NSString *msg, id data) {
#if kSupportTimeStatistics
            NSDate *date = [NSDate date];
            TCAVIMLog(@"主播退出直播间上报开始:%@ 成功回调时间:%@ 接口耗时:%0.3f (s)", [kTCAVIMLogDateFormatter stringFromDate:startTime], [kTCAVIMLogDateFormatter stringFromDate:date], [date timeIntervalSinceDate:startTime]);
#endif
//            // 上传成功，界面停止计时
//            LiveEndResponseData *rec = (LiveEndResponseData *)request.response.data;
        } fail:^(NSString *error) {
//            [[HUDHelper sharedInstance]tipMessage:@"关闭直播间失败！！！"];
        }];
#pragma mark ---------此处把请求关闭直播间成功后的代码拿出来放在了外面
        [self clearTopGamesInfo];
        [_niuniuGames clearTopGamesInfo];
        [ws showLiveResult:hostAtem];
        self.isPostLiveStart = NO;
    }else{
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 开始向服务器发送游戏状态
 */
- (void)startSendState{
    if ([SARUserInfo.userPhone isEqualToString:[[_liveController.roomInfo liveHost] imUserId]]) {
        self.niuniuGames.userOrAv = YES;
        if (self.avLiveTime == 10) {
             [self startLiveTimer];
            self.avLiveTime = 0;
        }else{
            self.avLiveTime++;
        }
        if (self.secondTimer == 2) {
            [self requestGamesStates];
            self.secondTimer = 1;
        }else{
            [self sendStateToServer];
            self.secondTimer = 2;
        }
    }else{
        self.niuniuGames.userOrAv = NO;
        if (self.secondTimer == 2) {
            [self requestGamesStates];
            self.secondTimer = 1;
        }else{
            if (self.isFirst == YES) {
                [self userIntoRoomRequestGamesState];
                self.isFirst = NO;
            }
            self.secondTimer = 2;
        }
    }
}

/**
 定时器向服务器发送请求，添加游戏状态
 */
- (void)sendStateToServer{
    //oom_id（房间号）、bet_count_down（下注倒计时）、rest_count_down（休息倒计时）、game_state（状态：0：休息5s、1：下注30s、2：动画状态10s、3：结束状态5s）
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    if (self.timerNumber > 15) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 15];
        NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"1" forKey:@"game_state"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:DICEGAME_STATE_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else if( self.timerNumber > 10 && self.timerNumber <= 15){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 10];
        NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"2" forKey:@"game_state"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:DICEGAME_STATE_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        if (self.timerNumber == 11) {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
            [tmpDic setValue:roomid forKey:@"room_id"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:DICE_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                }];
        }
    }else if(self.timerNumber > 5 && self.timerNumber <= 10){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 5];
        NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"3" forKey:@"game_state"];
        __weak typeof(self) weakSelf = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:DICEGAME_STATE_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else if(self.timerNumber <= 5){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber];
        NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"0" forKey:@"game_state"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:DICEGAME_STATE_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
    if (self.timerNumber == 1) {
        [self clearTopGamesInfo];
        self.timerNumber = 35;
    }else{
        self.timerNumber --;
    }
}

- (void) clearTopGamesInfo{
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    NSString *room_id = [NSString stringWithFormat:@"%d",showItem.avRoomId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:DICE_SHANG parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)startLiveTimer{
    [self onPostHeartBeat];
    [_liveView startLive];
}

- (void)onPostHeartBeat{
    self.sendavLiveTime += 10;
    TCShowLiveListItem *hostAtem = (TCShowLiveListItem *)self.liveController.roomInfo;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"host_uid"] = hostAtem.host.phone;
    params[@"admire_count"] = @(hostAtem.admireCount);
    params[@"watch_count"] = @(hostAtem.liveAudience);
    params[@"time_span"] = [NSString stringWithFormat:@"%ld",(long)self.sendavLiveTime];
    [mgr POST:URL_Heart parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
//    NSString *url = @"http://47.93.32.34/index.php/Appapi/live/time_span";
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:[NSString stringWithFormat:@"%d",hostAtem.avRoomId] forKey:@"av_room_id"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
//    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

- (void)onEnterBackground{
    [self onPostHeartBeat];
    [_liveView pauseLive];
    [_heartTimer invalidate];
    _heartTimer = nil;
}
- (void)onEnterForeground{
    [self onPostHeartBeat];
    [_liveView resumeLive];
    [self startLiveTimer];
}

- (void)setRoomEngine:(TCAVBaseRoomEngine *)roomEngine{
    _roomEngine = roomEngine;
    [_liveView setRoomEngine:(TCAVLiveRoomEngine *)roomEngine];
}

- (void)setMsgHandler:(id<AVIMMsgHandlerAble>)msgHandler{
    if (_msgHandler != msgHandler) {
        _msgHandler = msgHandler;
        ((AVIMMsgHandler *)_msgHandler).roomIMListner = self;
        [_liveView setMsgHandler:(AVIMMsgHandler *)_msgHandler];
    }
}

- (void)layoutOnIPhone{
    [_liveView setFrameAndLayout:self.view.bounds];
}

- (void)onTopViewCloseLive:(TCShowLiveTopView *)topView{
    [_liveController alertExitLive];
}

- (void)onTopViewClickHost:(TCShowLiveTopView *)topView host:(TCShowLiveListItem *)host{
    // 显示主播信息
    TCUserProfileView *view = [[TCUserProfileView alloc] init];
    view.chatFromLive = ^(TCShowLiveListItem *userModel){
        IMAUser *user = [[IMAUser alloc]init];
        user.userId = userModel.host.phone;
        if (userModel.host.avatar.length>0) {
            user.icon = userModel.host.avatar;
        }else{
            user.icon = @"";
        }
        user.remark = userModel.host.username;
        user.nickName = userModel.host.username;
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * userList = [NSMutableDictionary dictionaryWithCapacity:0];
        if ([userDef objectForKey:@"chatList"]) {
            userList = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:@"chatList"]];
        }
        [userList setObject:@{@"userName":user.nickName,@"userIcon":user.icon} forKey:user.userId];
        [[NSUserDefaults standardUserDefaults] setObject:userList forKey:@"chatList"];
        [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
        [self pushToChatViewControllerWith:user];
    };
    [self.view addSubview:view];
    [view setFrameAndLayout:self.view.bounds];
    [view showUser:host];
}

- (void)pushToChatViewControllerWith:(IMAUser *)user{
#if kTestChatAttachment
    // 无则重新创建
    ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    vc.hidesBottomBarWhenPushed = YES;
    self.exitOrPush = NO;
    [self.navigationController pushViewController:vc withBackTitle:@"返回" animated:YES];
}

- (void)onTopView:(TCShowLiveTopView *)topView clickPAR:(UIButton *)par{
    [_liveView showPar:par];
}

- (void)onTopView:(TCShowLiveTopView *)topView clickPush:(UIButton *)par{
    if (par.selected){
        [(TCAVLiveRoomEngine *)_roomEngine asyncStopAllPushStreamCompletion:^(BOOL succ, NSString *tip) {
            par.selected = !par.selected;
        }];
    }else{
        __weak TCAVLiveRoomEngine *wr = (TCAVLiveRoomEngine *)_roomEngine;
        __weak typeof(self) ws = self;
        UIActionSheet *testSheet = [[UIActionSheet alloc] init];//[UIActionSheet bk_actionSheetWithTitle:@"请选择照片源"];
        [testSheet bk_addButtonWithTitle:@"HLS推流" handler:^{
            [wr asyncStartPushStream:AV_ENCODE_HLS completion:^(BOOL succ, TCAVLiveRoomPushRequest *req) {
                par.selected = succ;
                [ws showPush:AV_ENCODE_HLS succ:succ request:req];
            }];
        }];
        [testSheet bk_addButtonWithTitle:@"RTMP推流" handler:^{
            [wr asyncStartPushStream:AV_ENCODE_RTMP completion:^(BOOL succ, TCAVLiveRoomPushRequest *req) {
                par.selected = succ;
                [ws showPush:AV_ENCODE_RTMP succ:succ request:req];
            }];
        }];
        [testSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [testSheet showInView:self.view];
    }
}

- (void)onTopView:(TCShowLiveTopView *)topView clickREC:(UIButton *)rec{
    if (rec.selected){
        [(TCAVLiveRoomEngine *)_roomEngine asyncStopRecordCompletion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            rec.selected = !rec.selected;
            NSString *fileId = @"";
            if(req.recordFileIds != nil){
                for(int index = 0; index < req.recordFileIds.count; index++){
                    fileId = [fileId stringByAppendingString:[NSString stringWithFormat:@"%@\n",req.recordFileIds[index]]];
                }
            }
            [self AlertViewMessage:fileId buttonTitle:@"确定"];
            }];
    }else{
        TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
        [re asyncStartRecordCompletion:^(BOOL succ, TCAVLiveRoomRecordRequest *req) {
            rec.selected = succ;
            [[HUDHelper sharedInstance] tipMessage:succ ? @"开始录制" : @"开启录制失败"];
        }];
    }
}

/**
 显示的警告框

 @param message 想要显示的信息
 @param title 按钮名称
 */
- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:but];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)onTopView:(TCShowLiveTopView *)topView clickSpeed:(UIButton *)speed{
#if kIsMeasureSpeed
    [[IMAPlatform sharedInstance] requestTestSpeed];
#endif
}

- (void)showPush:(AVEncodeType)type succ:(BOOL)succ request:(TCAVLiveRoomPushRequest *)req{
    NSString *pushUrl = [req getPushUrl:type];
    if (succ && pushUrl.length > 0){
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"推流地址" message:pushUrl cancelButtonTitle:@"拷至粘切板" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:pushUrl];
        }];
        [alert show];
    }else{
        [[HUDHelper sharedInstance] tipMessage:@"推流不成功"];
    }
}

/**
 收到群聊天消息: (主要是文本类型)

 @param receiver
 @param msg 
 */
- (void)onIMHandler:(AVIMMsgHandler *)receiver recvGroupMsg:(id<AVIMMsgAble>)msg{
    [_liveView.msgView insertMsg:msg];
}

- (void)insertSystemText {
    TCShowLiveMsg *model = [[TCShowLiveMsg alloc] initWith:[_liveController roomInfo].liveHost message:@""];
    model.isMsg = YES;
    model.sender = [IMAPlatform sharedInstance].host;
    NSString *message = @"直播消息:我们提倡绿色直播,封面和直播内容含吸烟、低俗、引诱、暴露等都将会被封停账号,同时禁止直播聚众闹事、集会,网警24小时在线巡查哦!";
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:message];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, message.length)];
    [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 138, 2, 1.0) range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSForegroundColorAttributeName value:kWhiteColor range:NSMakeRange(5, message.length - 5)];
    model.avimMsgRichText = attriString;
    AVIMCMD *cmd = [[AVIMCMD alloc]initWith:AVIMCMD_GIFT];
    cmd.userAction = AVIMCMD_Text;
    model.avimMsgShowSize = CGSizeMake(165, 20);
    [_liveView.msgView insertMsg:model];
}


- (void)onRecvCustomLeave:(id<AVIMMsgAble>)msg{
    AVIMCMD *cmd = (AVIMCMD *)msg;
    TCAVLiveViewController *lvc = (TCAVLiveViewController *)_liveController;
    id<IMUserAble> sender = [cmd sender];
    NSArray *array = @[sender];
    [lvc.livePreview onUserLeave:sender];
    [_liveView onUserLeave:array];
}

- (void)onRecvCustomBack:(id<AVIMMsgAble>)msg{
    AVIMCMD *cmd = (AVIMCMD *)msg;
    TCAVLiveViewController *lvc = (TCAVLiveViewController *)_liveController;
    id<IMUserAble> sender = [cmd sender];
    NSArray *array = @[sender];
    [lvc.livePreview onUserBack:sender];
    [_liveView onUserBack:array];
    [(TCAVLiveRoomEngine *)_roomEngine asyncRequestHostView];
}

- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomGroup:(id<AVIMMsgAble>)msg{
    switch ([msg msgType]){
        case AVIMCMD_Praise:{
            [_liveView onRecvPraise];
        }
            break;
        case AVIMCMD_Host_Leave:{
            [self onRecvCustomLeave:msg];
        }
            break;
        case AVIMCMD_Host_Back:{
            [self onRecvCustomBack:msg];
        }
            break;
        default:{
        }
            break;
    }
}

/**
 有新用户进入

 @param receiver
 @param senders senders是id<IMUserAble>类型
 */
- (void)onIMHandler:(AVIMMsgHandler *)receiver joinGroup:(NSArray *)senders{
    [_liveView.topView onImUsersEnterLive:senders];
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[SARUserInfo userId] forKey:@"uid"];
    [dic setValue:[NSString stringWithFormat:@"%d",showItem.avRoomId] forKey:@"room_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:LIVE_PP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) requestGamesStates{
    if (_gameStates >15 && _gameStates <= 45){
        _userOneLab.text = [NSString stringWithFormat:@"剩余下注时间%ldS", (long)_gameStates - 15];
        //打开下注按钮的交互
        _chipOne.enabled = YES;
        _chipTwo.enabled = YES;
        _chipThreen.enabled = YES;
        _chipFour.enabled = YES;
        //影藏显示点数的imageview
        _userOnepointImageViewOne.hidden = YES;
        _userOnepointImageViewTwo.hidden = YES;
        _userOnepointImageViewThreen.hidden = YES;
        _userTwopointImageViewOne.hidden = YES;
        _userTwopointImageViewTwo.hidden = YES;
        _userTwopointImageViewThreen.hidden = YES;
        _userThreenpointImageViewOne.hidden = YES;
        _userThreeenpointImageViewTwo.hidden = YES;
        _userThreenpointImageViewThreen.hidden = YES;
        if (_butShow == 1) {
            _userOneBut.hidden = NO;
            _userTwoBut.hidden = NO;
            _userThreenBut.hidden = NO;
            _butShow = 0;
        }else{
        }
        _showPoint.text =@"";
        _userOneInfoLab.text = @"";
        _userTwoInfoLab.text = @"";
        _userThreeInfoLab.text = @"";
    }else if (_gameStates > 10 && _gameStates <= 15){
        [self paylerMusice:@"yaosaiz.mp3"];
        for (id tmpView in [self.userOneView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }
            }
        }
        for (id tmpView in [self.userTwoView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }
            }
        }
        for (id tmpView in [self.userThreenView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }
            }
        }
        //关闭下注按钮的交互
        _chipOne.enabled = NO;
        _chipTwo.enabled = NO;
        _chipThreen.enabled = NO;
        _chipFour.enabled = NO;
        _userOneBut.hidden = YES;
        _userTwoBut.hidden = YES;
        _userThreenBut.hidden = YES;
        _showPoint.text =@"";
        _userOneInfoLab.text = @"";
        _userTwoInfoLab.text = @"";
        _userThreeInfoLab.text = @"";
        _userOneLab.text = @"正在游戏中请稍后";
        //显示骰子动画的数组
        NSMutableArray *sixArr = [NSMutableArray array];
        for (int i = 0; i< 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_Action_%d.png",i]];
            [sixArr addObject:image];
        }
        _pointImageViewOne.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _pointImageViewOne.animationDuration = 0.3;//设置动画时间
        _pointImageViewOne.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_pointImageViewOne startAnimating];//开始播放动画
        _pointImageViewTwo.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _pointImageViewTwo.animationDuration = 0.3;//设置动画时间
        _pointImageViewTwo.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_pointImageViewTwo startAnimating];//开始播放动画
        _pointImageViewThreen.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _pointImageViewThreen.animationDuration = 0.3;//设置动画时间
        _pointImageViewThreen.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_pointImageViewThreen startAnimating];//开始播放动画
        //显示隐藏的显示点数的imageview
        _userOnepointImageViewOne.hidden = NO;
        _userOnepointImageViewOne.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userOnepointImageViewOne.animationDuration = 0.3;//设置动画时间
        _userOnepointImageViewOne.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userOnepointImageViewOne startAnimating];//开始播放动画
        _userOnepointImageViewTwo.hidden = NO;
        _userOnepointImageViewTwo.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userOnepointImageViewTwo.animationDuration = 0.3;//设置动画时间
        _userOnepointImageViewTwo.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userOnepointImageViewTwo startAnimating];//开始播放动画
        _userOnepointImageViewThreen.hidden = NO;
        _userOnepointImageViewThreen.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userOnepointImageViewThreen.animationDuration = 0.3;//设置动画时间
        _userOnepointImageViewThreen.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userOnepointImageViewThreen startAnimating];//开始播放动画
        _userTwopointImageViewOne.hidden = NO;
        _userTwopointImageViewOne.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userTwopointImageViewOne.animationDuration = 0.3;//设置动画时间
        _userTwopointImageViewOne.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userTwopointImageViewOne startAnimating];//开始播放动画
        _userTwopointImageViewTwo.hidden = NO;
        _userTwopointImageViewTwo.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userTwopointImageViewTwo.animationDuration = 0.3;//设置动画时间
        _userTwopointImageViewTwo.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userTwopointImageViewTwo startAnimating];//开始播放动画
        _userTwopointImageViewThreen.hidden = NO;
        _userTwopointImageViewThreen.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userTwopointImageViewThreen.animationDuration = 0.3;//设置动画时间
        _userTwopointImageViewThreen.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userTwopointImageViewThreen startAnimating];//开始播放动画
        _userThreenpointImageViewOne.hidden = NO;
        _userThreenpointImageViewOne.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userThreenpointImageViewOne.animationDuration = 0.3;//设置动画时间
        _userThreenpointImageViewOne.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userThreenpointImageViewOne startAnimating];//开始播放动画
        _userThreeenpointImageViewTwo.hidden = NO;
        _userThreeenpointImageViewTwo.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userThreeenpointImageViewTwo.animationDuration = 0.3;//设置动画时间
        _userThreeenpointImageViewTwo.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userThreeenpointImageViewTwo startAnimating];//开始播放动画
        _userThreenpointImageViewThreen.hidden = NO;
        _userThreenpointImageViewThreen.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
        _userThreenpointImageViewThreen.animationDuration = 0.3;//设置动画时间
        _userThreenpointImageViewThreen.animationRepeatCount = 2;//设置动画次数 0 表示无限
        [_userThreenpointImageViewThreen startAnimating];//开始播放动画
    }else if (_gameStates > 5 && _gameStates <= 10){
        if (_gameStates == 10) {
            [self requestGamesNumber];
        }
        //关闭下注按钮的交互
        _chipOne.enabled = NO;
        _chipTwo.enabled = NO;
        _chipThreen.enabled = NO;
        _chipFour.enabled = NO;
        _userOneLab.text = @"游戏结束请等待下局";
    }else if (_gameStates > 0 && _gameStates <= 5){
        //关闭下注按钮的交互
        _chipOne.enabled = NO;
        _chipTwo.enabled = NO;
        _chipThreen.enabled = NO;
        _chipFour.enabled = NO;
        _userOneManay.text = @"0/0";
        _userTwoManay.text = @"0/0";
        _userThreeManay.text = @"0/0";
        _userOneLab.text = [NSString stringWithFormat:@"休息时间%ldS", (long)_gameStates];
        _showPoint.text =@"";
        _userOneInfoLab.text = @"";
        _userTwoInfoLab.text = @"";
        _userThreeInfoLab.text = @"";
        _butShow = 1;
        if (_gameStates == 1) {
            [self userIntoRoomRequestGamesState];
        }
    }else if (_gameStates == 0){
        _gameStates = 45;
    }
    _gameStates--;
}

/**
 用户进入房间开始向服务器请求游戏状态
 */
- (void) userIntoRoomRequestGamesState{
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
    [dic setValue:roomid forKey:@"room_id"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:DICEGAME_STATE_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tmpdic = responseObject[@"data"];
        if ([responseObject[@"message"] isEqualToString:@"fail"]) {
            [[HUDHelper sharedInstance] tipMessage:@"获取游戏状态失败"];
        }else{
            if ([tmpdic[@"game_state"] integerValue] == 1) {
                _gameStates = [tmpdic[@"bet_count_down"] integerValue] + 15;
            }else if ([tmpdic[@"game_state"] integerValue] == 2){
                _gameStates = 15;
            }else if ([tmpdic[@"game_state"] integerValue] == 3){
                _gameStates = 10;
            }else if([tmpdic[@"game_state"] integerValue] == 0){
                _gameStates = [tmpdic[@"bet_count_down"] integerValue];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (void)paylerMusice:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
}

- (void) requestGamesNumber{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    TCShowLiveListItem *showItem = (TCShowLiveListItem *)self.liveController.roomInfo;
    NSString *roomid = [NSString stringWithFormat:@"%d",showItem.avRoomId];
    [dic setValue:roomid forKey:@"room_id"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    __weak typeof(self) weakSelf = self;
    [manger POST:DICE_LIST_DATA parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = responseObject[@"data"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"table_number"] integerValue] == 0) {
                weakSelf.showPoint.hidden = NO;
                weakSelf.showPoint.text = [NSString stringWithFormat:@"%@点",dic[@"point_sum"]];
                NSString *str = dic[@"point"];
                NSMutableArray *numArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
                for (int i = 0; i < 3; i++) {
                    NSString *obj = numArr[i];
                    if (obj.length > 1) {
                        NSString *tip = [obj substringWithRange:NSMakeRange(4, 1)];
                        [numArr removeObjectAtIndex:i];
                        [numArr addObject:tip];
                    }
                }
                weakSelf.pointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                weakSelf.pointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                weakSelf.pointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
            }else if ([dic[@"table_number"] integerValue] == 1){
                weakSelf.userOneInfoLab.hidden = NO;
                weakSelf.userOneInfoLab.text = [NSString stringWithFormat:@"%@点",dic[@"point_sum"]];
                NSString *str = dic[@"point"];
                NSMutableArray *numArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
                for (int i = 0; i < 3; i++) {
                    NSString *obj = numArr[i];
                    if (obj.length > 1) {
                        NSString *tip = [obj substringWithRange:NSMakeRange(4, 1)];
                        [numArr removeObjectAtIndex:i];
                        [numArr addObject:tip];
                        weakSelf.userOnepointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userOnepointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userOnepointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }else{
                        weakSelf.userOnepointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userOnepointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userOnepointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }
                }
            }else if ([dic[@"table_number"] integerValue] == 2){
                weakSelf.userTwoInfoLab.hidden = NO;
                weakSelf.userTwoInfoLab.text = [NSString stringWithFormat:@"%@点",dic[@"point_sum"]];
                NSString *str = dic[@"point"];
                NSMutableArray *numArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
                for (int i = 0; i < 3; i++) {
                    NSString *obj = numArr[i];
                    if (obj.length > 1) {
                        NSString *tip = [obj substringWithRange:NSMakeRange(4, 1)];
                        [numArr removeObjectAtIndex:i];
                        [numArr addObject:tip];
                        weakSelf.userTwopointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userTwopointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userTwopointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }else{
                        weakSelf.userTwopointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userTwopointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userTwopointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }
                }
            }else if ([dic[@"table_number"] integerValue] == 3){
                weakSelf.userThreeInfoLab.hidden = NO;
                weakSelf.userThreeInfoLab.text = [NSString stringWithFormat:@"%@点",dic[@"point_sum"]];
                NSString *str = dic[@"point"];
                NSMutableArray *numArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
                for (int i = 0; i < 3; i++) {
                    NSString *obj = numArr[i];
                    if (obj.length > 1) {
                        NSString *tip = [obj substringWithRange:NSMakeRange(4, 1)];
                        [numArr removeObjectAtIndex:i];
                        [numArr addObject:tip];
                        weakSelf.userThreenpointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userThreeenpointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userThreenpointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }else{
                        weakSelf.userThreenpointImageViewOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[0]]];
                        weakSelf.userThreeenpointImageViewTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[1]]];
                        weakSelf.userThreenpointImageViewThreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",numArr[2]]];
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    if (self.secondTimer == 0) {
        self.secondTimer = 35;
    }else{
        self.secondTimer --;
    }
    if (self.showTimerNumb == 0) {
        self.showTimerNumb = 35;
    }else{
        self.showTimerNumb--;
    }
}

//- (void)createNiuniuGamesBtuTitle{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    __weak typeof(self) weakSelf = self;
//    [manager POST:LIVE_CONINLISTS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *arr = responseObject[@"data"];
//        for (int i =0; i < arr.count; i++) {
//            if (i == 0) {
//                NSDictionary *dic = arr[0];
//                [weakSelf.topView.firstBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
//                weakSelf.topView.firstBtu.tag = [dic[@"lemon_id"] integerValue];
//            }else if (i== 1){
//                NSDictionary *dic = arr[1];
//                [weakSelf.topView.secondBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
//                weakSelf.topView.secondBtu.tag = [dic[@"lemon_id"] integerValue];
//            }else if (i== 2){
//                NSDictionary *dic = arr[2];
//                [weakSelf.topView.threidBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
//                weakSelf.topView.threidBtu.tag = [dic[@"lemon_id"] integerValue];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
//}

// 有用户退出
// senders是id<IMUserAble>类型
- (void)onIMHandler:(AVIMMsgHandler *)receiver exitGroup:(NSArray *)senders{
    // do nothing
    // overwrite by the subclass
    [_liveView.topView onImUsersExitLive:senders];
}


@end

//==================================================================================================================================================================

@implementation TCShowLiveViewController

- (void)addLiveView
{
    TCShowLiveUIViewController *vc = [[TCShowLiveUIViewController alloc] initWith:self];
    [self addChild:vc inRect:self.view.bounds];
    _liveView = vc;
}

- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        
        id<AVUserAble> ah = (id<AVUserAble>)_currentUser;
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        TCShowLiveRoomEngine *roomEngine = [[TCShowLiveRoomEngine alloc] initWith:(id<IMHostAble, AVUserAble>)_currentUser enableChat:_enableIM];
        // 测试默认开启后置摄像头
        // roomEngine.cameraId = CameraPosBack;
        roomEngine.delegate = self;
        _roomEngine = roomEngine;
        
        if (!_isHost)
        {
            [_liveView setRoomEngine:_roomEngine];
        }
    }
}

- (NSInteger)defaultAVHostConfig
{
    
    // 添加推荐配置
    if (_isHost)
    {
        return EAVCtrlState_Mic | EAVCtrlState_Speaker | EAVCtrlState_Camera;
    }
    else
    {
        return EAVCtrlState_Speaker;
    }
}


- (void)onAVEngine:(TCAVBaseRoomEngine *)engine users:(NSArray *)users exitRoom:(id<AVRoomAble>)room
{
    // 此处，根据具体业务来处理：比如的业务下，支持主播可以退出再进，这样观众可以在线等待就不用退出了
    NSString *roomHostId = [[room liveHost] imUserId];
    for (id<IMUserAble> iu in users)
    {
        if ([[iu imUserId] isEqualToString:roomHostId])
        {
            if (!self.isExiting)
            {
                [self willExitLiving];
                // 说明主播退出
                UIAlertView *alert =  [UIAlertView bk_showAlertViewWithTitle:nil message:@"主播已退出当前直播" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self exitLive];
                }];
                [alert show];
                break;
            }
        }
    }
}


- (void)prepareIMMsgHandler
{
    if (!_msgHandler)
    {
        _msgHandler = [[TCShowAVIMHandler alloc] initWith:_roomInfo];
        _liveView.msgHandler = (TCShowAVIMHandler *)_msgHandler;
        [_msgHandler enterLiveChatRoom:nil fail:nil];
        
        [(TCShowLiveUIViewController *)_liveView onIMHandler:(TCShowAVIMHandler *)_msgHandler joinGroup:@[_currentUser]];
    }
    else
    {
        __weak AVIMMsgHandler *wav = (AVIMMsgHandler *)_msgHandler;
        __weak id<AVRoomAble> wr = _roomInfo;
        [_msgHandler exitLiveChatRoom:^{
            [wav switchToLiveRoom:wr];
            [wav enterLiveChatRoom:nil fail:nil];
        } fail:^(int code, NSString *msg) {
            [wav switchToLiveRoom:wr];
            [wav enterLiveChatRoom:nil fail:nil];
        }];
    }
}
#if kSupportIMMsgCache

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame
{
    [super onAVEngine:engine videoFrame:frame];
    
    [self renderUIByAVSDK];
}

- (void)renderUIByAVSDK
{
    // AVSDK采集为20帧每秒 : 具体数值看云后台配置
    // 可通过此处的控制显示的频率
    _uiRefreshCount++;
    TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
    // 1秒更新点赞
    if (_uiRefreshCount % 40 == 0 && ![vc isPureMode]){
        NSDictionary *dic = [(AVIMMsgHandler *)_msgHandler getMsgCache];
        AVIMCache *msgcache = dic[@(AVIMCMD_Text)];
        [vc onUIRefreshIMMsg:msgcache];
        AVIMCache *praisecache = dic[@(AVIMCMD_Praise)];
        [vc onUIRefreshPraise:praisecache];
    }
}
#endif

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine enableCamera:(BOOL)succ tipInfo:(NSString *)tip
{
    [super onAVEngine:engine enableCamera:succ tipInfo:tip];
    if (succ)
    {
        // 调用liveStart接口
        TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
        [vc uiStartLive];
    }
}

- (void)onExitLiveSucc:(BOOL)succ tipInfo:(NSString *)tip{
    [self releaseIMMsgHandler];
    [_liveView setMsgHandler:nil];
    TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
    if (_isHost){
        // 显示直播结果
        [vc uiEndLive];
    }else{
        [[HUDHelper sharedInstance] tipMessage:tip delay:0.5 completion:^{
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (BOOL)switchToLive:(id<AVRoomAble>)room{
    BOOL succ = [super switchToLive:room];
    if (succ){
        TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
        [vc switchToLiveRoom:room];
    }
    return succ;
}

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine onStartPush:(BOOL)succ pushRequest:(TCAVLiveRoomPushRequest *)req{
    TCShowLiveUIViewController *uivc = (TCShowLiveUIViewController *)_liveView;
    [uivc onStartPush:succ pushRequest:req];
}

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine onRecord:(BOOL)succ recordRequest:(TCAVLiveRoomRecordRequest *)req{
    TCShowLiveUIViewController *uivc = (TCShowLiveUIViewController *)_liveView;
    [uivc onStartRecord:succ recordRequest:req];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end


