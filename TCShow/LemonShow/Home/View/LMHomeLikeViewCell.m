//
//  LMHomeLikeViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/14.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeLikeViewCell.h"

@implementation LMHomeLikeViewCell {
    UIImageView *_iconImageV;
    UILabel *_nameLabel;
    UILabel *_coinsLabel;
    UILabel *_peopleLabel;
    UIImageView *_backImageV;
    UIImageView *_statesImgV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    _iconImageV.layer.cornerRadius = 15;
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.image = [UIImage imageNamed:@"zanwu"];
    [self.contentView addSubview:_iconImageV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 30)];
    _nameLabel.text = @"自挂东南枝";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 200, 30)];
    _coinsLabel.text = @"魅力值: 12352";
    _coinsLabel.font = [UIFont systemFontOfSize:12];
    _coinsLabel.textAlignment = NSTextAlignmentLeft;
    _coinsLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_coinsLabel];
    
    _peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110 , 15, 80, 30)];
    _peopleLabel.text = @"12352人观看";
    _peopleLabel.font = [UIFont systemFontOfSize:12];
    _peopleLabel.textAlignment = NSTextAlignmentRight;
    _peopleLabel.textColor = [UIColor lightGrayColor];
    _peopleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_peopleLabel];
    
    _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH - 30, SCREEN_WIDTH - 30)];
    _backImageV.image = [UIImage imageNamed:@"zanwu"];
    [self.contentView addSubview:_backImageV];
    
    _statesImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 44, 15)];
//    _statesImgV.image = IMAGE(@"lemon_zhibozhong");
    [_backImageV addSubview:_statesImgV];
    
}

- (void)refreshUI:(TCShowLiveListItem *)item {
    NSString *string = item.chatRoomId;
    if ([string isEqual:[NSNull null]] || string==nil) {
        //未开播
        NSString *imgStr = item.headsmall;
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_iconImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
        [_backImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
        _statesImgV.image = IMAGE(@"lemon_weizhibo");
        _peopleLabel.text = @"0人观看";
        _coinsLabel.text = [NSString stringWithFormat:@"魅力值: %@", item.charm];
        _nameLabel.text = item.nickname;
    }else {
        NSString *imgStr = item.host.avatar;
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_iconImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
        NSString *imgStr2 = item.cover;
        if ([imgStr2 rangeOfString:@"http"].location == NSNotFound) {
            imgStr2 = IMG_APPEND_PREFIX(imgStr2);
        }
        [_backImageV sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:IMAGE(@"zanwu")];
        _statesImgV.image = IMAGE(@"lemon_zhibozhong");
        
    
        _peopleLabel.text = [NSString stringWithFormat:@"%ld人观看",(long)item.watchCount + 40];
        _coinsLabel.text = [NSString stringWithFormat:@"魅力值: %@", item.charm];
        _nameLabel.text = item.host.username;
        if ([item.charm isEqual:[NSNull null]] || item.charm == nil) {
            _coinsLabel.hidden = YES;
        }else {
            _coinsLabel.hidden = NO;
        }
    }
}

@end
