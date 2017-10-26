//
//  QZKManayChangeMsg.h
//  TCShow
//
//  Created by Mac on 2017/10/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZKManayChangeMsg : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *chargeScrollView;//滚动显示充值飘屏
@property (nonatomic,strong) UIImageView *chargeImageView;//显示金钱猪的image
@property (nonatomic,strong) UILabel *titleLab;//显示飘屏信息的lab
@property (nonatomic,copy) NSTimer *userEnerTimer;//控制飘屏
@property (nonatomic,assign) NSInteger timeNmb;
@property (nonatomic,copy) NSMutableArray *dataArr;
@property (nonatomic,assign) BOOL msgShow;

@end
