//
//  LMHomeTopSliderView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMHomeTopSliderView : UIView

@property (nonatomic, strong) UIView *bottomLineV;

@property (nonatomic, copy) void (^btnClickBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame;

@end
