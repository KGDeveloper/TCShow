//
//  TCShowMultiLiveViewController.m
//  TCShow
//
//  Created by AlexiChen on 16/4/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#if kSupportMultiLive
#import "TCShowMultiLiveViewController.h"
#import "NHCarView.h"
#import "RechargeViewController.h"
#import "TCCharmShowViewController.h"
#import <UShareUI/UShareUI.h>
#import "TCLiveUserList.h"
#import "LemonPurseViewController.h"
@interface TCShowMultiUserListViewCell : UITableViewCell

@end

@implementation TCShowMultiUserListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageView.layer.cornerRadius = 20;
        self.imageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView sizeWith:CGSizeMake(40, 40)];
    [self.imageView layoutParentVerticalCenter];
    [self.imageView alignParentLeftWithMargin:kDefaultMargin];
}

@end


@implementation TCShowMultiUserListView

- (instancetype)initWith:(NSArray *)array
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _userList = array;
        [self addOwnViews];
        [self configOwnViews];
    }
    return self;
}

- (void)addOwnViews
{
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
    [_backView setClipsToBounds:YES];
    [self addSubview:_backView];
    
    _tipLabel = [[InsetLabel alloc] init];
    _tipLabel.contentInset = UIEdgeInsetsMake(0, kDefaultMargin, 0, kDefaultMargin);
    _tipLabel.backgroundColor = kWhiteColor;
    NSString *tip = @"邀请互动连线";
    NSString *t = [NSString stringWithFormat:@"%@(最多可与三个观众进行互动直播)", tip];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:t];
    
    [text addAttribute:NSFontAttributeName value:kAppMiddleTextFont range:NSMakeRange(0, tip.length)];
    [text addAttribute:NSForegroundColorAttributeName value:kBlackColor range:NSMakeRange(0, tip.length)];
    [text addAttribute:NSFontAttributeName value:kAppMiddleTextFont range:NSMakeRange(tip.length, t.length - tip.length)];
    [text addAttribute:NSForegroundColorAttributeName value:kGrayColor range:NSMakeRange(tip.length, t.length - tip.length)];
    _tipLabel.attributedText = text;
    [self addSubview:_tipLabel];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBack:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_backView addGestureRecognizer:tap];
}

- (void)show
{
#if kSupportFTAnimation
    [self animation:^(id selfPtr) {
        [_tipLabel slideInFrom:kFTAnimationTop duration:0.25 delegate:nil];
        [_tableView slideInFrom:kFTAnimationTop duration:0.25 delegate:nil];
        [_backView fadeIn:0.25 delegate:nil];
    } duration:0.3 completion:nil];
#else
    _tipLabel.hidden = NO;
    _tableView.hidden = NO;
    _backView.hidden = NO;
#endif
}

- (void)onTapBack:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self hide];
    }
}

- (void)hide
{
#if kSupportFTAnimation
    [self animation:^(id selfPtr) {
        [_tipLabel slideOutTo:kFTAnimationTop duration:0.25 delegate:nil];
        [_tableView slideOutTo:kFTAnimationTop duration:0.25 delegate:nil];
        [_backView fadeOut:0.25 delegate:nil];
    } duration:0.3 completion:^(id selfPtr) {
        [self removeFromSuperview];
    }];
#else
    [self removeFromSuperview];
#endif
}

- (void)relayoutFrameOfSubViews
{
    _backView.frame = self.bounds;
    
    [_tipLabel sizeWith:CGSizeMake(self.bounds.size.width, 40)];
    
    NSInteger rows = _userList.count > 7 ? 7 : _userList.count;
    [_tableView sizeWith:CGSizeMake(self.bounds.size.width, rows * kDefaultCellHeight)];
    [_tableView layoutBelow:_tipLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultiUserCell"];
    if (!cell)
    {
        cell = [[TCShowMultiUserListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MultiUserCell"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 20)];
        
        btn.tag = 1000 + indexPath.row;
        [btn addTarget:self action:@selector(onClickConnect:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    
    id<AVMultiUserAble> iu = _userList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[iu imUserIconUrl]] placeholderImage:kDefaultUserIcon];
    cell.textLabel.text = [iu imUserName];
    UIButton *btn = (UIButton *)cell.accessoryView;
    BOOL conn = [_delegate onUserListView:self isInteratcUser:iu];
    if (conn)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"disconnect"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"connection"] forState:UIControlStateNormal];
    }
    return cell;
}

- (void)onClickConnect:(UIButton *)btn
{
    NSInteger idx = btn.tag - 1000;
    id<AVMultiUserAble> user = _userList[idx];
    if ([_delegate respondsToSelector:@selector(onUserListView:clickUser:)])
    {
        [_delegate onUserListView:self clickUser:user];
    }
    
    [self hide];
}



@end

//============================================================================================================

@implementation TCShowMultiUILiveViewController

static __weak UIAlertView *kInteractAlert = nil;
static BOOL kRectHostCancelInteract = NO;

- (void)dealloc {
    
    _liveView = nil;
}

- (void)addOwnViews
{
    id<AVRoomAble> room = [_liveController roomInfo];
    TCShowMultiLiveView *liveView = [[TCShowMultiLiveView alloc] initWith:(id<TCShowLiveRoomAble>)room];
    liveView.topView.delegate = self;
    liveView.multiView.delegate = self;
    liveView.bottomView.multiDelegate = self;
    [self.view addSubview:liveView];
    _liveView = liveView;
     _liveView.delegate = self;
    __weak typeof(self) weakself = self;
    _liveView.charmViewClickBlock = ^{
        TCCharmShowViewController *charmVC = [[TCCharmShowViewController alloc] init];
        charmVC.uid = [room liveHostId];
        [weakself.navigationController pushViewController:charmVC animated:YES];
    };
    _liveView.shareViewClickBlock = ^{
        [weakself onSwitchShare];
    };
    _liveView.sendMsgBtnClickBlock = ^(TCLiveUserList *user) {
        [weakself sendmessagePush:user];
    };
    [kInteractAlert dismissWithClickedButtonIndex:0 animated:YES];
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage *image = [UIImage imageNamed:@"shareIcon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"柠檬秀" descr:@"大家好,我正在直播哦!喜欢我的朋友赶紧来哦" thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =@"https://www.pgyer.com/Lmmh";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
        }else{
        }
    }];
}


-(void)showVVCC
{
    
    LemonPurseViewController *purseVc = [[LemonPurseViewController alloc] init];
    [self.navigationController pushViewController:purseVc animated:YES];
    
}
- (void)sendPresent:(TCShowLiveView *)showLiveView type:(Gift *)type num:(NSUInteger)num
{
    // 这里应该是先调送礼物接口，成功后再走下面的逻辑
    NSString *Str = type.name;
    NSRange strRang = [type.name rangeOfString:@"钻石"];
    NSString *moneyStr = [Str substringToIndex:strRang.location];
    
    [[Business sharedInstance] giftGiving:[[_roomEngine getRoomInfo] liveHostId] amount:moneyStr succ:^(NSString *msg, id data) {
        NSInteger code = [data integerValue];
        if (code == 0) { // 成功
            if (type.type == 4) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[SARUserInfo nickName] forKey:@"user_nickname"];
                [dic setValue:type.name forKey:@"gift"];
                [dic setValue:[NSString stringWithFormat:@"%d",[_roomEngine getRoomInfo].liveAVRoomId] forKey:@"av_room_id"];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:LIVE_GIGT_PP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
            [[HUDHelper sharedInstance]loading:@"送礼成功" delay:1 execute:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendGiftSucc" object:nil];
            } completion:^{
                
            }]; 
            [self IMSendPresent:type.type num:num];
        }else if (code == -3) { // 余额不足
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，充值才能继续送礼，请先充值" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }else{
            ALERT(msg);
        }
    } fail:^(NSString *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
    
}
//-(void)showGitWithArray:(NSArray *)array
//{
//    PresentType type = (PresentType)[array[4] integerValue];
//    GiftModel * model = [[GiftModel alloc]init];
//    Gift * gg =  [AllGifts AllGifts][type];
//    model.headImage = [NSString stringWithFormat:@"%@",array[3]];
//    model.senderChatID = [NSString stringWithFormat:@"%@",array[0]];
//    model.giftImage = [UIImage imageNamed:gg.imageName];
//    model.giftCount = [NSString stringWithFormat:@"%ld",(long)[array[5] integerValue]];
//
//    model.type = type;
//    model.name = [NSString stringWithFormat:@"%@",array[2]];
//    [_liveView sendGiftWithGiftModel:model];
//}

- (void)IMSendPresent:(NSInteger)type num:(NSUInteger)num {
    NSString* sendMessage = [NSString stringWithFormat:
                             MSG_SENDPRESENT,
                             [IMAPlatform sharedInstance].host.imUserId,
                             (int)MSG_CMD_SENDPRESENT,
                             [IMAPlatform sharedInstance].host.profile.nickname,
                             [IMAPlatform sharedInstance].host.profile.imUserIconUrl,
                             (int)type,
                             (int)num];
    TIMCustomElem* praiseElem = [[TIMCustomElem alloc] init];
    praiseElem.data = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    TIMMessage* timMsg = [[TIMMessage alloc] init];
    [timMsg addElem:praiseElem];
    
    TIMConversation *con = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:[[_roomEngine getRoomInfo] liveIMChatRoomId]];
    [con sendMessage:timMsg succ:^(){
        GiftModel * model = [[GiftModel alloc]init];
        Gift * gg =  [AllGifts AllGifts][type];
        model.headImage = [SARUserInfo headUrl];
        model.senderChatID = [SARUserInfo userPhone];
        model.giftImage = [UIImage imageNamed:gg.imageName];
        model.name = [SARUserInfo nickName];
        model.giftCount = num;
        model.type = type;
        [_liveView sendGiftWithGiftModel:model];
        [_liveView addSendGiftMessage:model.name imageName:gg.imageName];
#pragma mark --------------------从这里开始是我添加的送礼物的时候飘萍的代码-------------------------
//        //从这里开始是我添加的送礼物的时候飘萍的代码
//        if (type == 4 % type == 5 % type == 6 % type == 7 % type == 12 % type == 13 % type == 14 % type == 15) {
//            GCZPresentView *presentView_;
//            NSMutableDictionary *request = [NSMutableDictionary dictionary];
//            [request setValue:[presentView_ nameWithType:type] forKey:@"gift"];
//            [request setValue:[SARUserInfo nickName] forKey:@"user_nickname"];
//            [request setValue:[NSString stringWithFormat:@"%d",[_roomEngine getRoomInfo].liveAVRoomId] forKey:@"av_room_id"];
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager POST:LIVE_GIGT_PP parameters:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            }];
//        }
        //到这里结束
    }fail:^(int code, NSString* err){
    }];
}
- (void)onTapMultiLiveViewBlankToShowMainFunc:(TCShowMultiLiveView *)view
{
    TCShowMultiLiveViewController *con = (TCShowMultiLiveViewController *)_liveController;
    id<AVMultiUserAble> user = [con.multiManager mainUser];
    [_liveView.bottomView switchToShowMultiInteract:user isMain:YES];
}


- (void)onUserListView:(TCShowMultiUserListView *)view clickUser:(id<AVMultiUserAble>)user
{
    // TODO: 检查是否是互动观众，如果不是，发送邀请，是的话断开
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    if ([controller.multiManager isInteractUser:user])
    {
        [controller.multiManager initiativeCancelInteractUser:user];
    }
    else
    {
        [controller.multiManager inviteUserJoinInteraction:user];
    }
}

- (BOOL)onUserListView:(TCShowMultiUserListView *)view isInteratcUser:(id<AVMultiUserAble>)user
{
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    return [controller.multiManager isInteractUser:user];
}



- (void)onRecvHostInteract:(AVIMCMD *)msg
{
    id<IMUserAble> sender = [msg sender];
    
    __weak TCShowMultiUILiveViewController *ws = self;
    __weak MultiAVIMMsgHandler *wm = (MultiAVIMMsgHandler *)_msgHandler;
    NSString *text = [NSString stringWithFormat:@"主播(%@)邀请您参加TA的互动直播", [sender imUserName]];
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"互动直播邀请" message:text cancelButtonTitle:@"拒绝" otherButtonTitles:@[@"同意"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0)
        {
            if (!kRectHostCancelInteract)
            {
                //  拒绝
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
            }
            
        }
        else if (buttonIndex == 1)
        {
            if (!kRectHostCancelInteract)
            {
                [ws onRecvHostInteractChangeAuthAndRole:sender];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            kInteractAlert = nil;
            kRectHostCancelInteract = NO;
        });
    }];
    alert.tag = 2000;
    [alert show];
    kInteractAlert = alert;
}

- (void)onRecvHostInteractChangeAuthAndRole:(id<IMUserAble>)sender
{
    // 本地先修改权限
    //  controller.multiManager ;
    // 然后修改role
    // 再打开相机
    __weak TCShowMultiUILiveViewController *ws = self;
    __weak MultiAVIMMsgHandler *wm = (MultiAVIMMsgHandler *)_msgHandler;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    
    // 检查本地硬件(Mic与相机权限)
    [controller checkPermission:^{
        // 本地没有权限，回复拒绝
        [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
    } permissed:^{
        // 有权限
        [controller.multiManager changeToInteractAuthAndRole:^(TCAVMultiLiveRoomEngine *engine, BOOL isFinished) {
            if (isFinished)
            {
                // 同意
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Join to:sender succ:^{
                    // 进行连麦操作
                    [ws showSelfVideoToOther];
                } fail:^(int code, NSString *msg) {
                    [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
                }];
            }
            else
            {
                [wm sendC2CAction:AVIMCMD_Multi_Interact_Refuse to:sender succ:nil fail:nil];
            }
        }];
    }];
}

- (void)onRecvHostCancelInteract
{
    if (kInteractAlert)
    {
        kRectHostCancelInteract = YES;
        [kInteractAlert dismissWithClickedButtonIndex:0 animated:YES];
        [[HUDHelper sharedInstance] tipMessage:@"主播已取消与您的互动"];
    }
    
    // 如果当前已显示，则关掉
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager forcedCancelInteractUser:(id<AVMultiUserAble>)controller.currentUser];
}


- (void)showSelfVideoToOther
{
    // 本地自己开
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager registSelfOnRecvInteractRequest];
}



- (void)onRecvCancelInteract:(AVIMCMD *)msg
{
    if (kInteractAlert)
    {
        kRectHostCancelInteract = YES;
        [kInteractAlert dismissWithClickedButtonIndex:0 animated:YES];
        [[HUDHelper sharedInstance] tipMessage:@"主播已取消与您的互动"];
        return;
    }
    
    NSString *operUserId = [msg actionParam];
    
    TCAVMultiLiveViewController *mvc = (TCAVMultiLiveViewController *)_liveController;
    TCAVIMMIManager *mgr = mvc.multiManager;
    
    id<AVMultiUserAble> user = [mgr interactUserOfID:operUserId];
    
    if ([mgr isMainUserByID:operUserId])
    {
        // 主屏用户时，检查是显示leave界面
        [mvc.livePreview hiddenLeaveView];
    }
    
    if (user)
    {
        [mgr forcedCancelInteractUser:user];
    }
    
    //    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    //
    //    // 关闭自己的摄像头与Mic，speaker
    //    [re asyncEnableCamera:NO needNotify:NO];
    //    [re asyncEnableMic:NO completion:nil];
    //    [re asyncEnableSpeaker:YES completion:nil];
    
}


- (void)onRecvReplyInteractJoin:(AVIMCMD *)msg
{
    id<IMUserAble> sender = msg.sender;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager requestViewOf:(id<AVMultiUserAble>)sender];
    
    id<AVMultiUserAble> auser = [controller.multiManager interactUserOf:sender];
    [auser setAvCtrlState:EAVCtrlState_All];
}

- (void)onRecvReplyInteractJoinRequestView:(BOOL)succ ofSender:(id<IMUserAble>)sender
{
    TCShowMultiView *multiView = [(TCShowMultiLiveView *)_liveView multiView];
    [multiView onRequestViewOf:(id<AVMultiUserAble>)sender complete:YES];
    if (succ)
    {
        TCAVMultiLiveViewController *lvc = (TCAVMultiLiveViewController *)_liveController;
        
        id<AVMultiUserAble> auser = [lvc.multiManager interactUserOf:sender];
        [auser setAvCtrlState:EAVCtrlState_All];
        
        TCShowMultiSubView *subView = [multiView overlayOf:auser];
        
        // 后期作互动窗口切换使用
        [auser setAvInvisibleInteractView:subView];
        
        // 相对于全屏的位置
        CGRect rect = [subView relativePositionTo:[UIApplication sharedApplication].keyWindow];
        [auser setAvInteractArea:rect];
        
        [lvc addRenderInPreview:auser];
    }
    
}


- (void)onRecvHasCameraThenRequestView:(BOOL)succ ofSenders:(NSArray *)senders
{
    for (id<AVMultiUserAble> sender in senders)
    {
        [self onRecvReplyInteractJoinRequestView:succ ofSender:sender];
    }
}


- (void)onRecvReplyInteractRefuse:(AVIMCMD *)msg
{
    // 移除画面
    // 取消请求
    id<AVMultiUserAble> sender = (id<AVMultiUserAble>)msg.sender;
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager forcedCancelInteractUser:sender];
    
}


- (void)onRecvHostEnableMic:(AVIMCMD *)msg
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    
    [re asyncEnableMic:YES completion:nil];
}

- (void)onRecvHostDisableMic:(AVIMCMD *)msg
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    [re asyncEnableMic:NO completion:nil];
}

- (void)onRecvHostEnableCamera:(AVIMCMD *)msg
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    [re asyncEnableCamera:YES needNotify:NO];
}

- (void)onRecvHostDisableCamera:(AVIMCMD *)msg
{
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    [re asyncEnableCamera:NO needNotify:NO];
}

- (void)onRecvHostControlMic:(AVIMCMD *)msg
{
    // 收到主播控制Mic操作
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    __weak TCShowLiveBottomView *wb = _liveView.bottomView;
    [re asyncSwitchEnableMicCompletion:^(BOOL succ, NSString *tip) {
        // 更新底部显示
        [wb updateShowFunc];
    }];
}

- (void)onRecvHostControlCamera:(AVIMCMD *)msg
{
    // 收到播开头摄像头操作
    TCAVLiveRoomEngine *re = (TCAVLiveRoomEngine *)_roomEngine;
    __weak TCShowLiveBottomView *wb = _liveView.bottomView;
    [re asyncSwitchEnableCameraCompletion:^(BOOL succ, NSString *tip) {
        // 更新底部显示
        [wb updateShowFunc];
    }];
}


- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomGroupMultiMsg:(AVIMCMD *)msg
{
    NSInteger type = [msg msgType];
    switch (type)
    {
        case AVIMCMD_Multi_CancelInteract:
        {
            [self onRecvCancelInteract:msg];
        }
            break;
        default:
            break;
    }
}

- (void)onRecvCustomLeave:(id<AVIMMsgAble>)msg
{
    AVIMCMD *cmd = (AVIMCMD *)msg;
    TCAVMultiLiveViewController *lvc = (TCAVMultiLiveViewController *)_liveController;
    
    id<IMUserAble> sender = [cmd sender];
    NSArray *array = @[sender];
    
    if ([[lvc.multiManager.mainUser imUserId] isEqualToString:[sender imUserId]])
    {
        [lvc.livePreview onUserLeave:lvc.multiManager.mainUser];
    }
    [_liveView onUserLeave:array];
    
}

- (void)onRecvCustomBack:(id<AVIMMsgAble>)msg
{
    AVIMCMD *cmd = (AVIMCMD *)msg;
    TCAVMultiLiveViewController *lvc = (TCAVMultiLiveViewController *)_liveController;
    
    id<IMUserAble> sender = [cmd sender];
    NSArray *array = @[[cmd sender]];
    
    if ([[lvc.multiManager.mainUser imUserId] isEqualToString:[sender imUserId]])
    {
        [lvc.livePreview onUserBack:lvc.multiManager.mainUser];
    }
    [_liveView onUserBack:array];
    
    [lvc.multiManager requestMultipleViewOf:array];
}

- (void)onIMHandler:(AVIMMsgHandler *)receiver recvCustomC2CMultiMsg:(AVIMCMD *)msg
{
    NSInteger type = [msg msgType];
    switch (type)
    {
        case AVIMCMD_Multi_Host_Invite:
        {
            // 收到主播邀请消息
            [self onRecvHostInteract:msg];
        }
            break;
            //        case AVIMCMD_Multi_CancelInteract:
            //        {
            //            [self onRecvHostCancelInteract:msg];
            //        }
            //            break;
        case AVIMCMD_Multi_Interact_Join:
        {
            [self onRecvReplyInteractJoin:msg];
        }
            break;
        case AVIMCMD_Multi_Interact_Refuse:
        {
            [self onRecvReplyInteractRefuse:msg];
        }
            break;
        case AVIMCMD_Multi_Host_EnableInteractMic:
        {
            [self onRecvHostEnableMic:msg];
        }
            break;
        case AVIMCMD_Multi_Host_DisableInteractMic:
        {
            [self onRecvHostDisableMic:msg];
        }
            break;
        case AVIMCMD_Multi_Host_EnableInteractCamera:
        {
            [self onRecvHostEnableCamera:msg];
        }
            break;
        case AVIMCMD_Multi_Host_DisableInteractCamera:
        {
            [self onRecvHostDisableCamera:msg];
        }
            break;
        case AVIMCMD_Multi_Host_CancelInvite:
        {
            [self onRecvCancelInteract:msg];
        }
            break;
        case AVIMCMD_Multi_Host_ControlCamera:
        {
            [self onRecvHostControlCamera:msg];
        }
            break;
        case AVIMCMD_Multi_Host_ControlMic:
        {
            [self onRecvHostControlMic:msg];
        }
            break;
            
        default:
            break;
    }
}

- (void)assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    TCShowMultiView *multiView = [(TCShowMultiLiveView *)_liveView multiView];
    
    if (inviteOrAuto)
    {
        [multiView inviteInteractWith:user];
    }
    else
    {
        [multiView addWindowFor:user];
    }
    
    TCShowMultiSubView *subView = [multiView overlayOf:user];
    
    // 后期作互动窗口切换使用
    [user setAvInvisibleInteractView:subView];
    
    // 相对于全屏的位置
    CGRect rect = [subView relativePositionTo:[UIApplication sharedApplication].keyWindow];
    [user setAvInteractArea:rect];
}
- (void)recycleWindowResourceTo:(id<AVMultiUserAble>)user
{
    TCShowMultiView *multiView = [(TCShowMultiLiveView *)_liveView multiView];
    TCAVIMMIManager *mgr = [((TCAVMultiLiveViewController *)_liveController) multiManager];
    [multiView cancelInteractWith:user];
    
    [_liveView.bottomView switchToShowMultiInteract:mgr.mainUser isMain:YES];
    
    // 更新渲染小窗口的位置
}

- (void)requestViewOf:(id<AVMultiUserAble>)user
{
    TCShowMultiView *multiView = [(TCShowMultiLiveView *)_liveView multiView];
    [multiView requestViewOf:user];
}

- (void)updateUserCtrlState:(id<AVMultiUserAble>)user
{
    TCShowLiveBottomView *wb = _liveView.bottomView;
    [wb updateShowFunc];
    
}

- (void)onRequestViewCompleted:(BOOL)succ
{
    TCAVIMMIManager *mgr = [((TCAVMultiLiveViewController *)_liveController) multiManager];
    TCShowMultiView *multiView = [(TCShowMultiLiveView *)_liveView multiView];
    for (id<AVMultiUserAble> user in mgr.multiResource)
    {
        // 因为QAVEndpoint requestViewList请求的时候并不能知道具体哪个的画面不会到，建议此不要用succ作参考
        // 底层无法知道
        [multiView onRequestViewOf:user complete:YES];
    }
}


- (void)onTopViewClickInteract:(TCShowLiveTopView *)topView
{
    __weak TCShowMultiUILiveViewController *ws = self;
    [(MultiAVIMMsgHandler *)_msgHandler syncRoomOnlineUser:32 members:^(NSArray *members) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws showInteractUserView:members];
        });
    } fail:nil];
    
}

- (void)showInteractUserView:(NSArray *)members
{
    if (members.count)
    {
        TCShowMultiUserListView *userView = [[TCShowMultiUserListView alloc] initWith:members];
        userView.delegate = self;
        [self.view addSubview:userView];
        [userView setFrameAndLayout:self.view.bounds];
        [userView show];
    }
}


- (void)onMultiView:(TCShowMultiView *)render inviteTimeOut:(id<AVMultiUserAble>)user
{
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager initiativeCancelInviteUser:user];
}

- (void)onMultiView:(TCShowMultiView *)render clickSub:(id<AVMultiUserAble>)user
{
    //    [_liveView.bottomView switchToShowMultiInteract:user isMain:NO];
    
    __weak TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    
    __weak TCShowMultiView *wm = [(TCShowMultiLiveView *)_liveView multiView];
    __weak TCShowLiveView *wl = _liveView;
    
    // 切换前主屏是否离开
    BOOL isMainLeaveBeforeSwitch = [controller.livePreview isRenderUserLeave];
    BOOL isClickLeave = [[render overlayOf:user] isUserLeave];
    
    [controller switchToMainInPreview:user completion:^(BOOL succ, NSString *tip) {
        if (succ)
        {
            // 交换TCShowMultiView上的资源信息
            id<AVMultiUserAble> main = [controller.multiManager mainUser];
            [wm replaceViewOf:user with:main];
            
            if (isMainLeaveBeforeSwitch && main)
            {
                [wl onUserLeave:@[main]];
            }
            else
            {
                [wl onUserBack:@[main]];
            }
            
            if (isClickLeave)
            {
                [controller.livePreview onUserLeave:user];
            }
            else
            {
                [controller.livePreview onUserBack:user];
            }
            
            [wl onClickSub:user];
        }
    }];
    
}

- (void)onMultiView:(TCShowMultiView *)render hangUp:(id<AVMultiUserAble>)user
{
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    [controller.multiManager initiativeCancelInviteUser:user];
    
}


- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateCameraOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button
{
    //    NSInteger cmd = button.selected ? AVIMCMD_Multi_Host_DisableInteractCamera : AVIMCMD_Multi_Host_EnableInteractCamera;
    NSInteger cmd = AVIMCMD_Multi_Host_ControlCamera;
    [(MultiAVIMMsgHandler *)_msgHandler sendC2CAction:cmd to:user succ:^{
        button.selected = !button.selected;
        
        NSInteger curState = [user avCtrlState];
        if (button.selected)
        {
            curState = curState | EAVCtrlState_Camera;
        }
        else
        {
            curState = curState & ~EAVCtrlState_Camera;
        }
        
        [user setAvCtrlState:curState];
        
    } fail:nil];
}

- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateMicOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button
{
    //    NSInteger cmd = button.selected ? AVIMCMD_Multi_Host_DisableInteractMic : AVIMCMD_Multi_Host_EnableInteractMic;
    NSInteger cmd = AVIMCMD_Multi_Host_ControlMic;
    [(MultiAVIMMsgHandler *)_msgHandler sendC2CAction:cmd to:user succ:^{
        
        button.selected = !button.selected;
        
        NSInteger curState = [user avCtrlState];
        if (button.selected)
        {
            curState = curState | EAVCtrlState_Mic;
        }
        else
        {
            curState = curState & ~EAVCtrlState_Mic;
        }
        
        [user setAvCtrlState:curState];
        
    } fail:nil];
}
- (void)onBottomView:(TCShowLiveBottomView *)bottomView switchToMain:(id<AVMultiUserAble>)user fromButton:(UIButton *)button
{
    __weak TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
    
    __weak TCShowMultiView *wm = [(TCShowMultiLiveView *)_liveView multiView];
    [controller switchToMainInPreview:user completion:^(BOOL succ, NSString *tip) {
        if (succ)
        {
            // 交换TCShowMultiView上的资源信息
            id<AVMultiUserAble> main = [controller.multiManager mainUser];
            [wm replaceViewOf:user with:main];
            
        }
    }];
}

- (void)onBottomView:(TCShowLiveBottomView *)bottomView cancelInteractWith:(id<AVMultiUserAble>)user fromButton:(UIButton *)button
{
    TCAVMultiLiveViewController *controller = (TCAVMultiLiveViewController *)_liveController;
     BOOL isClickLeave = [controller.livePreview isRenderUserLeave];
    if (isClickLeave)
    {
        [controller.livePreview onUserBack:user];
    }
    
    [controller.multiManager initiativeCancelInteractUser:user];
    
}


@end


@implementation TCShowMultiLiveViewController

- (void)dealloc {
    _liveView = nil;
    
}

- (void)createRoomEngine
{
    if (!_roomEngine)
    {
        id<AVUserAble> ah = (id<AVUserAble>)_currentUser;
        [ah setAvCtrlState:[self defaultAVHostConfig]];
        _roomEngine = [[TCShowMultiLiveRoomEngine alloc] initWith:(id<IMHostAble, AVUserAble>)_currentUser enableChat:_enableIM];
        _roomEngine.delegate = self;
        
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

- (void)prepareIMMsgHandler
{
    if (!_msgHandler)
    {
        _msgHandler = [[TCShowAVIMMultiHandler alloc] initWith:_roomInfo];
        _liveView.msgHandler = (TCShowAVIMHandler *)_msgHandler;
        _multiManager.msgHandler = (MultiAVIMMsgHandler *)_msgHandler;
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

- (void)addLiveView
{
    // 子类重写
    TCShowMultiUILiveViewController *uivc = [[TCShowMultiUILiveViewController alloc] initWith:self];
    [self addChild:uivc inRect:self.view.bounds];
    
    _liveView = uivc;
}


//====================================================

// 外部分配user窗口位置，此处可在界面显示相应的小窗口
- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr assignWindowResourceTo:(id<AVMultiUserAble>)user isInvite:(BOOL)inviteOrAuto
{
    [(TCShowMultiUILiveViewController *)_liveView assignWindowResourceTo:user isInvite:inviteOrAuto];
}

- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr requestViewComplete:(BOOL)succ
{
    // 去掉界面上的显示请求画面显示
    [(TCShowMultiUILiveViewController *)_liveView onRequestViewCompleted:succ];
}

// 外部回收user窗口资源信息
- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr recycleWindowResourceOf:(id<AVMultiUserAble>)user
{
    // 回收交互小窗口信息
    [(TCShowMultiUILiveViewController *)_liveView recycleWindowResourceTo:user];
    
    // 更新渲染层信息
}

- (void)onAVIMMIMManager:(TCAVIMMIManager *)mgr updateCtrlState:(id<AVMultiUserAble>)user
{
    [(TCShowMultiUILiveViewController *)_liveView updateUserCtrlState:user];
}

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine enableCamera:(BOOL)succ tipInfo:(NSString *)tip
{
    [super onAVEngine:engine enableCamera:succ tipInfo:tip];
    if (succ && _isHost)
    {
        // 调用liveStart接口
        TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
      
        [vc uiStartLive];
    }
}

- (void)onExitLiveSucc:(BOOL)succ tipInfo:(NSString *)tip
{
    
#if TARGET_IPHONE_SIMULATOR
    [[HUDHelper sharedInstance] tipMessage:tip delay:0.5 completion:^{
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
#else
    
    [self releaseIMMsgHandler];
    
    [_liveView setMsgHandler:nil];
    
#if kSupportIMMsgCache
    [self stopRenderTimer];
#endif
    
    if (_isHost)
    {
        // 显示直播结果
        TCShowMultiUILiveViewController *vc = (TCShowMultiUILiveViewController *)_liveView;
        [vc uiEndLive];
        
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:tip delay:0.5 completion:^{
            
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
#endif
    
}


#if kSupportIMMsgCache

- (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame
{
    [super onAVEngine:engine videoFrame:frame];
    
    [self renderUIByAVSDK];
}

- (void)renderUIByAVSDK
{
    // AVSDK采集为15帧每秒
    // 可通过此处的控制显示的频率
    TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
   
    if (_canRenderNow && ![vc isPureMode])
    {
        NSDictionary *dic = [(AVIMMsgHandler *)_msgHandler getMsgCache];
        AVIMCache *msgcache = dic[@(AVIMCMD_Text)];
        [vc onUIRefreshIMMsg:msgcache];
        
        AVIMCache *praisecache = dic[@(AVIMCMD_Praise)];
        [vc onUIRefreshPraise:praisecache];
        _canRenderNow = NO;
    }
}
#endif

#if kSupportIMMsgCache

- (void)onEnterLiveSucc:(BOOL)succ tipInfo:(NSString *)tip
{
    [super onEnterLiveSucc:succ tipInfo:tip];
    if (succ)
    {
        [self startRenderTimer];
    }
}

- (void)onAppEnterBackground
{
    [super onAppEnterBackground];
    [self stopRenderTimer];
}

- (void)onAppEnterForeground
{
    [super onAppEnterForeground];
    [self startRenderTimer];
}

- (void)startRenderTimer
{
    if (!_renderTimer)
    {
        _renderTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onRefreshUI) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_renderTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)onRefreshUI
{
    if (_canRenderNow)
    {
        // 防止- (void)onAVEngine:(TCAVBaseRoomEngine *)engine videoFrame:(QAVVideoFrame *)frame没有回调，导致界面不刷新
        [self renderUIByAVSDK];
        _canRenderNow = NO;
    }
    else
    {
        _canRenderNow = YES;
    }
}

- (void)stopRenderTimer
{
    [_renderTimer invalidate];
    _renderTimer = nil;
}

#endif

- (BOOL)switchToLive:(id<AVRoomAble>)room
{
    BOOL succ = [super switchToLive:room];
    if (succ)
    {
        TCShowLiveUIViewController *vc = (TCShowLiveUIViewController *)_liveView;
      
        [vc switchToLiveRoom:room];
    }
    return succ;
}

@end

#endif
