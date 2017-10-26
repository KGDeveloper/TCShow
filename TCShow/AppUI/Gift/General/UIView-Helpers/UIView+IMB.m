//
//  UIView+IMB.m
//  ArtPraise
//
//  Created by gcz on 14-9-10.
//  Copyright (c) 2014年 gcz. All rights reserved.
//

#import "UIView+IMB.h"

@implementation UIView (IMB)



/**
 **
 **设置动画用的View
 **
 **/

// 圆形化
- (id)cornerView
{
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height)/2;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
    return self;
}

// 圆角化
- (id)cornerViewWithRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius < 0 ? 0 :radius;
    self.clipsToBounds = YES;
    return self;
}

- (id)cornerViewWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner
{
//    UIRectCorner rectCorner;
//    if (leftTop) {
//        rectCorner = (rectCorner | UIRectCornerTopLeft);
//    }
//    if (rightTop) {
//        rectCorner = (rectCorner | UIRectCornerTopRight);
//    }
//    if (leftBottom) {
//        rectCorner = (rectCorner | UIRectCornerBottomLeft);
//    }
//    if (rightBottom) {
//        rectCorner = (rectCorner | UIRectCornerBottomRight);
//    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.clipsToBounds = YES;
    return self;
}

// 添加边界
- (id)addBorderWithWidth:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    return self;
}

// 添加阴影
- (id)addShadowWithRadius:(CGFloat)radius color:(UIColor *)color offset:(CGSize)offSet opacity:(CGFloat)opacity
{
    self.layer.shadowRadius = radius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offSet;
    self.layer.shadowOpacity = opacity;
    return self;
}

- (UIViewController *)respondController
{
    UIViewController *vc = nil;
    
    do {
        if (!vc) {
            vc = (UIViewController *)self.nextResponder;
        }else{
            vc = (UIViewController *)vc.nextResponder;
        }
        
    }while(![vc isKindOfClass:[UIViewController class]]);
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }else{
        return nil;
    }
}

// 动画
- (void)showBounceAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.350;
    animation.delegate =self;
    animation.removedOnCompletion = YES;
    NSMutableArray *values = [NSMutableArray array];
    
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[self.layer addAnimation:animation forKey:nil];
}

- (void)showBounceAnimationWithValues:(NSArray *)arr
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.350;
    animation.delegate =self;
    animation.removedOnCompletion = YES;
//    NSMutableArray *values = [NSMutableArray array];
//    //[values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, -5)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = arr;
	[self.layer addAnimation:animation forKey:nil];
}

@end
