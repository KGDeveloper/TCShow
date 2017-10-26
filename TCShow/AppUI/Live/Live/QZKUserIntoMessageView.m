//
//  QZKUserIntoMessageView.m
//  TCShow
//
//  Created by  m, on 2017/9/29.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKUserIntoMessageView.h"
#import "QZKNotiModel.h"

#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height

@implementation QZKUserIntoMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _mesArr = [NSMutableArray array];
        _dataArr = [NSMutableArray array];
        _timerNmb = 0;
        _msgShow = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSendGift:) name:@"USERSENDGIFT" object:nil];
        
    }
    return self;
}

#pragma mark --------------当用户曾送大礼物时飘屏监听
- (void)userSendGift:(NSNotification *)noti{
    NSDictionary *dataDic = noti.userInfo;
//    [_mesArr addObject:dataDic];
    [self sendDic:dataDic];
}

- (void) sendDic:(NSDictionary *)dic{
    NSDictionary *dataDic = [self stringForData:dic[@"data"]];
    _avRoomId = dic[@"room_id"];
    [_dataArr addObject:[TCShowLiveListItem mj_objectWithKeyValues:dataDic]];
    
    NSString *string = [NSString stringWithFormat:@"%@",dic[@"message"]];
    NSArray *tmpArr1 = [string componentsSeparatedByString:@","];
    NSArray *tmpArr2 = [[tmpArr1[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""] componentsSeparatedByString:@":"];
    
    if (_timerNmb == 0) {
        NSString *message = [self replaceUnicode:tmpArr2[1]];
        NSString *userName = [[message componentsSeparatedByString:@"在"] firstObject];
        NSString *giftName = [[message componentsSeparatedByString:@"送出了"] lastObject];
        NSString *sendName = [[[[message componentsSeparatedByString:@"在"] lastObject] componentsSeparatedByString:@"的直播间送出了"] firstObject];
        [self createUI:userName giftName:giftName sendName:sendName];
        scrollViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollViewChangeSize) userInfo:nil repeats:YES];
    }else{
        [_mesArr addObject:dic];
    }
}

- (NSDictionary *)stringForData:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSData *tempData = [unicodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *resurtDic = [NSJSONSerialization JSONObjectWithData:tempData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&err];
    return resurtDic;
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

- (void)createUI:(NSString *)name giftName:(NSString *)giftName sendName:(NSString *)sendName{
    // 1.创建UIScrollView
    _sendGifrView = [[UIScrollView alloc] init];
    _sendGifrView.frame = CGRectMake(0, 10, ViewWidth, 38); // frame中的size指UIScrollView的可视范围
    _sendGifrView.backgroundColor = [UIColor clearColor];
    _sendGifrView.delegate = self;
    
    _sendGiftImage = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth, 0, 126, 38)];
    _sendGiftImage.backgroundColor = [UIColor clearColor];
    _sendGiftImage.image = [UIImage imageNamed:@"图层-10"];
    [_sendGifrView addSubview:_sendGiftImage];
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
    userName.backgroundColor = [UIColor clearColor];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    CGSize textSize = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [userName setFrame:CGRectMake(ViewWidth + 50, 9, textSize.width + 76, 20)];
    userName.backgroundColor = [UIColor colorWithDisplayP3Red:253/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    userName.textColor = [UIColor whiteColor];
    userName.textAlignment = NSTextAlignmentRight;
    userName.text = name;
    [_sendGifrView addSubview:userName];
    [_sendGifrView insertSubview:userName atIndex:0];
    
    
    UILabel *sendGifttitle = [[UILabel alloc]initWithFrame:CGRectMake(userName.frame.origin.x + userName.frame.size.width, 9, 20, 20)];
    sendGifttitle.backgroundColor = [UIColor colorWithDisplayP3Red:253/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    sendGifttitle.text = @"在";
    sendGifttitle.textColor = [UIColor blackColor];
    [_sendGifrView addSubview:sendGifttitle];

    _liveName = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    CGSize btuSize = [sendName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    _liveName.frame = CGRectMake(sendGifttitle.frame.origin.x + 20, 9, btuSize.width , 20);
    _liveName.backgroundColor = [UIColor colorWithDisplayP3Red:253/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    [_liveName setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_liveName setTitle:sendName forState:UIControlStateNormal];
    _liveName.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_liveName addTarget:self action:@selector(liveBtuTouch:) forControlEvents:UIControlEventTouchDown];
    [_sendGifrView addSubview:_liveName];
    
    NSString *titleGIft = @"的直播间送出了";
    UILabel *secondGifttitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    CGSize labSize = [titleGIft boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
                                              options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    secondGifttitle = [[UILabel alloc]initWithFrame:CGRectMake(_liveName.frame.origin.x + _liveName.frame.size.width, 9, labSize.width, 20)];
    secondGifttitle.backgroundColor = [UIColor colorWithDisplayP3Red:253/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    secondGifttitle.text = titleGIft;
    secondGifttitle.textColor = [UIColor blackColor];
    [_sendGifrView addSubview:secondGifttitle];
    
    //测试数据
    UILabel *giftLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    CGSize giftSize = [giftName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [giftLab setFrame:CGRectMake(secondGifttitle.frame.origin.x + secondGifttitle.frame.size.width, 9, giftSize.width , 20)];
    giftLab.backgroundColor = [UIColor colorWithDisplayP3Red:253/255.0 green:186/255.0 blue:44/255.0 alpha:1];
    giftLab.text = giftName;
    giftLab.textColor = [UIColor redColor];
    [_sendGifrView addSubview:giftLab];
    NSInteger width = _sendGiftImage.frame.origin.x + _sendGiftImage.frame.size.width + secondGifttitle.frame.size.width + giftLab.frame.size.width + _liveName.frame.size.width + sendGifttitle.frame.size.width + userName.frame.size.width;
    _sendGifrView.contentSize = CGSizeMake(width, 0);//设置滚动范围
    _sendGifrView.showsVerticalScrollIndicator = NO;
    _sendGifrView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_sendGifrView];
//    _sendGifrView.bounces = NO;
    
}

- (void)liveBtuTouch:(UIButton *)sender{
    
    if (self.clickButtonEnterAvRoom) {
        self.clickButtonEnterAvRoom(_dataArr);
    }
}

- (void)scrollViewChangeSize{
    _timerNmb += 15;
    if (_timerNmb > _sendGifrView.contentSize.width) {
        _timerNmb = 0;
        [scrollViewTimer invalidate];
        scrollViewTimer = nil;
        [_sendGifrView removeFromSuperview];
        
        if (_mesArr.count > 0) {
            NSDictionary *dic = _mesArr[0];
            [self sendDic:dic];
        }
        if (_mesArr.count >= 1) {
            [_mesArr removeObjectAtIndex:0];
        }
    }else{
        [_sendGifrView setContentOffset:CGPointMake(_timerNmb, 0) animated:YES];
    }
}

@end
