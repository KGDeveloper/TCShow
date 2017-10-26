//
//  TCShowLiveView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveView.h"
#import "MessageCellModel.h"
#import "GiftListShowVIew.h"
#import "NHHeader.h"
#import "NHPlaneViews.h"
#import "Business.h"
#import "TCCharmShowLiveView.h"
#import "TCLiveUserList.h"
#import "TCShowLiveUSerDeatilView.h"
#define NHBounds [UIScreen mainScreen].bounds.size
#import "AVIMAble.h"
@interface TCShowLiveView()<IMUserAble>
/** <#注释#> */
@property (nonatomic,strong) NSString *gift;

@end


@implementation TCShowLiveView {
    UILabel *_lemon_coinsLab;
    UILabel *_online_coinsLab;
    // 礼物视图
    GCZPresentView *presentView_;
    GCZActionSheet *actionSheet_;
}

//- (NSString *)imUserId{
//    
//}
//
//// 用户昵称
//- (NSString *)imUserName{
//    
//}
//
//// 用户头像地址
//- (NSString *)imUserIconUrl{
//    
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [actionSheet_ touchDismissModel];
}

- (instancetype)initWith:(id<TCShowLiveRoomAble>)room
{
    if (self = [super initWithFrame:CGRectZero])
    {
        
        _room = room;
        
        [self addOwnViews];
        [self configOwnViews];
//        [self addSystemInforms];
    }
    return self;
}

- (void)configOwnViews
{
    [self registerKeyBoardNotification];
    // 礼物视图 add by gcz 2016-05-29 17:42:06
    presentView_ = [GCZPresentView instance];
    presentView_.frame = CGRectMake(0, 0, presentView_.frame.size.width, presentView_.frame.size.height);
    [self addSubview:presentView_];
//    presentView_.backgroundColor = [UIColor redColor];
    // ---礼物列表---wxt
    __weak __typeof(presentView_) weakSelfpresentView__ = presentView_;
    __weak __typeof(self) weakSelf = self;
    _bottomView.btnClickBlock = ^{
        GCZPresentMenu *menu = [[[NSBundle mainBundle] loadNibNamed:@"GiftListShowVIew" owner:nil options:nil] firstObject];
        actionSheet_ = [[GCZActionSheet alloc] initWithCustomView:menu];
        [actionSheet_ present:^(id sender, Gift * g, NSUInteger num) {
            if ([weakSelf.delegate respondsToSelector:@selector(sendPresent:type:num:)]) {
                [weakSelf.delegate sendPresent:weakSelf type:g num:num];
            }
        }];
        [actionSheet_ pay:^{
            [actionSheet_ touchDismissModel];
            [weakSelf.delegate showVVCC];
        }];
    
    };
    _bottomView.shareViewClick = ^{
        if (weakSelf.shareViewClickBlock) {
            weakSelf.shareViewClickBlock();
        }
    };
    
//    self.msgHandler
}

#pragma mark - 送礼物

- (void)sendPresent:(NSInteger)type num:(NSUInteger)num userName:(NSString *)userName userLogo:(NSString *)userLogo
{
    dispatch_async(dispatch_get_main_queue(), ^{

        GiftModel * model = [[GiftModel alloc]init];
        [presentView_ animationWith:model];
        if (type==14) {
            NHCarView *car = [NHCarView loadCarViewWithPoint:CGPointZero];
            NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
            CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
            [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
            car.curveControlAndEndPoints = pointArrs;
            [car addAnimationsMoveToPoint:CGPointMake(0, 100) endPoint:CGPointMake(self.bounds.size.width +166, 500)];
            [self addSubview:car];
        }
//        [presentView_ showPresentViewWith:userLogo name:userName type:type num:num];
//        if (num == 1) { // edit by gcz 2016-05-31 17:39:57 有礼物就显示在列表里
//        [self addSendGiftMessage:userName imageName:[presentView_ nameWithType:type]];
//        }
    });
}
-(void)sendGiftWithGiftModel:(GiftModel *)giftModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        GiftModel * model = [[GiftModel alloc]init];
        [presentView_ animationWith:giftModel];
        if (giftModel.type==4) {
            
            NSMutableArray *sixArr = [NSMutableArray array];
            for (int i = 1; i< 16; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"nmp%d.png",i]];
                [sixArr addObject:image];
            }
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
            
        }
        if (giftModel.type==5) {
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 1; i< 7; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loves%d.png",i]];
                    
                    [sixArr addObject:image];
                    
                }
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
        }
        if (giftModel.type==6) {
            
                
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 0; i< 14; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"magic%d.png",i]];
                    
                    [sixArr addObject:image];
                    
                }
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
        }
        if (giftModel.type==7) {
            
                
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 0; i< 18; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ring%d.png",i]];
                    
                    [sixArr addObject:image];
                    
                }
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
        }
        if (giftModel.type==12) {
            
                
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 1; i< 24; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Cake%d.png",i]];
                    
                    [sixArr addObject:image];
                }
            
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
        }
        if (giftModel.type==13) {
            
                
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 1; i< 14; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"城堡%d.png",i]];
                    
                    [sixArr addObject:image];
                }
            
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
        }
        if (giftModel.type==14) {
            
            UIImageView *car = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 255, 87)];
            NSInteger tmp = arc4random()%5;
            car.tag = 10001;
            car.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld-%ld",(long)tmp,(long)tmp]];
            [self addSubview:car];
            
            [UIView animateWithDuration:0.4 animations:^{
                
                car.frame = CGRectMake(kSCREEN_WIDTH - 10, kSCREEN_HEIGHT/2 + 50, 255, 87);
            }];
            
            [self addSubview:car];
            
            for (id tmpImage in [self subviews]) {
                
                if ([tmpImage isKindOfClass:[UIImageView class]]) {
                    
                    UIImageView *tmpImageView = (UIImageView *)tmpImage;
                    
                    if (tmpImageView.tag == 10001) {
                        
                        [self removeFromSuperview];
                    }
                }
            }
        }
        if (giftModel.type==15) {
                NSMutableArray *sixArr = [NSMutableArray array];
                for (int i = 0; i< 5; i++) {
                    
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1314-%d.png",i]];
                    
                    [sixArr addObject:image];
                    
                }
            UIImageView *animationImageView = [[UIImageView alloc]init];
            [animationImageView setFrame:CGRectMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2 - 100, 150, 150)];
            animationImageView.animationImages = sixArr;//将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationDuration = 1.5;//设置动画时间
            animationImageView.animationRepeatCount = 2;//设置动画次数 0 表示无限
            [animationImageView startAnimating];//开始播放动画
            [self addSubview:animationImageView];
            [self performSelector:@selector(aimationOver:) withObject:animationImageView afterDelay:1.5];
            
        }
    });
}
-(void)aimationOver:(UIImageView *)imageView{
    [imageView removeFromSuperview];
}

// 添加一条礼物消息
-(void)addSendGiftMessage:(NSString *)username imageName:(NSString *)imgName{
    TCShowLiveMsg *model = [[TCShowLiveMsg alloc] initWith:_room.liveHost message:@""];
    model.isMsg = YES;
    model.sender = [IMAPlatform sharedInstance].host;
    NSString *message = [NSString stringWithFormat:@"      %@：送出了 ",username];
        UIFont *font = [UIFont systemFontOfSize:13];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:message];
        [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, username.length)];
        [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 138, 2, 1.0) range:NSMakeRange(0, username.length+1)];
        [attriString addAttribute:NSForegroundColorAttributeName value:kWhiteColor range:NSMakeRange(username.length+1, message.length - username.length-1)];
        [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(username.length+1, message.length - username.length-1)];
        if (imgName) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = [UIImage imageNamed:imgName];
            attach.bounds = CGRectMake(0, 0, 15, 10);
            NSAttributedString *AattachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attriString  appendAttributedString:AattachString];
        }
        model.avimMsgRichText = attriString;
        AVIMCMD *cmd = [[AVIMCMD alloc]initWith:AVIMCMD_GIFT];
        cmd.userAction = AVIMCMD_GIFT;
        model.avimMsgShowSize = CGSizeMake(165, 20);
        model.imageName = imgName;
        model.isSendGift = YES;
        [_msgView insertMsg:model];
}
- (void)registerKeyBoardNotification
{
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

#pragma mark - notification handler

#pragma mark -
#pragma mark Responding to keyboard events
- (void)onKeyboardDidShow:(NSNotification *)notification
{
    if ([_inputView isInputViewActive])
    {
        NSDictionary *userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat ky = keyboardRect.origin.y;
            
            CGRect rect = _bottomView.frame;
            rect = CGRectInset(rect, 0, 10);
            rect.origin.y = ky - rect.size.height - (keyboardRect.origin.y + keyboardRect.size.height - self.bounds.size.height);;
            _inputView.frame = rect;
            [_msgView scaleToAboveOf:_inputView margin:kDefaultMargin];
        }];
    }
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    if (![_inputView isInputViewActive])
    {
        NSDictionary* userInfo = [notification userInfo];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        
        [UIView animateWithDuration:animationDuration animations:^{
            [_inputView alignParentBottomWithMargin:10];
            [_msgView scaleToAboveOf:_bottomView margin:kDefaultMargin];
        }];
    }
}

- (void)startLive
{
    [_topView startLive];
}
- (void)pauseLive
{
    [_topView pauseLive];
}
- (void)resumeLive
{
    [_topView resumeLive];
}

- (void)onRecvPraise
{
    NSInteger praise = [_room livePraise];
    [_room setLivePraise:praise + 1];
    [_bottomView showLikeHeart];
    
#if kSupportIMMsgCache
#else
    [_topView onRefrshPraiseAndAudience];
#endif
}

#if kSupportIMMsgCache
- (void)onRecvPraise:(AVIMCache *)cache
{
    NSInteger praise = [_room livePraise];
    [_room setLivePraise:praise + cache.count];
    
    [_topView onRefrshPraiseAndAudience];
    
    [_bottomView showLikeHeart:cache];
}
#endif

- (void)setRoomEngine:(TCAVLiveRoomEngine *)roomEngine
{
    _roomEngine = roomEngine;
    [_topView onRefrshPARView:roomEngine];
    
    _bottomView.roomEngine = roomEngine;
}

- (void)addTopView
{
    _topView = [[TCShowLiveTopView alloc] initWith:_room];
    __weak typeof(self) weakself = self;
    _topView.userListClickBack = ^(TCLiveUserList *user) {
        [weakself showUserDeatilViewWithUser:user];
    };
    _topView.timeView.delegate = self;
    [self addSubview:_topView];
}


/**
 用户头像点击方法

 @param user <#user description#>
 */
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


- (void)addOwnViews
{
    
    _parTextView = [[UITextView alloc] init];
    _parTextView.hidden = YES;
    _parTextView.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.5];
    _parTextView.editable = NO;
    [self addSubview:_parTextView];
    
    [self addTopView];
    
    TCCharmShowLiveView *charmView = [[TCCharmShowLiveView alloc] initWithRoom:_room];
    __weak typeof(self) weakself = self;
    charmView.charmViewClickBlack = ^{

        if (weakself.charmViewClickBlock) {
            weakself.charmViewClickBlock();
        }
    };
    [self addSubview:charmView];
    
    
// 魅力值
    
    
    _msgView = [[TCShowLiveMessageView alloc] init];
    [self addSubview:_msgView];
    
    _bottomView = [[TCShowLiveBottomView alloc] init];
    _bottomView.delegate = self;
    _bottomView.manageUid = [_room liveHostId];
    [self addSubview:_bottomView];
    
    _inputView = [[TCShowLiveInputView alloc] init];
    _inputView.limitLength = 32;
    _inputView.hidden = YES;
    
    __weak TCShowLiveView *ws = self;
    [_inputView addSendAction:^(id selfptr) {
        [ws sendMessage];
    }];
    
    [self addSubview:_inputView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlank:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_msgView addGestureRecognizer:tap];
    
}

- (void)onTapBlank:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if ([_bottomView isPureMode] || _inputViewShowing)
        {
            return;
        }
        
        if ([_inputView isInputViewActive])
        {
            [_inputView resignFirstResponder];
        }
        else
        {
            if (!_inputView.hidden)
            {
                [self showActionPanel];
            }
        }
    }
}


- (void)showActionPanel
{
    if (_inputView.hidden)
    {
        return;
    }
    
    _inputView.text = nil;
    [_inputView resignFirstResponder];
    
#if kSupportFTAnimation
    [_inputView fadeOut:0.3 delegate:nil];
    [_bottomView fadeIn:0.3 delegate:nil];
#else
    _inputView.hidden = YES;
    _bottomView.hidden = NO;
#endif
    
}

- (void)hideInputView
{
    [self showActionPanel];
}


- (void)sendMessage
{
    
#if DEBUG
    if (_inputView.text.length == 0)
    {
        [[HUDHelper sharedInstance] tipMessage:@"内容不能为空"];
        return;
    }
    else
    {
        [_msgHandler sendMessage:_inputView.text];
    }
#else
    
    NSString *msg = [_inputView.text trim];
    if (msg.length == 0)
    {
        [[HUDHelper sharedInstance] tipMessage:@"内容不能为空"];
        return;
    }
    
    [_msgHandler sendMessage:_inputView.text];
    [_inputView resignFirstResponder];
    [self showActionPanel];
#endif
    
}
- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    [_topView setFrameAndLayout:CGRectMake(0, 0, rect.size.width, 110)];
    
    [_bottomView sizeWith:CGSizeMake(rect.size.width, 60)];
    [_bottomView alignParentBottomWithMargin:0];
    [_bottomView relayoutFrameOfSubViews];
    
    [_inputView sameWith:_bottomView];
    [_inputView shrinkVertical:10];
    [_inputView relayoutFrameOfSubViews];
    
    [_msgView sizeWith:CGSizeMake((NSInteger)(rect.size.width * 0.8), 210)];
    [_msgView layoutBelow:_topView margin:kDefaultMargin];
    [_msgView scaleToAboveOf:_bottomView margin:kDefaultMargin];
    [_msgView relayoutFrameOfSubViews];
    
    [_parTextView sameWith:_topView];
    [_parTextView layoutBelow:_topView margin:kDefaultMargin];
    [_parTextView scaleToAboveOf:_bottomView margin:kDefaultMargin];
    
}


- (void)setMsgHandler:(AVIMMsgHandler *)msgHandler
{
    if (_msgHandler != msgHandler) {
        _msgHandler = msgHandler;
        msgHandler.RecvGiftBlock= ^(NSArray *array){
            
            PresentType type = (PresentType)[array[4] integerValue];
            GiftModel * model = [[GiftModel alloc]init];
            Gift * gg =  [AllGifts AllGifts][type];
            model.headImage = [NSString stringWithFormat:@"%@",array[3]];
            model.senderChatID = [NSString stringWithFormat:@"%@",array[0]];
            model.giftImage = [UIImage imageNamed:gg.imageName];
            model.giftCount = [NSString stringWithFormat:@"%ld",(long)[array[5] integerValue]];
            model.type = type;
            model.name = [NSString stringWithFormat:@"%@",array[2]];
            [self addSendGiftMessage:model.name imageName:gg.imageName];
            [self sendGiftWithGiftModel:model];
            [self sendPresent:type num:[array[5] integerValue] userName:array[2] userLogo:array[3]];
        };
        if (msgHandler != nil) {
            [self getSystemInforms];
        }
        
    }
    
//    _topView.imSender = (TCShowAVIMHandler *)msgHandler;
}

- (void)getSystemInforms {
    [[Business sharedInstance] getLiveNoticeWithParam:nil succ:^(NSString *msg, id data) {
        NSArray *arr = data;
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dict = arr[i];
            NSString *content = dict[@"notice_content"];
            NSString *name = dict[@"notice_name"];
            [self addSystemInformsWithMessage:[NSString stringWithFormat:@"%@：%@", name, content]];
        }
    } fail:^(NSString *error) {
        
    }];
}

/**
 直播消息，系统通知

 @param message 发过来的系统通知
 */
- (void)addSystemInformsWithMessage:(NSString *)message {
    TCShowLiveMsg *model = [[TCShowLiveMsg alloc] initWith:_room.liveHost message:@""];
    model.isMsg = YES;
    model.sender = [IMAPlatform sharedInstance].host;
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:message];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, message.length)];
    [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 138, 2, 1.0) range:NSMakeRange(0, 5)];
    [attriString addAttribute:NSForegroundColorAttributeName value:kWhiteColor range:NSMakeRange(5, message.length - 5)];
    model.avimMsgRichText = attriString;
    AVIMCMD *cmd = [[AVIMCMD alloc]initWith:AVIMCMD_GIFT];
    cmd.userAction = AVIMCMD_Text;
    CGSize contentSize = [attriString boundingRectWithSize:CGSizeMake(165, HUGE_VALF) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    model.avimMsgShowSize = contentSize;
    [_msgView insertMsg:model];
}


- (void)onBottomViewSwitchToPureMode:(TCShowLiveBottomView *)bottomView
{
#if kSupportFTAnimation
    if (_inputView && !_inputView.hidden)
    {
        if (_inputView.isInputViewActive)
        {
            [_inputView resignFirstResponder];
        }
        
        [_inputView slideOutTo:kFTAnimationBottom duration:0.25 delegate:nil];
        
    }
    _isPureMode = YES;
    [_topView slideOutTo:kFTAnimationTop duration:0.25 delegate:nil];
    [_msgView changeToMode:YES];
    _msgHandler.isPureMode = YES;
    [_msgView slideOutTo:kFTAnimationLeft duration:0.25 delegate:nil];
#else
    
    if (_inputView && !_inputView.hidden)
    {
        if (_inputView.isInputViewActive)
        {
            [_inputView resignFirstResponder];
        }
        
        _inputView.hidden = YES;
        
    }
    _isPureMode = YES;
    _topView.hidden = YES;
    [_msgView changeToMode:YES];
    _msgHandler.isPureMode = YES;
    _msgView.hidden = YES;
    
#endif
}
- (void)onBottomViewSwitchToNonPureMode:(TCShowLiveBottomView *)bottomView
{
#if kSupportFTAnimation
    _isPureMode = NO;
    [_topView slideInFrom:kFTAnimationTop duration:0.25 delegate:nil];
    [_msgView changeToMode:NO];
    _msgHandler.isPureMode = NO;
    [_msgView slideInFrom:kFTAnimationLeft duration:0.25 delegate:nil];
#else
    _isPureMode = NO;
    _topView.hidden = NO;
    [_msgView changeToMode:NO];
    _msgHandler.isPureMode = NO;
    _msgView.hidden = NO;
    
#endif
    
}

- (void)onBottomViewSwitchToMessage:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button
{
    if (_inputViewShowing)
    {
        return;
    }
    _inputViewShowing = YES;
    
#if kSupportFTAnimation
    
    [self animation:^(id selfPtr) {
        [_inputView becomeFirstResponder];
        [_bottomView fadeOut:0.25 delegate:nil];
        [_inputView fadeIn:0.25 delegate:nil];
    } duration:1 completion:^(id selfPtr) {
        button.enabled = YES;
        _inputViewShowing = NO;
    }];
#else
    [_inputView becomeFirstResponder];
    _bottomView.hidden = YES;
    _inputView.hidden = YES;
    button.enabled = YES;
    _inputViewShowing = NO;
#endif
}

- (void)onBottomViewSendPraise:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button
{
    [_msgHandler sendLikeMessage];
    [_bottomView showLikeHeart];
    
    [_room setLivePraise:[_room livePraise] + 1];
    [_topView onRefrshPraiseAndAudience];
    
}

- (void)onTimViewTimeRefresh:(TCShowLiveTimeView *)topView
{
    [self onRefreshPAR];
}

- (void)onRefreshPAR
{
    if (!_parTextView.hidden)
    {
        NSString *log = [_roomEngine engineLog];
        if (log)
        {
            _parTextView.text = log;
        }
    }
}
- (void)showPar:(UIButton *)par
{
    if ([_roomEngine isCameraEnable])
    {
        par.selected = !par.selected;
        _parTextView.hidden = !par.selected;
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"PAR需要在相机打开情况下才有效"];
    }
}


- (void)onClickSub:(id<AVMultiUserAble>)user
{
    [self.bottomView switchToShowMultiInteract:user isMain:YES];
}
- (void)changeRoomInfo:(id<TCShowLiveRoomAble>)room
{
    _room = room;
    [_topView changeRoomInfo:room];
    
}

- (void)onUserLeave:(NSArray *)users
{
    // 直播场景下，不做处理
}
- (void)onUserBack:(NSArray *)user
{
    // 直播场景下，不做处理
}

@end
