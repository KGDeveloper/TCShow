//
//  TCShowLiveView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCZActionSheet.h"
#import "GCZPresentItem.h"
#import "GCZPresentMenu.h"
#import "GCZPresentView.h"
#import "GiftModel.h"
@class TCShowLiveView;
@class TCLiveUserList;
@protocol LivingViewDelegate <NSObject>
@optional
// 送礼物
- (void)sendPresent:(TCShowLiveView *)showLiveView type:(Gift *)type num:(NSUInteger)num;
-(void)showVVCC;
-(void)showGitWithArray:(NSArray *)array;

@end
@interface TCShowLiveView : UIView<TCShowLiveBottomViewDelegate, TCShowLiveTimeViewDelegate>
{
@protected
    UITextView                  *_parTextView;
    
@protected
    TCShowLiveTopView           *_topView;

    
    TCShowLiveMessageView       *_msgView;
    TCShowLiveBottomView        *_bottomView;
    
    TCShowLiveInputView         *_inputView;
    BOOL                         _inputViewShowing;
    
@protected
    __weak id<TCShowLiveRoomAble>   _room;
    __weak TCAVLiveRoomEngine       *_roomEngine;
    __weak AVIMMsgHandler           *_msgHandler;
}
@property (nonatomic, weak) id <LivingViewDelegate> delegate;  //add by zxd 2016-09-22 17:50
@property (nonatomic, readonly) TCShowLiveTopView *topView;
@property (nonatomic, readonly) TCShowLiveMessageView *msgView;
@property (nonatomic, readonly) TCShowLiveBottomView *bottomView;
@property (nonatomic, copy) void (^charmViewClickBlock)();
@property (nonatomic, copy) void (^shareViewClickBlock)();
@property (nonatomic, copy) void (^sendMsgBtnClickBlock)(TCLiveUserList *user);

@property (nonatomic, weak) TCAVLiveRoomEngine *roomEngine;
@property (nonatomic, weak) AVIMMsgHandler *msgHandler;
@property (nonatomic, readonly) BOOL isPureMode;

// 送礼物
- (void)sendPresent:(PresentType)type num:(NSUInteger)num userName:(NSString *)userName userLogo:(NSString *)userLogo;          //add by zxd 2016-09-22 17:50

-(void)sendGiftWithGiftModel:(GiftModel *)giftModel;


-(void)addSendGiftMessage:(NSString *)username imageName:(NSString *)imgName;
- (instancetype)initWith:(id<TCShowLiveRoomAble>)room;

- (void)hideInputView;

- (void)startLive;
- (void)pauseLive;
- (void)resumeLive;

- (void)onRecvPraise;
#if kSupportIMMsgCache
- (void)onRecvPraise:(AVIMCache *)cache;
#endif

- (void)onTapBlank:(UITapGestureRecognizer *)tap;

- (void)showPar:(UIButton *)par;
- (void)onRefreshPAR;

// for 多人互动
- (void)onClickSub:(id<AVMultiUserAble>)user;

- (void)changeRoomInfo:(id<TCShowLiveRoomAble>)room;


- (void)onUserLeave:(NSArray *)users;
- (void)onUserBack:(NSArray *)user;

@end
