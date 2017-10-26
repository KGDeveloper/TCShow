//
//  TCPublishTextField.m
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCPublishTextField.h"

@implementation TCPublishTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawPlaceholderInRect:(CGRect)rect
{
    //    [[UIColor redColor] setFill];
    //    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:19]];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary* dic = @{NSFontAttributeName:[UIFont systemFontOfSize:19.0],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[self placeholder] drawInRect:rect withAttributes:dic];
}

@end
