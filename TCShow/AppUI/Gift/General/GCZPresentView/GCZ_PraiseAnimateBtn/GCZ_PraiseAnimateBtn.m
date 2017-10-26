//
//  GCZ_PraiseAnimateBtn.m
//  PraiseAnimateDemo
//
//  Created by gcz on 15/7/13.
//  Copyright (c) 2015年 gcz. All rights reserved.
//

#import "GCZ_PraiseAnimateBtn.h"

@implementation GCZ_PraiseAnimateBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
}

static BOOL isRight;
- (void)praiseClick:(UIButton *)sender
{
    @synchronized(self){
        
        if (_pcBlock) {
            dispatch_async(dispatch_get_main_queue(),^{
                _pcBlock(self);
            });
        }
        
        if (_hideHeart) {
            return;
        }
        
        [self showHeartAnimation:sender];
    }
}

- (void)showHeartAnimation:(UIButton *)sender
{
    isRight = !isRight;
    NSString *imgName = [NSString stringWithFormat:@"heart%ld",random()%7]; // 随机0-6
    
    //自定义一个图层
    CALayer *_layer=[[CALayer alloc]init];
    _layer.position = [sender center];
    _layer.anchorPoint = CGPointMake(0.5, 0.5);
    _layer.bounds=CGRectMake(0, 0, 30, 30);
//    _layer.position=CGPointMake(50, 150);
    _layer.contents=(id)[UIImage imageNamed:imgName].CGImage;
    [self.superview.layer addSublayer:_layer];
    
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    imgV.center = [sender center];
//    
////    NSString *imgName = [NSString stringWithFormat:@"heart%ld",1+random()%4]; // 随机1-4
//    imgV.image = [UIImage imageNamed:imgName];
//    [self.superview addSubview:imgV];
    
//    CGFloat deltaX = 0+random()%30;
//    CGFloat deltaY = 250+10+random()%10;
//    
//    CGFloat toCenterX = imgV.center.x + (isRight?deltaX:-deltaX);
//    CGFloat toCenterY = imgV.center.y - deltaY;
    
//    [self groupAnimation:imgV.layer];
    [self groupAnimation:_layer];
    CAAnimation *ani = [_layer animationForKey:@"KCKeyframeAnimation_Position"];
    [_layer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:ani.duration];
    
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        _layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
//        
//    }];
//    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        imgV.center = CGPointMake(toCenterX, toCenterY);
//        [imgV setTransform:CGAffineTransformMakeRotation(isRight? M_PI_4: -M_PI_4)];
//        [imgV setAlpha:0];
//        
//    } completion:^(BOOL finished) {
//        [imgV removeFromSuperview];
//    }];
}

- (void)handlePriaseBlock:(PraiseClickBlock)block
{
    _pcBlock = block;
}

- (void)showHeartWithNum:(NSInteger)num
{
    for (int i = 0; i < num; i++) {
        [self showHeartAnimation:self];
    }
}

#pragma mark - 缩放动画
- (CABasicAnimation *)scaleAnimation
{
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
//    animation.repeatCount = 1; // 重复次数
//    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    // 添加动画
//    [layer addAnimation:animation forKey:@"scaletest"];
    return animation;
}

#pragma mark 基础旋转动画
-(CABasicAnimation *)alphaAnimation{
    
    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.];
    opacityAnim.removedOnCompletion = YES;
    
    return opacityAnim;
}

#pragma mark 关键帧动画
-(CAKeyframeAnimation *)translationAnimation:(CALayer *)layer{
    
    isRight = arc4random()%2;
    
//    CGFloat deltaX = isRight?(10+random()%5):-(10+random()%5);
    
    CGFloat heart_deltaY = 60+arc4random()%20;
    
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //2.设置关键帧,这里有四个关键帧
    NSValue *key1=[NSValue valueWithCGPoint:layer.position];//对于关键帧动画初始值不能省略
    NSValue *key2=[NSValue valueWithCGPoint:CGPointMake(layer.position.x-(isRight?(10+random()%5):-(10+random()%5)), layer.position.y-heart_deltaY)];
    NSValue *key3=[NSValue valueWithCGPoint:CGPointMake(layer.position.x+(isRight?(10+random()%5):-(10+random()%5)), layer.position.y-2.3*heart_deltaY+random()%10)];
    NSValue *key4=[NSValue valueWithCGPoint:CGPointMake(layer.position.x-(isRight?(10+random()%5):-(10+random()%5)), layer.position.y-3.5*heart_deltaY+random()%15)];
//    NSValue *key5=[NSValue valueWithCGPoint:CGPointMake(toCenterX+7, layer.position.y-4*heart_deltaY)];
    NSArray *values=@[key1,key2,key3,key4];
    keyframeAnimation.values=values;
    //设置其他属性
//    keyframeAnimation.duration=2+arc4random()%2;
//    keyframeAnimation.beginTime=CACurrentMediaTime()+5;//设置延迟2秒执行
    
    
    //3.添加动画到图层，添加动画后就会执行动画
//    [layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
//    [keyframeAnimation setRemovedOnCompletion:YES];
    return keyframeAnimation;
}

#pragma mark 创建动画组
-(void)groupAnimation:(CALayer *)layer{
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *scaleAnimation = [self scaleAnimation];
    CABasicAnimation *basicAnimation=[self alphaAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self translationAnimation:layer];
    animationGroup.animations=@[scaleAnimation,keyframeAnimation,basicAnimation];
    
//    animationGroup.delegate=self;
    animationGroup.duration=2+arc4random()%2;;//10.0;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
//    animationGroup.beginTime=CACurrentMediaTime()+5;//延迟五秒执行
    
    //3.给图层添加动画
    [layer addAnimation:animationGroup forKey:@"KCKeyframeAnimation_Position"];
}

@end
