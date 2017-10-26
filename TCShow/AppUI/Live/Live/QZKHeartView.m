//
//  QZKHeartView.m
//  TCShow
//
//  Created by  m, on 2017/9/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKHeartView.h"

#define KSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define KSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height


@implementation QZKHeartView


- (instancetype) initWithFrame:(CGRect)frame
{
    if (self) {
        
        self = [super initWithFrame:frame];
        
        self.loveTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(StartLittleHeartShow) userInfo:nil repeats:YES];
    }
    
    return self;
}


/**
 创建点赞动画
 */
- (void) StartLittleHeartShow{
    
    
    NSInteger soon = arc4random()%12;
    UIImage* flakeImage = [UIImage imageNamed:[NSString stringWithFormat:@"heart%ld.png",(long)soon]];
    UIImageView* flakeView = [[UIImageView alloc] initWithImage:flakeImage];
    
    // 设置小桃心动画起始点，X位置向右随机偏移0~19
    long lRandom = random();
    int startX = KSCREEN_WIDTH;
    int startY = KSCREEN_HEIGHT - 100;
    
    //设置小桃心动画结束点，X位置左右偏移0~74
    int endX = ((lRandom%2)==0) ? (startX - lRandom%75) : (startX + lRandom%75);
    double scale = 1 / round(random() % 100) + 1.0;//设置桃心大小的随机偏移，这样出来的桃心大小就可以不一样
    double speed = 1 / round(random() % 100) + 1.0;//设置桃心飞行的速度偏移，这样每个桃心飞出来的速度就可以不一样
    
    scale = (scale > 1.5) ? 1.5 : scale;
    flakeView.frame = CGRectMake(startX, startY, 25.0 * scale, 25.0 * scale);//初始化桃心的frame
    flakeView.alpha = 0.5;
    
    @try {
        
        // 把该桃心加入到主视图中，注意在动画完成后，需要把这个桃心从主视图中remove掉
        [self addSubview:flakeView];
        [UIView beginAnimations:nil context:(__bridge void *)(flakeView)];
        // 设置桃心飞行的时间，也就是其飞行的速度
        float fSpeedBase = random()%5;
        fSpeedBase = (fSpeedBase < 3.0) ? 3.0 : fSpeedBase;
        float fDuration = fSpeedBase * speed;
        fDuration = (fDuration > 5.0) ? 5.0 : fDuration;
        fDuration = (fDuration <= 0) ? 2.5 : fDuration;
        fDuration = fDuration - 1;
        [UIView setAnimationDuration:fDuration];
        
        // 设置桃心的飞行终点！
        flakeView.frame = CGRectMake(endX - 100, 250 + random()%100, 30.0 * scale, 30.0 * scale);
        // 设置桃心动画结束后的callback函数，需要在callback中将flakeView移除self.view
        [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];//开始动画
    }
    
    @catch (NSException *exception) {
        
    }
}

/**
 在动画结束后，onAnimationComplete函数中移除flakeView
 
 @param animationID
 @param finished
 @param context
 */
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    UIImageView *flakeView = (__bridge UIImageView *)(context);
    
    flakeView.hidden = YES;
    
    [flakeView removeFromSuperview];
    
}


@end
