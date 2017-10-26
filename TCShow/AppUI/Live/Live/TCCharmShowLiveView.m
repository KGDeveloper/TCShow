//
//  TCCharmShowLiveView.m
//  TCShow
//
//  Created by 王孟 on 2017/7/28.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCCharmShowLiveView.h"

//===========================这里是显示魅力值的===============================
@implementation TCCharmShowLiveView {
    UILabel *_charmLab;
    UIImageView *_imgV2;
}

- (instancetype)initWithRoom:(TCShowLiveListItem *)room {
    if (self = [super initWithFrame:CGRectZero]) {
        _room = room;
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postStarsCoins) name:@"giftChangeCharms" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createUI {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
//    UIView *v = [[UIView alloc] initWithFrame:self.frame];
////    v.alpha = 0.9;
//    v.backgroundColor = [UIColor whiteColor];
//    [self addSubview:v];
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.5;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 15, 12)];
    imgV.image = [UIImage imageNamed:@"diamond_img"];
    [self addSubview:imgV];
    
    _charmLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 20)];
    _charmLab.text = @"";
    _charmLab.textColor = [UIColor orangeColor];
    _charmLab.font = [UIFont systemFontOfSize:12];
    _charmLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_charmLab];
    
    _imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(175, 3, 15, 15)];
    _imgV2.image = [UIImage imageNamed:@"youjianjinru"];
    [self addSubview:_imgV2];
    
    [self postStarsCoins];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)tap:(id)sender {
    if (self.charmViewClickBlack) {
        self.charmViewClickBlack();
    }
}

//这里显示魅力值
- (void)postStarsCoins {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_room liveHostId] forKey:@"uid"];
    
    [[Business sharedInstance] postStarsCoinsWithParam:params succ:^(NSString *msg, id data) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        _charmLab.text = [NSString stringWithFormat:@"魅力值: %@", data[@"lemon_coins"]];
        CGSize textSize = [_charmLab.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        _charmLab.frame = CGRectMake(25, 0, textSize.width, 20);
        _imgV2.frame = CGRectMake(28 + textSize.width, 4, 12, 12);
        self.frame = CGRectMake(10 , 70, textSize.width + 45, 20);
    } fail:^(NSString *error) {
    }];
}

@end
