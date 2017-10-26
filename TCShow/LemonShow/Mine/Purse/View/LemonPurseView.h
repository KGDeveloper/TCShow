//
//  LemonPurseView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/9.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayModel;

@interface LemonPurseView : UIView

//钻石
@property (nonatomic, strong) UILabel *diamondsCoinsLab;

//柠檬币
@property (nonatomic, strong) UILabel *lemonCoinsLab;

//充值类型
@property (nonatomic, strong) NSArray *dataArray;

//充值点击
@property (nonatomic, copy) void (^payBtnClickBlock)(PayModel *model);

- (instancetype)initWithFrame:(CGRect)frame;

@end
