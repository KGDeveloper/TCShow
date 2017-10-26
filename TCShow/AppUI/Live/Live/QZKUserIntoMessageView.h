//
//  QZKUserIntoMessageView.h
//  TCShow
//
//  Created by  m, on 2017/9/29.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZKUserIntoMessageView : UIView<UIScrollViewDelegate>{
    NSTimer *scrollViewTimer;
}

@property (nonatomic,assign) NSString *userMsg;
@property (nonatomic,strong) UIImageView *chargeImage;//充值
@property (nonatomic,strong) UIImageView *inToRoomImage;//进入房间
@property (nonatomic,strong) UIImageView *sendGiftImage;//赠送大礼物
@property (nonatomic,strong) UIScrollView *chargeView;
@property (nonatomic,strong) UIScrollView *intoRoomView;
@property (nonatomic,strong) UIScrollView *sendGifrView;
@property (nonatomic,strong) UIButton *liveName;//主播昵称
@property (nonatomic, weak) TCAVBaseRoomEngine *roomEngine;
@property (nonatomic,assign) NSInteger timerNmb;
@property (nonatomic,copy) NSMutableArray *mesArr;
@property (nonatomic,assign) BOOL msgShow;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSString *avRoomId;

@property (nonatomic,copy) void(^clickButtonEnterAvRoom)(NSArray *arr);

@end
