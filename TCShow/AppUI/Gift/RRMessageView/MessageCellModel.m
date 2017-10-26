//
//  MessageCellModel.m
//  直播Test
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MessageCellModel.h"
#import <UIKit/UIKit.h>
#import "Macro.h"
@implementation MessageCellModel


/**
 **
 **用来解析显示用户发表言论的cell的model
 **
 **/

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.isSendGift = NO;
    }
    return self;
}

-(void)setUsername:(NSString *)username{
    _username = username;
}

-(void)setMessage:(NSString *)message{
    _message = message;
}

// 设置消息内容
-(void)setContent:(NSMutableAttributedString *)content{
    CGFloat tableW = SCREEN_WIDTH-16;
    _content = content;
    NSString *str = [NSString stringWithFormat:@"%@",content];
    // 计算字符串的size
//    CGSize sz =  [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:15.0f], NSFontAttributeName, nil]];
//    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    lbl.numberOfLines = 0;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.attributedText = content;
    CGSize sz = [lbl sizeThatFits:CGSizeMake(tableW, MAXFLOAT)];
    
    _cellwidth = sz.width + 10-10;
    _cellheight = sz.height + 20;

    // 换行（判断有字符串 在一定的宽度下的行数）
    if (_cellwidth < tableW) {
        _cellwidth += 10;
    }
//    int numberOfLines = _cellwidth /tableW;
//    if (numberOfLines > 0) {
//        _cellwidth = tableW;
//        _cellheight = _cellheight *(numberOfLines + 1) - 10*(numberOfLines + 1);
//    }
    
    // 判断是否是本条信息是否是 礼物， 是礼物则算出本条文字信息的最后一个字符位置，在最后字符位置后放一个图片。
    if (self.isSendGift) {
        self.lastPoint = CGPointMake(10+sz.width, 0);
        // 判断消息内容时候换行
        // (int)sz.width % (int)(SCREEN_WIDTH - 100) 算出最后一行的末尾字符的位置
//        if (numberOfLines > 0) {
//            self.lastPoint = CGPointMake(10 + (int)sz.width % (int)(tableW), (sz.height * numberOfLines)-(numberOfLines * 10));
//        }
    }
    
    NSInteger length = _username.length + 1;
    if (![_content.string containsString:@":"]) {
        length--;
    }
    // 改变用户名的显示颜色
    [_content addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, length)];
    
}

@end
