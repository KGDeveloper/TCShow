//
//  Util.h
//  YuanJu
//
//  Created by sigxui－001 on 1/14/16.
//  Copyright © 2016 sigxui－001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Util : NSObject


+ (void) addClickEvent:(id)target action:(SEL)action owner:(UIView *)view;//添加单击手势

+ (void)makeCorner:(CGFloat)corner view:(UIView *)view;//给某个控件设圆角
//边框
+(void)makeCorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color;

//控件边缘灰色线条
+(void)setFoursides:(UIView *)view Direction:(NSString *)dirction sizeW:(CGFloat)sizew;

// 设置UILabel的不同颜色与大小
+ (void)setUILabel:(UILabel *)label Data:(NSString *)string SetData:(NSString *)setstring Color:(UIColor *)color Font:(CGFloat)font Underline:(BOOL)isbool;


// 设置导航栏
+(void)setNaviItem:(UIBarButtonItem *)item UIViewController:(UIViewController *)View;

+(CGFloat)ReturnViewFrame:(UIView *)view Direction:(NSString *)string;

//导航栏
+(void)setNaviItemImage:(NSString *)imageString Target:(UIViewController *)rarget Action:(SEL)action;


@end
