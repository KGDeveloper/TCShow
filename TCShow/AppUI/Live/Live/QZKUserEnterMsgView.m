//
//  QZKUserEnterMsgView.m
//  TCShow
//
//  Created by Mac on 2017/10/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKUserEnterMsgView.h"

@implementation QZKUserEnterMsgView

#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _timeNmb = 0;
        _msgShow = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangerManay:) name:@"USERCHANGERMANAY" object:nil];
    }
    return self;
}

#pragma mark -------用来监听用户进行大额充值
- (void)userChangerManay:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    [self sendDic:dic];
    
}

- (void) sendDic:(NSDictionary *)dic{
    NSString *string = [NSString stringWithFormat:@"%@",dic[@"message"]];
    NSArray *tmpArr1 = [string componentsSeparatedByString:@","];
    NSArray *tmpArr2 = [[tmpArr1[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] componentsSeparatedByString:@":"];
    
    if (_timeNmb == 0) {
        [self createUI:[self replaceUnicode:tmpArr2[1]]];
        _userEnerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(userChargeManay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_userEnerTimer forMode:NSRunLoopCommonModes];
    }else{
        [_dataArr addObject:dic];
    }
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void) createUI:(NSString *)message{
    _chargeScrollView = [[UIScrollView alloc] init];
    _chargeScrollView.frame = CGRectMake(0, 10, ViewWidth, 38); // frame中的size指UIScrollView的可视范围
    _chargeScrollView.backgroundColor = [UIColor clearColor];
    _chargeScrollView.delegate = self;
    
    _chargeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth + 20, 0, 45, 42)];
    _chargeImageView.backgroundColor = [UIColor clearColor];
    _chargeImageView.image = [UIImage imageNamed:@"图层-13"];
    [_chargeScrollView addSubview:_chargeImageView];
    
    _chargeLab = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth + 50, 11, 65, 20)];
    _chargeLab.backgroundColor = [UIColor colorWithRed:115/255.0f green:40/255.0f blue:203/255.0f alpha:1];
    _chargeLab.text = @"充值";
    _chargeLab.textAlignment = NSTextAlignmentRight;
    _chargeLab.textColor = [UIColor whiteColor];
    _chargeLab.font = [UIFont systemFontOfSize:18.0f];
    [_chargeScrollView addSubview:_chargeLab];
    [_chargeScrollView insertSubview:_chargeLab atIndex:0];
    
    //测试数据
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _titleLab.backgroundColor = [UIColor colorWithRed:229/255.0f green:214/255.0f blue:244/255.0f alpha:1];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [_titleLab setFrame:CGRectMake(ViewWidth + 115, 12, textSize.width, 18)];
    _titleLab.text = message;
    _titleLab.textColor = [UIColor colorWithRed:151/255.0f green:106/255.0f blue:215/255.0f alpha:1];
    [_chargeScrollView addSubview:_titleLab];
    [_chargeScrollView insertSubview:_titleLab atIndex:0];
    
    UILabel *backGround = [[UILabel alloc]initWithFrame:CGRectMake(_titleLab.frame.origin.x - (322 - _titleLab.frame.size.width), 11, 332, 20)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-8-副本"]];
    backGround.backgroundColor = color;
    [_chargeScrollView addSubview:backGround];
    [_chargeScrollView insertSubview:backGround atIndex:0];
    
    NSInteger width = _chargeImageView.frame.size.width + _chargeLab.frame.size.width + _titleLab.frame.size.width + ViewWidth + 20;
    _chargeScrollView.contentSize = CGSizeMake(width, 0);//设置滚动范围
    _chargeScrollView.showsVerticalScrollIndicator = NO;
    _chargeScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_chargeScrollView];
}

- (void)userChargeManay{
    _timeNmb += 20;
    [_chargeScrollView setContentOffset:CGPointMake(_timeNmb, 0) animated:YES];
    if (_timeNmb > _chargeScrollView.contentSize.width) {
        _timeNmb = 0;
        [_userEnerTimer invalidate];
        _userEnerTimer = nil;
        [_chargeScrollView removeFromSuperview];
        if (_dataArr.count > 0) {
            NSDictionary *dic = _dataArr[0];
            [self sendDic:dic];
        }
        if (_dataArr.count >= 1) {
            [_dataArr removeObjectAtIndex:0];
        }
    }
}

@end
