//
//  TCLiveTypeReusableView.m
//  TCShow
//
//  Created by tangtianshi on 16/12/19.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCLiveTypeReusableView.h"
@interface TCLiveTypeReusableView()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * lineLabel;
@end

@implementation TCLiveTypeReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self concentrationGoods];
    }
    return self;
}

-(void)concentrationGoods{
    if (self.titleLabel == nil) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH - 15, 39.5)];
        self.titleLabel.text = @"所有分类";
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = RGBA(152, 152, 152, 1.0);
        [self addSubview:self.titleLabel];
    }
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, kSCREEN_WIDTH, 0.5)];
        _lineLabel.backgroundColor = RGBA(152, 152, 152, 1.0);
        [self addSubview:_lineLabel];
    }
}

@end
