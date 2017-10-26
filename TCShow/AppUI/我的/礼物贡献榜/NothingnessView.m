//
//  NothingnessView.m
//  TCShow
//
//  Created by tangtianshi on 16/11/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "NothingnessView.h"

@implementation NothingnessView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}


-(void)addSubviews{
    _noSourceimageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH - 100)/2.0, 0, 100, 100)];
    [self addSubview:_noSourceimageView];
    
    _noSourceLabel = [UILabel label];
    _noSourceLabel.frame = CGRectMake(0, CGRectGetMaxY(_noSourceimageView.frame) + 10, kSCREEN_WIDTH, 20);
    _noSourceLabel.textColor = YCColor(131, 131, 130, 1.0);
    _noSourceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noSourceLabel];
}

@end
