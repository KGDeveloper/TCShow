//
//  GCZPresentItem.m
//  PresentDemo
//
//  Created by gongcz on 16/5/23.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "GCZPresentItem.h"

@implementation GCZRotateImageView

- (void)layoutSubviews
{
//    [self.layer setTransform:CATransform3DMakeScale(1, 1, .10)];
    [self.layer setTransform:CATransform3DMakeRotation(-M_PI_4, 0, 1, 0)];
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.layer setTransform:CATransform3DMakeRotation(M_PI, -.1, 0., .25)];
    } completion:NULL];
//    [self performSelector:@selector(startRotation) withObject:nil afterDelay:.0f];
}

- (void)startRotation
{
    
}

@end

@interface GCZPresentItem ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation GCZPresentItem

- (void)layoutSubviews
{
    [self cornerView:_backView];
    [self cornerView:_headIcon];
    _numLbl.text = nil;
}

// 圆形化
- (void)cornerView:(UIView *)view
{
    view.layer.cornerRadius = view.frame.size.height/2;
    view.clipsToBounds = YES;
}

- (void)updateNum:(NSString *)num
{
    [self updateNum:num animated:YES];
}

- (void)updateNum:(NSString *)num animated:(BOOL)animated
{
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:num];
    //富文本样式
    [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.34 blue:0.35 alpha:1.00],NSStrokeWidthAttributeName:@(-3.),NSStrokeColorAttributeName:[UIColor colorWithRed:0.87 green:0.97 blue:0.60 alpha:1.00]} range:NSMakeRange(0, num.length)];
    _numLbl.attributedText = mStr;
    [_numLbl sizeToFit];
    if (animated) {
        [self showBounceAnimation:_numLbl];
    }
}

- (void)showBounceAnimation:(UIView *)view{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.50;
    animation.delegate =self;
    animation.removedOnCompletion = YES;
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [view.layer addAnimation:animation forKey:nil];
}


/**
 **
 **
 **描述发送的礼物名称
 **
 **
 **/
#pragma mark - Override get method
- (NSString *)descriptionForType:(PresentType)type
{
    NSString *des = @"";
    if (type == PresentType_Blowakiss) {
        des = @"送一个飞吻";
    }else if (type == PresentType_Mua) {
        des = @"送一个么么哒";
    }
    else if (type == PresentType_Red) {
        des = @"送一个红包";
    }
    else if (type == PresentType_Candy) {
        des = @"送一个糖果";
    }
    else if (type == PresentType_Love) {
        des = @"送一个爱心";
    }
    else if (type == PresentType_Six) {
        des = @"送一个柠檬啪";
    }
    else if (type == PresentType_Wand) {
        des = @"送一个魔杖";
    }
    else if (type == PresentType_Diamondring) {
        des = @"送一个钻戒";
    }
    else if (type == PresentType_Kiss) {
        des = @"送一个亲亲";
    }
    else if (type == PresentType_Rose) {
        des = @"送一个玫瑰花";
    }
    else if (type == PresentType_Watermelon) {
        des = @"送一个西瓜";
    }
    else if (type == PresentType_Pig) {
        des = @"送一个招财猪";
    }
    else if (type == PresentType_HappyBirdy) {
        des = @"送一个生日快乐";
    }
    else if (type == PresentType_Home) {
        des = @"送一个城堡";
    }
    else if (type == PresentType_Number) {
        des = @"送一个1314";
    }
    else if (type == PresentType_Car) {
        des = @"送一辆玛莎拉蒂";
    }
    return des;
}

- (void)setType:(PresentType)type
{
    
    _type = type;
    switch (_type) {
        case PresentType_Blowakiss:
            _presentIcon.image = [UIImage imageNamed:@"present_1"];
            break;
        case PresentType_Mua:
            _presentIcon.image = [UIImage imageNamed:@"present_2"];
            break;
        case PresentType_Red:
            _presentIcon.image = [UIImage imageNamed:@"present_3"];
            break;
        case PresentType_Candy:
            _presentIcon.image = [UIImage imageNamed:@"present_10"];
            break;
        case PresentType_Kiss:
            _presentIcon.image = [UIImage imageNamed:@"present_0"];
            break;
        case PresentType_Rose:
            _presentIcon.image = [UIImage imageNamed:@"present_9"];
            break;
        case PresentType_Watermelon:
            _presentIcon.image = [UIImage imageNamed:@"present_6"];
            break;
        case PresentType_Pig:
            _presentIcon.image = [UIImage imageNamed:@"present_12"];
            break;

        case PresentType_Car:
        {
            NSUInteger num = arc4random()%5+1;
            _presentIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(unsigned long)num]];
            _presentIcon.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld-%ld",(unsigned long)num,(unsigned long)num]];
        }
            break;
        case PresentType_Six:
        {
            _presentIcon.image = [UIImage imageNamed:@"NMP"];
            
        }
            break;
        case PresentType_Love:
        {
            _presentIcon.image = [UIImage imageNamed:@"loves1"];
        }
            break;
        case PresentType_Wand:
        {
            _presentIcon.image = [UIImage imageNamed:@"magic14"];
        }
            break;
        case PresentType_Diamondring:
        {
            _presentIcon.image = [UIImage imageNamed:@"ring17"];
        }
            break;
        case PresentType_HappyBirdy:
        {
            _presentIcon.image = [UIImage imageNamed:@"Cake23"];
        }
            break;
        case PresentType_Home:
        {
            _presentIcon.image = [UIImage imageNamed:@"城堡13"];
        }
            break;
        case PresentType_Number:
        {
            _presentIcon.image = [UIImage imageNamed:@"1314-4"];
        }
            break;
    }
}

@end
