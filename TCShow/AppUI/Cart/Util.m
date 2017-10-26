//
//  Util.m
//  YuanJu
//
//  Created by sigxui－001 on 1/14/16.
//  Copyright © 2016 sigxui－001. All rights reserved.
//

#import "Util.h"
@implementation Util

+ (void) addClickEvent:(id)target action:(SEL)action owner:(UIView *)view{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
}


+ (void)setUILabel:(UILabel *)label Data:(NSString *)string SetData:(NSString *)setstring Color:(UIColor *)color Font:(CGFloat)font Underline:(BOOL)isbool{
    
    
    NSRange str = [label.text rangeOfString:setstring];
    if (str.location != NSNotFound) {
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:label.text];
        [str1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(string.length,setstring.length)]; //设置字体颜色
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(string.length,setstring.length)];
        if (isbool) {
            
            [str1 addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(string.length,setstring.length)];
        }
        
        label.attributedText = str1;
        
    }
    
    
}

+ (void)makeCorner:(CGFloat)corner view:(UIView *)view{
    CALayer *layer = view.layer;
    layer.cornerRadius = corner;
    layer.masksToBounds = YES;
}

#pragma mark 边框
+(void)makeCorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color{
    
    CALayer * fileslayer = [view layer];
    fileslayer.borderColor = [color CGColor];
    fileslayer.borderWidth = corner;
    
}

+(CGFloat)ReturnViewFrame:(UIView *)view Direction:(NSString *)string{

    if ([string  isEqual: @"Y"]) {
        
        return view.frame.origin.y + view.frame.size.height;
        
    }else{
    
        return view.frame.origin.x + view.frame.size.width;
    }
}

#pragma mark 底部灰色线条
+(void)setFoursides:(UIView *)view Direction:(NSString *)dirction sizeW:(CGFloat)sizew{
    
    if ([dirction  isEqual: @"left"]) {
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, sizew)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"right"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - 0.5, 0, 0.5, sizew)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"top"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizew, 0.5)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"bottom"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, sizew, 0.5)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
    }
}


@end
