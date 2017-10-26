//
//  TCShowLiveBottomView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)();// add by zxd on 2016-10-01 15:27
typedef NS_ENUM(NSInteger, TCShowLiveFunctionType) {
    // 当前用户自己的
    EFunc_LED       = 0x01<< 6,           // LED灯
    EFunc_MSG       = 0x01 << 1,      // 消息
    EFunc_Camera    = 0x01 << 4,      // 相机
    EFunc_Beauty    = 0x01 << 5,      // 美颜
    EFunc_White    = 0x01 << 2,      // 美白
    EFunc_Mic       = 0x01 << 3,      // 麦克风
    EFunc_Speaker   = 0x01 ,      // 扬声器
    EFunc_Share     = 0x01 << 7,      // 分享
    
    
    // 操作互动观众的
    EFunc_Multi_Camera = 0x01 << 8,            // 操作对方的camera
    EFunc_Multi_Mic = 0x01 << 9,               // 操作对方的mic
    EFunc_Multi_SwitchToMain = 0x01 << 10,      // 切换到全屏
    EFunc_Multi_CancelInteract = 0x01 << 11,    // 取消互动
    
    EFunc_Pure      = 0x01 << 12,      // 纯净模式
    EFunc_NonPure   = 0x01 << 13,      // 非纯净模式
    EFunc_Praise    = 0x01 << 14,      // 点赞
    EFunc_GIFT      = 0x01 << 15,      //送礼物  add by zxd on 2016-09-20 15:49
    
    // 本地操作
    EFunc_LocalAll = EFunc_LED | EFunc_MSG | EFunc_Camera | EFunc_Beauty | EFunc_White | EFunc_Mic | EFunc_Speaker | EFunc_Share | EFunc_Pure | EFunc_NonPure | EFunc_Praise,
    EFunc_MultiAll = EFunc_Multi_Mic | EFunc_Multi_Camera | EFunc_Multi_SwitchToMain | EFunc_Multi_CancelInteract,
    
};


@class TCShowLiveBottomView;

@protocol TCShowLiveBottomViewDelegate <NSObject>

- (void)onBottomViewSwitchToPureMode:(TCShowLiveBottomView *)bottomView;
- (void)onBottomViewSwitchToNonPureMode:(TCShowLiveBottomView *)bottomView;
- (void)onBottomViewSwitchToMessage:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button;

- (void)onBottomViewSendPraise:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button;
@end


@protocol TCShowLiveBottomViewMultiDelegate <NSObject>

- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateCameraOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateMicOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView switchToMain:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView cancelInteractWith:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;


@end
@interface TCShowLiveBottomView : UIView
{
@protected
    NSMutableArray  *_showFuncs;
    
@protected
    NSInteger _nonPureFunc;     // 非纯净模式前的
    NSInteger _lastFunc;
    
    CGFloat  _lastFloatBeauty;  // 主要为界面上重新条开时一致
    CGFloat  _lastFloatWhite;  // 主要为界面上重新条开时一致
    
    CGRect   _heartRect;
    
@protected
    id<AVMultiUserAble>  _showUser;  // 多人互动时才会用到
    
#if kSupportIMMsgCache
    NSMutableArray *_praiseImageCache;
    NSMutableArray *_praiseAnimationCache;
#endif
}

@property (nonatomic,copy) TCLiveGoodsView * goodsView;
@property (nonatomic, copy) BtnClickBlock btnClickBlock; // add by zxd on 2016-10-01 15:27
@property (nonatomic, weak) TCAVLiveRoomEngine *roomEngine;
@property (nonatomic, weak) id<TCShowLiveBottomViewDelegate> delegate;
@property (nonatomic, weak) id<TCShowLiveBottomViewMultiDelegate> multiDelegate;
@property (nonatomic,copy)NSString * manageUid;

@property (nonatomic, copy) void (^shareViewClick)();

- (BOOL)isPureMode;

- (void)showLikeHeart;
#if kSupportIMMsgCache
- (void)showLikeHeart:(AVIMCache *)cache;
#endif
// 当前主播视角才有效
- (void)switchToShowMultiInteract:(id<AVMultiUserAble>)showUser isMain:(BOOL)main;

- (void)updateShowFunc;



@end
