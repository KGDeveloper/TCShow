//
//  QZKManayChangeMsg.m
//  TCShow
//
//  Created by Mac on 2017/10/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKManayChangeMsg.h"

@implementation QZKManayChangeMsg

#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _timeNmb = 0;
        _dataArr = [NSMutableArray array];
        _msgShow = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userManayUsed:) name:@"USERMANAYUSED" object:nil];
    }
    return self;
}

#pragma mark ------------用户消费金额到一定数目进入直播间飘屏监听
- (void)userManayUsed:(NSNotification *)noti{
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

- (void) createUI:(NSString *)userName{
    _chargeScrollView = [[UIScrollView alloc] init];
    _chargeScrollView.frame = CGRectMake(0,0, ViewWidth, 38); // frame中的size指UIScrollView的可视范围
    _chargeScrollView.backgroundColor = [UIColor clearColor];
    _chargeScrollView.delegate = self;
    
    _chargeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth + 20, 0, 45,28)];
    _chargeImageView.backgroundColor = [UIColor clearColor];
    _chargeImageView.image = [UIImage imageNamed:@"图层-23"];
    [_chargeScrollView addSubview:_chargeImageView];
    
    //测试数据
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    CGSize textSize = [userName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [_titleLab setFrame:CGRectMake(ViewWidth + 55, 8, textSize.width, 20)];
    _titleLab.backgroundColor = [UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1];
    _titleLab.text = userName;
    _titleLab.textAlignment = NSTextAlignmentRight;
    _titleLab.textColor = [UIColor colorWithRed:151/255.0f green:106/255.0f blue:215/255.0f alpha:1];
    [_chargeScrollView addSubview:_titleLab];
    [_chargeScrollView insertSubview:_titleLab atIndex:0];
    UILabel *backGround = [[UILabel alloc]initWithFrame:CGRectMake(_titleLab.frame.origin.x, 8, 257, 20)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-8-副本-2"]];
    backGround.backgroundColor = color;
    [_chargeScrollView addSubview:backGround];
    [_chargeScrollView insertSubview:backGround atIndex:0];
    
    NSInteger width = _chargeImageView.frame.size.width + _titleLab.frame.size.width + ViewWidth + 20;
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
