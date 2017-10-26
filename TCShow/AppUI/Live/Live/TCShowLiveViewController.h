//
//  TCShowLiveViewController.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCAVLiveViewController.h"
#import "QZKRechargeView.h"
#import "QZKPlayNiuNiuGames.h"
#import "QZKHeartView.h"
#import "QZKUserIntoMessageView.h"
#import "QZKUserEnterMsgView.h"
#import "QZKManayChangeMsg.h"

// 主要控制直播时界面的IM交互逻辑
@interface TCShowLiveUIViewController : TCAVLiveBaseViewController<TCShowLiveTopViewDelegate,QZKPlayNiuNiuGamesDelegate>
{
@protected
    TCShowLiveView      *_liveView;
    NSTimer             *_heartTimer;
    BOOL                _isPostLiveStart;
    NSTimer  *setStetasToServer;
    NSTimer     *userIntoRoom;
    TCAVBaseRoomEngine *roomEngineInfo;
    QZKHeartView *myV;
    
    id<AVRoomAble>                          _roomInfo;          // 房间信息
    id<IMHostAble>                          _IMUser;
    
}
@property (nonatomic, assign) BOOL isPostLiveStart;
@property (nonatomic,assign) BOOL isFirst;//判断是否是刚进入房间

/**
 存储动画照片的数组
 */
@property (nonatomic,assign) NSMutableArray *imageArr;
/**
 玩骰子游戏
 */
@property (nonatomic,strong) UIView *playGamesView;
/**
 用户玩骰子游戏的窗体
 */
@property (nonatomic,strong) UIView *userPlayGamesView;
/**
 用户游戏的一号桌
 */
@property (nonatomic,strong) UIView *userOneView;
/**
 用户游戏的二号桌
 */
@property (nonatomic,strong) UIView *userTwoView;
/**
 用户游戏的三号桌
 */
@property (nonatomic,strong) UIView *userThreenView;
/**
 显示点数的Label
 */
@property (nonatomic,strong) UILabel *showPoint;
/**
 显示点数的第一张
 */
@property (nonatomic,strong) UIImageView *pointImageViewOne;
/**
 显示点数的第二张
 */
@property (nonatomic,strong) UIImageView *pointImageViewTwo;
/**
 显示点数的第三张
 */
@property (nonatomic,strong) UIImageView *pointImageViewThreen;
/**
 一号桌显示点数的第一张
 */
@property (nonatomic,strong) UIImageView *userOnepointImageViewOne;
/**
 一号桌显示点数的第二张
 */
@property (nonatomic,strong) UIImageView *userOnepointImageViewTwo;
/**
 一号桌显示点数的第三张
 */
@property (nonatomic,strong) UIImageView *userOnepointImageViewThreen;
/**
 二号桌显示点数的第一张
 */
@property (nonatomic,strong) UIImageView *userTwopointImageViewOne;
/**
 二号桌显示点数的第二张
 */
@property (nonatomic,strong) UIImageView *userTwopointImageViewTwo;
/**
 二号桌显示点数的第三张
 */
@property (nonatomic,strong) UIImageView *userTwopointImageViewThreen;
/**
 三号桌显示点数的第一张
 */
@property (nonatomic,strong) UIImageView *userThreenpointImageViewOne;
/**
 三号桌显示点数的第二张
 */
@property (nonatomic,strong) UIImageView *userThreeenpointImageViewTwo;
/**
 三号桌显示点数的第三张
 */
@property (nonatomic,strong) UIImageView *userThreenpointImageViewThreen;
/**
 一号桌按钮
 */
@property (nonatomic,strong) UIButton *userOneBut;
/**
 二号桌按钮
 */
@property (nonatomic,strong) UIButton *userTwoBut;
/**
 三号桌按钮
 */
@property (nonatomic,strong) UIButton *userThreenBut;
/**
 10积分按钮
 */
@property (nonatomic,strong) UIButton *chipOne;
/**
 25积分按钮
 */
@property (nonatomic,strong) UIButton *chipTwo;
/**
 50积分按钮
 */
@property (nonatomic,strong) UIButton *chipThreen;
/**
 100积分按钮
 */
@property (nonatomic,strong) UIButton *chipFour;
/**
 积分兑换按钮
 */
@property (nonatomic,strong) UIButton *chipBut;
/**
 显示积分
 */
@property (nonatomic,strong) UILabel *chipLable;
/**
 计时器循环初始值
 */
@property (nonatomic,assign) NSInteger timerNumber;
/**
 显示倒计时信息的lable
 */
@property (nonatomic,strong) UILabel *userOneLab;
/**
 一号桌显示点数的lable
 */
@property (nonatomic,strong) UILabel *userOneInfoLab;
/**
 二号桌显示点数
 */
@property (nonatomic,strong) UILabel *userTwoInfoLab;
/**
 三号桌显示点数
 */
@property (nonatomic,strong) UILabel *userThreeInfoLab;

@property (nonatomic,assign) NSInteger intToTimer;
/**
 显示一号桌资金池
 */
@property (nonatomic,strong) UILabel *userOneManay;
/**
 显示二号桌资金池
 */
@property (nonatomic,strong) UILabel *userTwoManay;
/**
 显示三号桌资金池
 */
@property (nonatomic,strong) UILabel *userThreeManay;
@property (nonatomic,assign) NSInteger butShow;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,strong) QZKRechargeView *topView;
@property (nonatomic,strong) CADisplayLink *userdisplayLink;
@property (nonatomic,assign) NSInteger secondTimer;
@property (nonatomic,assign) NSInteger showTimerNumb;
@property (nonatomic,assign) NSInteger avLiveTime;
@property (nonatomic,assign) NSInteger sendavLiveTime;
@property (nonatomic,assign) NSInteger gameStates;

@property (nonatomic,strong) AVAudioPlayer *payler;
@property (nonatomic,strong) AVAudioPlayer *paylerTwo;

@property (nonatomic,strong) QZKPlayNiuNiuGames *niuniuGames;
@property (nonatomic,strong) UIView *changeView;
@property (nonatomic,assign) BOOL exitOrPush;//判断是跳转页面还是退出直播
@property (nonatomic,strong) UIButton *topBtu;
@property (nonatomic,strong) QZKUserEnterMsgView *chargeViewMsg;//显示充值飘屏
@property (nonatomic,strong) QZKManayChangeMsg *manayChange;//显示用户进入飘屏


#if kSupportIMMsgCache

// 更新消息
- (void)onUIRefreshIMMsg:(AVIMCache *)cache;
// 更新点赞
- (void)onUIRefreshPraise:(AVIMCache *)cache;

#endif

- (BOOL)isPureMode;

- (void)uiStartLive;

- (void)uiEndLive;

- (void)showLiveResult:(TCShowLiveListItem *)item;

- (void)onStartPush:(BOOL)succ pushRequest:(TCAVLiveRoomPushRequest *)req;
- (void)onStartRecord:(BOOL)succ recordRequest:(TCAVLiveRoomRecordRequest *)req;
- (void)switchToLiveRoom:(id<AVRoomAble>)room;
@end


//==================================================================================================================================================================

@interface TCShowLiveViewController : TCAVLiveViewController
{
#if kSupportIMMsgCache
    // 方案一:
    // 使用AVSDK刷新时，注意SDK的回调频繁为一秒多少次，调试时注意AVSDK频率，
    // 不适用于互动直播的场景，但可以比较灵活的控制不同的消息进行刷新控制
    NSInteger           _uiRefreshCount;
    
    // 方案二:
    // 其他方案，也可以通过计时器去做设置刷新界面的BOOL值，
    // 然后在- (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame;
    // 回调里面发现可以刷新界面，然后再做更新界面操作，本质是一样的
    // 缺点：所有消息都是固定频率刷新
    // 在TCShowMultiLiveViewController 中进行演示
#endif
}

#if kSupportIMMsgCache
// 使用AVSDK刷新时，注意SDK的回调频繁为一秒多少次，调试时注意AVSDK频率，
// 直播场景下，因为每个人的只有一路视频，所有收发消息，完会可以靠roomEngine - (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame; 回调处理
// 互动直播场景下，不能这样处理，为各路直播均会走回调，所以单靠_uiRefreshCount来护刷新是不行的
// 互动直播场景下再介绍具体处理方式
- (void)renderUIByAVSDK;
#endif


@end



