//
//  TCShowLiveUSerDeatilView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/5.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCShowLiveUSerDeatilView.h"
#import "TCLiveUserList.h"

//===========================私信主播点击主播头像走这里==================================
@implementation TCShowLiveUSerDeatilView {
    UIView   *_clearBg;
    UIView *_bottomV;
    TCLiveUserList *_user;
}

- (instancetype)initWithUser:(TCLiveUserList *)user {
    if (self = [super init]) {
        _user = user;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _clearBg = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_clearBg];
    _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 240, kSCREEN_WIDTH,  240)];
    _bottomV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomV];
    
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 90) / 2, 60, 90, 90)];
    iconV.layer.cornerRadius = 45;
    iconV.layer.masksToBounds = YES;
    
    NSString *imgStr = _user.headsmall;
//    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
//        imgStr = IMG_APPEND_PREFIX(imgStr);
//    }
    [iconV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultUser"]];
    [_bottomV addSubview:iconV];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 155, SCREEN_WIDTH - 60, 20)];
    nameLab.text = _user.nickname;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:14];
    [_bottomV addSubview:nameLab];
    
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 180, 100, 30)];
    msgBtn.layer.cornerRadius = 5;
    msgBtn.layer.borderWidth = 1;
    msgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    msgBtn.layer.borderColor = [UIColor redColor].CGColor;
    [msgBtn setImage:[UIImage imageNamed:@"私信主播"] forState:UIControlStateNormal];
    [msgBtn setTitle:@"私信" forState:UIControlStateNormal];
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(sendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomV addSubview:msgBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_clearBg addGestureRecognizer:tap];
}

- (void)sendMsgBtnClick:(id)sender {
    if (self.clickSendMsgBtnBlock) {
        self.clickSendMsgBtnBlock(_user);
    }
}

- (void)onTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
}

- (void)close
{
#if kSupportFTAnimation
    [self animation:^(id selfPtr) {
        [self fadeOut:0.25 delegate:nil];
    } duration:0.3 completion:^(id selfPtr) {
        [self removeFromSuperview];
    }];
#else
    [self removeFromSuperview];
#endif
}

//- (void)relayoutFrameOfSubViews {
//    CGRect rect = self.bounds;
//    
//    _clearBg.frame = rect;
//    
//    _bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT - 200, kSCREEN_WIDTH,  200);
//    
//}

@end
