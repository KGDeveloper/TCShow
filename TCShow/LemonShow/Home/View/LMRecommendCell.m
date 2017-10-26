//
//  LMRecommendCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMRecommendCell.h"

@implementation LMRecommendCell 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat W = (SCREEN_WIDTH-3*15)/2;
    _iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, W)];
    _iconImgV.image = [UIImage imageNamed:@"zanwu"];
//    _iconImgV.backgroundColor = [UIColor redColor];
    _iconImgV.layer.cornerRadius = 5;
    _iconImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImgV];
    
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, W, 20, 20)];
    imgV1.image = [UIImage imageNamed:@"guanzhong"];
    [self.contentView addSubview:imgV1];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, W, W - 80, 20)];
    _nameLab.text = @"三四五八";
    _nameLab.font = [UIFont systemFontOfSize:12];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.textColor = [UIColor blackColor];
//    _nameLab.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:_nameLab];
    
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(W - 60, W, 20, 20)];
    imgV2.image = [UIImage imageNamed:@"dingwei"];
    [self.contentView addSubview:imgV2];
    
    _cityLab = [[UILabel alloc] initWithFrame:CGRectMake(W - 40, W, 40, 20)];
    _cityLab.text = @"北京市";
    _cityLab.font = [UIFont systemFontOfSize:10];
    _cityLab.textAlignment = NSTextAlignmentLeft;
    _cityLab.textColor = [UIColor blackColor];
//    _cityLab.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_cityLab];
    
    _statesImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 44, 15)];
    _statesImgV.image = IMAGE(@"lemon_zhibozhong");
    [self.contentView addSubview:_statesImgV];
    
    _viewerV = [[UIView alloc] initWithFrame:CGRectMake(W - 45, 10, 40, 13)];
    _viewerV.layer.cornerRadius = 3;
    _viewerV.layer.masksToBounds = YES;
    _viewerV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_viewerV];
    
    _viewerNumLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 25, 13)];
    _viewerNumLab.textColor = [UIColor whiteColor];
    _viewerNumLab.textAlignment = NSTextAlignmentCenter;
    _viewerNumLab.font = [UIFont systemFontOfSize:10];
    _viewerNumLab.adjustsFontSizeToFitWidth = YES;
    [_viewerV addSubview:_viewerNumLab];
    
    UIImageView *imgYz = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 12, 7)];
    imgYz.image = IMAGE(@"lemon_yz");
    [_viewerV addSubview:imgYz];
    
}

- (void)refreshUI:(TCShowLiveListItem *)item {
    NSString *imgStr = item.cover;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _nameLab.text = item.host.username;
    _cityLab.text = item.lbs.address;
    _viewerNumLab.text = [NSString stringWithFormat:@"%ld", (long)item.watchCount + 40];
}

@end
