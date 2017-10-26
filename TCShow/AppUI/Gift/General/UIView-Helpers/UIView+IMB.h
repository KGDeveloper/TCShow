//
//  UIView+IMB.h
//  ArtPraise
//
//  Created by gcz on 14-9-10.
//  Copyright (c) 2014年 gcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMB)

/**
 *  圆形化
 *
 *  @return self
 */
- (id)cornerView;

/**
 *  圆角化
 *
 *  @param radius 圆角半径
 *
 *  @return self
 */
- (id)cornerViewWithRadius:(CGFloat)radius;

//
// 注意最好固定好宽高后，在调用此方法，才会完美奏效
/**
 圆化指定角

 @param radius 圆化
 @param rectCorner 类型
 @return 返回一个layout
 */
- (id)cornerViewWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner;

/**
 *  添加边界
 *
 *  @param width   边界宽度
 *  @param color   边界颜色
 *
 *  @return self
 */
- (id)addBorderWithWidth:(CGFloat)width color:(UIColor *)color;

/**
 *  添加阴影
 *
 *  @param radius  阴影半径
 *  @param color   阴影颜色
 *  @param offSet  阴影相对偏移量 (CGSize)
 *  @param opacity 阴影透明度
 *
 *  @return self
 */
- (id)addShadowWithRadius:(CGFloat)radius color:(UIColor *)color offset:(CGSize)offSet  opacity:(CGFloat)opacity;

/**
 获取view所在的controller

 @return 返回UIviewcontroller *类型的参数
 */
- (UIViewController *)respondController;

/**
 动画
 */
- (void)showBounceAnimation;

/**
 自定义动画路线

 @param arr 保存动画照片
 */
- (void)showBounceAnimationWithValues:(NSArray *)arr;

@end
