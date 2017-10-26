//
//  TCShowLiveTopView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCShowLiveTopView;

@class TCShowLiveTimeView;

@class TCLiveUserList;

@protocol TCShowLiveTopViewDelegate <NSObject>

@optional
- (void)onTopViewCloseLive:(TCShowLiveTopView *)topView;

- (void)onTopViewClickHost:(TCShowLiveTopView *)topView host:(TCShowLiveListItem *)host;

// for 互动直播
- (void)onTopViewClickInteract:(TCShowLiveTopView *)topView;

@optional
- (void)onTopView:(TCShowLiveTopView *)topView clickPAR:(UIButton *)par;
- (void)onTopView:(TCShowLiveTopView *)topView clickPush:(UIButton *)push;
- (void)onTopView:(TCShowLiveTopView *)topView clickREC:(UIButton *)rec;
- (void)onTopView:(TCShowLiveTopView *)topView clickSpeed:(UIButton *)speed;


@end


@protocol TCShowLiveTimeViewDelegate <NSObject>

- (void)onTimViewTimeRefresh:(TCShowLiveTimeView *)topView;

@end


@interface TCShowLiveTimeView : UIView
{
@protected
    MenuButton          *_liveHost;
    ImageTitleButton    *_liveTime;
    ImageTitleButton    *_liveAudience;
    ImageTitleButton    *_livePraise;
    
    
    UIButton * _liveStateButton;//add by yanghui 2016年12月22日16:08:02
    UILabel * _attentionLabel;//add by yanghui 2016年12月22日16:27:51
    UIButton * _attentionButton;//add by yanghui 2016年12月22日16:53:02
    
@protected
    NSTimer             *_liveTimer;
    
@protected
    TCShowLiveListItem * _room;
}

//@property (nonatomic, strong) UILabel *attentionLabel;

@property (nonatomic, readonly) MenuButton *liveHost;

@property (nonatomic, weak) id<TCShowLiveTimeViewDelegate> delegate;

- (instancetype)initWith:(id<TCShowLiveRoomAble>)room;

- (void)startLive;
- (void)pauseLive;
- (void)resumeLive;

- (void)onImUsersEnterLive:(NSArray *)array;
- (void)onImUsersExitLive:(NSArray *)array;

- (void)onRefrshPraiseAndAudience;

- (void)changeRoomInfo:(id<TCShowLiveRoomAble>)room;

@end


@interface TCShowLiveTopView : UIView<TCShowAVParViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
@protected
    TCShowLiveTimeView *_timeView;
    UIButton           *_close;
#if kBetaVersion
    UILabel            *_roomTip;
#endif
    
@protected
    TCShowAVParView     *_parView;
    UICollectionView * _userlist;//观看列表
    
    
@protected
    TCShowLiveListItem * _room;
    
}
@property (nonatomic, weak) id<TCShowLiveTopViewDelegate> delegate;
@property (nonatomic, readonly) TCShowLiveTimeView *timeView;
@property (nonatomic,strong)NSMutableArray * spectatorDataSource;
@property (nonatomic, copy) void (^userListClickBack)(TCLiveUserList *user);
//@property (nonatomic, weak) TCShowAVIMHandler *imSender;
- (instancetype)initWith:(id<TCShowLiveRoomAble>)room;

- (void)onImUsersEnterLive:(NSArray *)array;
- (void)onImUsersExitLive:(NSArray *)array;

- (void)startLive;
- (void)pauseLive;
- (void)resumeLive;

- (void)onRefrshPraiseAndAudience;

- (void)onRefrshPARView:(TCAVLiveRoomEngine *)engine;

- (void)changeRoomInfo:(id<TCShowLiveRoomAble>)room;

// protected
- (void)relayoutPARView;

@end
