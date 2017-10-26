//
//  LMHomeTopSliderView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeTopSliderView.h"

@implementation LMHomeTopSliderView {
    UIView *_bottomLineV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _bottomLineV = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 3 + (self.bounds.size.width / 3 - 50) / 2, self.bounds.size.height - 1, 50, 1)];
    _bottomLineV.backgroundColor = LEMON_MAINCOLOR;
    [self addSubview:_bottomLineV];
    NSArray *titleArr= @[@"关注", @"推荐", @"最新"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width / 3) * i, 5, self.bounds.size.width / 3, 30)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = i + 10;
        if (i == 1) {
            [btn setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)BtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i < self.subviews.count; i++) {
        if ([self.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn1 = self.subviews[i];
            if (btn.tag == btn1.tag) {
                btn1.enabled = NO;
                [btn1 setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
                _bottomLineV.frame = CGRectMake((self.bounds.size.width / 3) * (btn1.tag - 10) + (self.bounds.size.width / 3 - 50) / 2, self.bounds.size.height - 1, 50, 1);
                
                if (self.btnClickBlock) {
                    self.btnClickBlock(btn1.tag - 10);
                    
                }
            }else {
                btn1.enabled = YES;
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

        }
    }
}

@end
