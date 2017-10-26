//
//  LMHomeMainTopViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/16.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeMainTopViewCell.h"

@implementation LMHomeMainTopViewCell {
    UILabel *_nameLab;
    UILabel *_coinsLabel;
    UIImageView *_backImageV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat W = (SCREEN_WIDTH-4*15)/3;
    
    _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, W*1.1)];
    _backImageV.userInteractionEnabled = YES;
    _backImageV.layer.cornerRadius = 5;
    _backImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_backImageV];
    
    _coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(W - 30, 10, 25, 13)];
    _coinsLabel.textAlignment = NSTextAlignmentCenter;
    _coinsLabel.textColor = [UIColor whiteColor];
    _coinsLabel.backgroundColor = LEMON_MAINCOLOR;
    _coinsLabel.font = [UIFont systemFontOfSize:10];
    _coinsLabel.adjustsFontSizeToFitWidth = YES;
    _coinsLabel.layer.cornerRadius = 4;
    _coinsLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_coinsLabel];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, W * 1.1 - 20, W, 20)];
    lineV.backgroundColor = [UIColor blackColor];
    lineV.alpha = 0.5;
    lineV.layer.cornerRadius = 5;
    lineV.layer.masksToBounds = YES;
    [self.contentView addSubview:lineV];
    
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, W * 1.1 - 15, 10, 10)];
    imgV1.image = [UIImage imageNamed:@"lemon_baiguanzhong"];
    [self.contentView addSubview:imgV1];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, W * 1.1 - 20, W - 20, 20)];
    _nameLab.text = @"三四五八";
    _nameLab.font = [UIFont systemFontOfSize:10];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.textColor = [UIColor whiteColor];
    //    _nameLab.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:_nameLab];
    
    
}

- (void)refreshUI:(TCShowLiveListItem *)item index:(NSInteger)index {
    _coinsLabel.text = [NSString stringWithFormat:@"top%ld", index + 1];
    NSString *imgStr = item.cover;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_backImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _nameLab.text = item.host.username;
}

@end
