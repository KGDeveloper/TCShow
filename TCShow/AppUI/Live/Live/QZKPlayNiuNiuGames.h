//
//  QZKPlayNiuNiuGames.h
//  TCShow
//
//  Created by  m, on 2017/9/20.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZKExchangeViewController.h"


@protocol QZKPlayNiuNiuGamesDelegate <NSObject>

- (void) pushToViewcontroller:(QZKExchangeViewController *)controller;

@end

@interface QZKPlayNiuNiuGames : UIView

@property (nonatomic,weak) id<QZKPlayNiuNiuGamesDelegate> delegate;

@property (nonatomic,strong) UIImageView *minepoint;
@property (nonatomic,strong) UIImageView *onepoint;
@property (nonatomic,strong) UIImageView *twopoint;
@property (nonatomic,strong) UIImageView *threepoint;

//庄家
@property (nonatomic,strong) UIView *palyView;
@property (nonatomic,strong) UIImageView *oneImage;
@property (nonatomic,strong) UIImageView *twoImage;
@property (nonatomic,strong) UIImageView *threeImage;
@property (nonatomic,strong) UIImageView *fourImage;
@property (nonatomic,strong) UIImageView *fiveImage;

//一号桌
@property (nonatomic,strong) UIView *userOneView;
@property (nonatomic,strong) UILabel *userOnepoint;
@property (nonatomic,strong) UIImageView *userOneImageOne;
@property (nonatomic,strong) UIImageView *userOneImageTwo;
@property (nonatomic,strong) UIImageView *userOneImageThree;
@property (nonatomic,strong) UIImageView *userOneImageFour;
@property (nonatomic,strong) UIImageView *userOneImageFive;

//二号桌
@property (nonatomic,strong) UIView *userTwoView;
@property (nonatomic,strong) UILabel *userTwopoint;
@property (nonatomic,strong) UIImageView *userTwoImageOne;
@property (nonatomic,strong) UIImageView *userTwoImageTwo;
@property (nonatomic,strong) UIImageView *userTwoImageThree;
@property (nonatomic,strong) UIImageView *userTwoImageFour;
@property (nonatomic,strong) UIImageView *userTwoImageFive;

//三号桌
@property (nonatomic,strong) UIView *userThreeView;
@property (nonatomic,strong) UILabel *userThreepoint;
@property (nonatomic,strong) UIImageView *userThreeImageOne;
@property (nonatomic,strong) UIImageView *userThreeImageTwo;
@property (nonatomic,strong) UIImageView *userThreeImageThree;
@property (nonatomic,strong) UIImageView *userThreeImageFour;
@property (nonatomic,strong) UIImageView *userThreeImageFive;

@property (nonatomic,strong) UILabel *starLab;

@property (nonatomic,copy) void (^clickDidTouch)(UIButton *sender);
@property (nonatomic,copy) void (^rechargekDidTouch)(UIButton *sender);

@property (nonatomic,strong) UILabel *userOneLab;
@property (nonatomic,strong) UILabel *userTwoLab;
@property (nonatomic,strong) UILabel *userThreeLab;

@property (nonatomic,strong) NSTimer *timerNmb;

@property (nonatomic,strong) UIButton *btuOne;
@property (nonatomic,strong) UIButton *btuTwo;
@property (nonatomic,strong) UIButton *btuThree;

@property (nonatomic,strong) UITapGestureRecognizer *userOneTap;
@property (nonatomic,strong) UITapGestureRecognizer *userTwoTap;
@property (nonatomic,strong) UITapGestureRecognizer *userThreeTap;


@property (nonatomic,strong) UIImageView *pokerImage;


@property (nonatomic,strong) AVAudioPlayer *payler;
@property (nonatomic, weak) TCAVBaseRoomEngine *roomEngine;
@property (nonatomic,assign) NSString *room_id;
@property (nonatomic,assign) BOOL userOrAv;

@property (nonatomic,assign) NSInteger timerNumber;
@property (nonatomic,assign) NSInteger secondTimer;
@property (nonatomic,assign) NSInteger butShow;
@property (nonatomic,assign) NSInteger m;
@property (nonatomic,assign) NSInteger n;
@property (nonatomic,assign) NSInteger changeGameState;
@property (nonatomic,assign) NSString *gamesState;



/**
 10积分按钮
 */
@property (nonatomic,strong) UIButton *chipOne;
/**
 25积分按钮
 */
@property (nonatomic,strong) UIButton *chipTwo;
/**
 50积分按钮
 */
@property (nonatomic,strong) UIButton *chipThreen;
/**
 100积分按钮
 */
@property (nonatomic,strong) UIButton *chipFour;
/**
 积分兑换按钮
 */
@property (nonatomic,strong) UIButton *chipBut;
/**
 显示积分
 */
@property (nonatomic,strong) UILabel *chipLable;

- (void) clearTopGamesInfo;


@end
