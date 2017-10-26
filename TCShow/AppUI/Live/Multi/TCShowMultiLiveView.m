//
//  TCShowMultiLiveView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportMultiLive
#import "TCShowMultiLiveView.h"
#import "TCShowLiveUSerDeatilView.h"
#import "TCLiveUserList.h"

@implementation TCShowMultiLiveTopView

- (instancetype)initWith:(id<TCShowLiveRoomAble>)room
{
    if (self = [super initWith:room])
    {
        if ([[IMAPlatform sharedInstance].host isCurrentLiveHost:room])
        {
            _interactButton = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
//            [_interactButton setBackgroundImage:[UIImage imageNamed:@"interactive"] forState:UIControlStateNormal];
//            [_interactButton addTarget:self action:@selector(onClickInteract) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_interactButton];
        }
    }
    return self;
}

- (void)onClickInteract
{
    if ([self.delegate respondsToSelector:@selector(onTopViewClickInteract:)])
    {
        [self.delegate onTopViewClickInteract:self];
    }
}

- (void)relayoutPARView
{
    if (_interactButton)
    {
        [_interactButton sizeWith:CGSizeMake(45, 25)];
        [_interactButton alignLeft:_timeView];
        [_interactButton layoutBelow:_timeView margin:kDefaultMargin];
        
        [_parView sameWith:_interactButton];
        [_parView layoutToRightOf:_interactButton margin:kDefaultMargin];
        [_parView scaleToParentRightWithMargin:kDefaultMargin];
        [_parView relayoutFrameOfSubViews];
    }
    else
    {
        [super relayoutPARView];
    }
}

@end

@implementation TCShowMultiLiveView

- (void)addTopView
{
    _multiView = [[TCShowMultiView alloc] init];
    [self addSubview:_multiView];
    
    _topView = [[TCShowMultiLiveTopView alloc] initWith:_room];
    _topView.timeView.delegate = self;
    __weak typeof(self) weakself = self;
    _topView.userListClickBack = ^(TCLiveUserList *user) {
        [weakself showUserDeatilViewWithUser:user];
    };
    [self addSubview:_topView];
}

// 用户头像点击方法
- (void)showUserDeatilViewWithUser:(TCLiveUserList *)user {
    TCShowLiveUSerDeatilView *view = [[TCShowLiveUSerDeatilView alloc] initWithUser:user];
    __weak typeof(self) weakself = self;
    view.clickSendMsgBtnBlock = ^(TCLiveUserList *user) {
        if (weakself.sendMsgBtnClickBlock) {
            weakself.sendMsgBtnClickBlock(user);
        }
    };
    [self addSubview:view];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    
    [_topView setFrameAndLayout:CGRectMake(0, 0, rect.size.width, 110)];
    
    [_multiView sizeWith:CGSizeMake(80, kDefaultMargin)];
    [_multiView layoutBelow:_topView];
    [_multiView alignParentRightWithMargin:kDefaultMargin];
    [_multiView relayoutFrameOfSubViews];
    
    [_bottomView sizeWith:CGSizeMake(rect.size.width, 60)];
    [_bottomView alignParentBottomWithMargin:0];
    [_bottomView relayoutFrameOfSubViews];
    
    [_inputView sameWith:_bottomView];
    [_inputView shrinkVertical:10];
    [_inputView relayoutFrameOfSubViews];
    
    [_msgView sizeWith:CGSizeMake((NSInteger)(rect.size.width * 0.7), 210)];
    [_msgView layoutBelow:_topView margin:kDefaultMargin];
    [_msgView scaleToAboveOf:_bottomView margin:kDefaultMargin];
    [_msgView relayoutFrameOfSubViews];
    

    [_parTextView sameWith:_topView];
    [_parTextView layoutBelow:_topView margin:kDefaultMargin];
    [_parTextView scaleToAboveOf:_bottomView margin:kDefaultMargin];
}

- (void)onUserLeave:(NSArray *)users
{
    // 直播场景下，不做处理
    [_multiView onUserLeave:users];
}
- (void)onUserBack:(NSArray *)users
{
    // 直播场景下，不做处理
    [_multiView onUserBack:users];
}

@end
#endif
