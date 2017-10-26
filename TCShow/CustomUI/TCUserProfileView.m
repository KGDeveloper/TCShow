
//
//  TCUserProfileView.m
//  TCShow
//
//  Created by tangtianshi on 16/12/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCUserProfileView.h"
static NSString * followsState;
@implementation TCUserProfileView
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self.userImageView cornerViewWithRadius:30];
//    [self.attionButton cornerViewWithRadius:5];
//    [self.attionButton addBorderWithWidth:1.0 color:kNavBarThemeColor];
//    [self.chatButton cornerViewWithRadius:5];
//    [self.chatButton addBorderWithWidth:1.0 color:RGBA(71, 71, 71, 1.0)];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss:)];
//    [_backView addGestureRecognizer:tap];
//}


- (void)addOwnViews
{
    _backView = [[UIView alloc] init];
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss:)];
    [_backView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = kWhiteColor;
    [self addSubview:_contentView];
    
    //头像
    _icon = [[UIImageView alloc] init];
    _icon.layer.cornerRadius = 30;
    _icon.layer.masksToBounds = YES;
    [_contentView addSubview:_icon];
    
    //用户名
    _name = [[UILabel alloc] init];
    _name.font = [UIFont systemFontOfSize:15];
    _name.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_name];
    
    //关注数量
    _attionNumber = [[UILabel alloc]init];
    _attionNumber.font = [UIFont systemFontOfSize:13];
    _attionNumber.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:_attionNumber];
    
    //粉丝数量
    _fansNumber = [[UILabel alloc]init];
    _fansNumber.font = [UIFont systemFontOfSize:13.0];
    [_contentView addSubview:_fansNumber];
    
    //举报
    _report = [[UIButton alloc] init];
    _report.titleLabel.font = kAppMiddleTextFont;
    [_report setTitle:@"举报" forState:UIControlStateNormal];
    [_report setTitleColor:kRedColor forState:UIControlStateNormal];
    _report.layer.borderWidth = 1;
    _report.layer.borderColor = [kRedColor CGColor];
    _report.layer.cornerRadius = 12;
    _report.layer.masksToBounds = YES;
    [_report addTarget:self action:@selector(onReport) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_report];
    
//    _signature = [[UILabel alloc] init];
//    _signature.font = kAppSmallTextFont;
//    _signature.textColor = kLightGrayColor;
//    [_contentView addSubview:_signature];
    
//    _desc = [[UILabel alloc] init];
//    _desc.font = kAppSmallTextFont;
//    _desc.textColor = kGrayColor;
//    [_contentView addSubview:_desc];
    
    //是否关注
    _focus = [[UIButton alloc] init];
    _focus.titleLabel.font = [UIFont systemFontOfSize:13];
    [_focus setTitle:@"关注" forState:UIControlStateNormal];
    [_focus setTitleColor:RGBA(71, 71, 71, 1.0) forState:UIControlStateNormal];
    //设置button正常状态下的图片
    [_focus cornerViewWithRadius:5];
    [_focus addTarget:self action:@selector(onFocusClick) forControlEvents:UIControlEventTouchUpInside];
    _focus.layer.borderWidth = 1;
    _focus.layer.borderColor = RGBA(71, 71, 71, 1.0).CGColor;
    [_contentView addSubview:_focus];
    
    //私信
    _chat = [[UIButton alloc] init];
    _chat.titleLabel.font = [UIFont systemFontOfSize:13];
    [_chat setTitle:@"私信" forState:UIControlStateNormal];
    [_chat setTitleColor:RGBA(71, 71, 71, 1.0) forState:UIControlStateNormal];
    [_chat setImage:[UIImage imageNamed:@"私信主播"] forState:UIControlStateNormal];
    [_chat cornerViewWithRadius:5];
    [_chat addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    _chat.layer.borderWidth = 1;
    _chat.layer.borderColor = RGBA(71, 71, 71, 1.0).CGColor;
    [_contentView addSubview:_chat];
    
}

- (void)onDismiss:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
#if kSupportFTAnimation
        [self animation:^(id selfPtr) {
            [_backView fadeOut:0.25 delegate:nil];
            [_contentView slideOutTo:kFTAnimationBottom duration:0.25 delegate:nil];
        } duration:0.3 completion:^(id selfPtr) {
            [self removeFromSuperview];
        }];
#else
        [self removeFromSuperview];
#endif
    }
}

- (void)relayoutFrameOfSubViews
{
    _backView.frame = self.bounds;
    _contentView.frame = CGRectMake(0, self.bounds.size.height - 240, self.bounds.size.width, 240);
    
    CGRect rect = _contentView.bounds;
    //头像
    [_icon sizeWith:CGSizeMake(60, 60)];
    [_icon alignParentCenter];
    [_icon alignParentTopWithMargin:39];
    
    //用户名
    [_name sizeWith:CGSizeMake(kSCREEN_WIDTH - 40, 28)];
    //    [_name layoutToRightOf:_icon margin:10];
    [_name alignParentCenter];
    [_name alignParentTopWithMargin:109];
    
    //关注数量
    _attionNumber.frame = CGRectMake(20, CGRectGetMaxY(_name.frame) + 5, kSCREEN_WIDTH/2.0 - 50, 28);
    
    //粉丝数量
    _fansNumber.frame = CGRectMake(CGRectGetMaxX(_attionNumber.frame) + 60, CGRectGetMaxY(_name.frame) + 3, kSCREEN_WIDTH/2.0 - 50, 28);
    
    //关注按钮
    _focus.frame = CGRectMake(kSCREEN_WIDTH/2.0 - 90 - 21, CGRectGetMaxY(_attionNumber.frame) + 15, 90, 30);
    
    //私信按钮
    _chat.frame = CGRectMake(CGRectGetMaxX(_focus.frame) + 42, CGRectGetMaxY(_attionNumber.frame) + 15, 90, 30);
    _chat.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 60);
    _chat.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    //举报
    [_report sizeWith:CGSizeMake(60, 24)];
    [_report alignParentTopWithMargin:kDefaultMargin];
    [_report alignParentRightWithMargin:kDefaultMargin];
    
}

- (void)onReport
{
//    ReportHostView *view = [[ReportHostView alloc] init];
//    [self.superview addSubview:view];
//    [view setFrameAndLayout:self.superview.bounds];
//    [view showUser:_userDic];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定要举报吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
}


#pragma mark -------onReportUIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[Business sharedInstance] liveReport:[SARUserInfo userId] accuse_id:_userDic[@"uid"] cause:nil complement:nil succ:^(NSString *msg, id data) {
                [[HUDHelper sharedInstance] tipMessage:msg];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:error];
        }];
    }
}

#pragma mark ------关注点击
- (void)onFocusClick{
    [[Business sharedInstance] concern:_userDic[@"uid"] uid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        NSString * fansNumber = [_fansNumber.text substringToIndex:_fansNumber.text.length - 2];
        if ([data[@"code"] integerValue] == 0) {
            if ([followsState integerValue] == 0) {
                [_focus setTitle:@"取消关注" forState:UIControlStateNormal];
                [_focus setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
                _focus.layer.borderColor = kNavBarThemeColor.CGColor;
                _fansNumber.text = [NSString stringWithFormat:@"%ld粉丝",[fansNumber integerValue] + 1];
                [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"FOLLOWSTATE" object:nil userInfo:@{@"is_follows":@"1"}]];
                followsState = @"1";
                [_focus setImage:[UIImage imageNamed:@"关注主播"] forState:UIControlStateNormal];
                _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
                _focus.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }else if ([followsState integerValue] == 1){
                [_focus setTitle:@"关注" forState:UIControlStateNormal];
                [_focus setTitleColor:RGBA(71, 71, 71, 1.0) forState:UIControlStateNormal];
                _focus.layer.borderColor = RGBA(71, 71, 71, 1.0).CGColor;
                _fansNumber.text = [NSString stringWithFormat:@"%d粉丝",[fansNumber integerValue] - 1];
                [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"FOLLOWSTATE" object:nil userInfo:@{@"is_follows":@"0"}]];
                followsState = @"0";
                [_focus setImage:[UIImage imageNamed:@"未关注主播"] forState:UIControlStateNormal];
                _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 60);
                _focus.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            }
        }else{
            [[HUDHelper sharedInstance] tipMessage:msg];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
}


#pragma mark --------私信点击
-(void)chatClick{
    self.chatFromLive(_userModel);
}


- (void)configOwnViews:(TCShowLiveListItem *)user
{
//    _signature.text = @"我的签名就是把我的世界直播给你们";
//    _desc.text = [NSString stringWithFormat:@"粉丝数:%@                     关注:%@", @"0", @"0"];
    [_icon sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX([[user liveHost] imUserIconUrl])] placeholderImage:kDefaultUserIcon];
    _name.text = [[user liveHost] imUserName];
    _attionNumber.text = [NSString stringWithFormat:@"%@关注",user.follow_num];
    _fansNumber.text = @"0粉丝";
    followsState = user.is_follow;
    if ([user.is_follow integerValue] == 0) {
        [_focus setTitle:@"关注" forState:UIControlStateNormal];
        [_focus setTitleColor:RGBA(71, 71, 71, 1.0) forState:UIControlStateNormal];
        _focus.layer.borderColor = RGBA(71, 71, 71, 1.0).CGColor;
        [_focus setImage:[UIImage imageNamed:@"未关注主播"] forState:UIControlStateNormal];
        _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 60);
        _focus.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }else if ([user.is_follow integerValue] == 1){
        [_focus setTitle:@"取消关注" forState:UIControlStateNormal];
        [_focus setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
        _focus.layer.borderColor = kNavBarThemeColor.CGColor;
        [_focus setImage:[UIImage imageNamed:@"关注主播"] forState:UIControlStateNormal];
        _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
        _focus.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)configWith:(NSDictionary *)profile
{
    if (profile){
        _userDic = profile;
        [_icon sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(profile[@"headsmall"])] placeholderImage:kDefaultUserIcon];
        _name.text = profile[@"nickname"];
        _attionNumber.text = [NSString stringWithFormat:@"%@关注",profile[@"follows"]];
        _fansNumber.text = [NSString stringWithFormat:@"%@粉丝",profile[@"fans"]];
        followsState = profile[@"is_follows"];
        if ([profile[@"is_follows"] integerValue] == 0) {
            [_focus setTitle:@"关注" forState:UIControlStateNormal];
            [_focus setTitleColor:RGBA(71, 71, 71, 1.0) forState:UIControlStateNormal];
            _focus.layer.borderColor = RGBA(71, 71, 71, 1.0).CGColor;
            [_focus setImage:[UIImage imageNamed:@"未关注主播"] forState:UIControlStateNormal];
            _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 60);
            _focus.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        }else if ([profile[@"is_follows"] integerValue] == 1){
            [_focus setTitle:@"取消关注" forState:UIControlStateNormal];
            [_focus setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
            _focus.layer.borderColor = kNavBarThemeColor.CGColor;
            [_focus setImage:[UIImage imageNamed:@"关注主播"] forState:UIControlStateNormal];
            _focus.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
            _focus.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
}

- (void)showUser:(TCShowLiveListItem *)user{
    _userModel = user;
    [self configOwnViews:user];
    __weak TCUserProfileView *ws = self;
    [[Business sharedInstance] getUserInfoByUid:[SARUserInfo userId] userid:user.host.uid succ:^(NSString *msg, id data) {
        _userDic = data;
        [ws configWith:data];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
    
#if kSupportFTAnimation
    [_backView fadeIn:0.25 delegate:nil];
    [_contentView slideInFrom:kFTAnimationBottom duration:0.25 delegate:nil];
#else
    _backView.hidden = NO;
    _contentView.hidden = NO;
#endif
    
}



#pragma mark -------私信
- (IBAction)chatButtonClick:(UIButton *)sender {
}

#pragma mark -------关注
- (IBAction)attionButtonClick:(UIButton *)sender {
}


@end
