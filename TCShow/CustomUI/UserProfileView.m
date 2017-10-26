//
//  UserProfileView.m
//  TCShow
//
//  Created by AlexiChen on 16/5/12.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileView.h"

@implementation UserProfileView


- (void)addOwnViews
{
    _backView = [[UIView alloc] init];
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss:)];
    [_backView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    
    
    _icon = [[UIImageView alloc] init];
    _icon.layer.cornerRadius = 24;
    _icon.layer.masksToBounds = YES;
    [_contentView addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.font = kAppMiddleTextFont;
    [_contentView addSubview:_name];
    
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
    
    _signature = [[UILabel alloc] init];
    _signature.font = kAppSmallTextFont;
    _signature.textColor = kLightGrayColor;
    [_contentView addSubview:_signature];
    
    _desc = [[UILabel alloc] init];
    _desc.font = kAppSmallTextFont;
    _desc.textColor = kGrayColor;
    [_contentView addSubview:_desc];
    
    _focus = [[UIButton alloc] init];
    _focus.titleLabel.font = kAppMiddleTextFont;
    [_focus setTitle:@"关注" forState:UIControlStateNormal];
    [_focus setTitle:@"取消关注" forState:UIControlStateSelected];
    [_focus setTitleColor:kRedColor forState:UIControlStateNormal];
    [_focus setTitleColor:kWhiteColor forState:UIControlStateSelected];
    [_focus setBackgroundImage:nil forState:UIControlStateNormal];
    [_focus setBackgroundImage:[UIImage imageWithColor:kRedColor] forState:UIControlStateSelected];
    [_focus addTarget:self action:@selector(onFocus) forControlEvents:UIControlEventTouchUpInside];
    _focus.layer.borderWidth = 1;
    _focus.layer.borderColor = [kRedColor CGColor];
    _focus.hidden = YES;
    [_contentView addSubview:_focus];
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
    _contentView.frame = CGRectMake(0, self.bounds.size.height - 135, self.bounds.size.width, 135);
    
    CGRect rect = _contentView.bounds;
    
    [_focus sizeWith:CGSizeMake(rect.size.width, 30)];
    [_focus alignParentBottomWithMargin:kDefaultMargin];
    [_focus shrinkHorizontal:kDefaultMargin];
    
    [_icon sizeWith:CGSizeMake(48, 48)];
    [_icon alignParentLeftWithMargin:kDefaultMargin];
    [_icon alignParentTopWithMargin:(rect.size.height - 48 - 30 - kDefaultMargin)/2];
    
    [_report sizeWith:CGSizeMake(60, 24)];
    [_report alignParentTopWithMargin:kDefaultMargin];
    [_report alignParentRightWithMargin:kDefaultMargin];
    
    [_name sizeWith:CGSizeMake(0, 28)];
    [_name alignParentTopWithMargin:kDefaultMargin];
    [_name layoutToRightOf:_icon margin:kDefaultMargin];
    [_name scaleToLeftOf:_report margin:kDefaultMargin];
    
    [_signature sizeWith:CGSizeMake(0, 24)];
    [_signature layoutBelow:_name];
    [_signature alignLeft:_name];
    [_signature scaleToParentRightWithMargin:kDefaultMargin];
    
    [_desc sameWith:_signature];
    [_desc layoutBelow:_signature];
}

- (void)onReport
{
    ReportHostView *view = [[ReportHostView alloc] init];
    [self.superview addSubview:view];
    [view setFrameAndLayout:self.superview.bounds];
    [view showUser:userDic];
}

- (void)onFocus
{
    _focus.selected = !_focus.selected;
}

- (void)configOwnViews
{
    _signature.text = @"我的签名就是把我的世界直播给你们";
    _desc.text = [NSString stringWithFormat:@"粉丝数:%@                     关注:%@", @"0", @"0"];
}

- (void)configWith:(NSDictionary *)profile
{
    if (profile)
    {
//        _showUser = profile;
        [_icon sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(profile[@"headsmall"])] placeholderImage:kDefaultUserIcon];
        _name.text = profile[@"nickname"];
        _signature.text = profile[@"personalized"];
        _desc.text = [NSString stringWithFormat:@"粉丝数:%@                     关注:%@", profile[@"fans_num"], profile[@"follow_num"]];
    }
}

- (void)showUser:(id<IMUserAble>)user
{
    [_icon sd_setImageWithURL:[NSURL URLWithString:[user imUserIconUrl]] placeholderImage:kDefaultUserIcon];
    _name.text = [user imUserName];
    __weak UserProfileView *ws = self;
    [[Business sharedInstance] getUserInfoByPhone:[user imUserId] succ:^(NSString *msg, id data) {
        userDic = data;
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
@end
