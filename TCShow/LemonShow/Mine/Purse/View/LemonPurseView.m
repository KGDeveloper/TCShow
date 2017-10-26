//
//  LemonPurseView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/9.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LemonPurseView.h"
#import "PayModel.h"

@implementation LemonPurseView {
    UIView *_btnbackV;
    UIButton *_wxPayBtn;
    PayModel *_selModel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = [NSArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _diamondsCoinsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH / 2, 30)];
    _diamondsCoinsLab.textAlignment = NSTextAlignmentCenter;
    _diamondsCoinsLab.textColor = RGB(255, 186, 21);
    _diamondsCoinsLab.font = [UIFont systemFontOfSize:14];
    _diamondsCoinsLab.text = @"0";
    [self addSubview:_diamondsCoinsLab];
    
    UILabel *diamondsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH / 2, 30)];
    diamondsLab.textAlignment = NSTextAlignmentCenter;
    diamondsLab.textColor = [UIColor lightGrayColor];
    diamondsLab.font = [UIFont systemFontOfSize:14];
    diamondsLab.text = @"我的钻石";
    [self addSubview:diamondsLab];
    
    _lemonCoinsLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 10, SCREEN_WIDTH / 2, 30)];
    _lemonCoinsLab.textAlignment = NSTextAlignmentCenter;
    _lemonCoinsLab.textColor = RGB(255, 186, 21);
    _lemonCoinsLab.font = [UIFont systemFontOfSize:14];
    _lemonCoinsLab.text = @"0";
    [self addSubview:_lemonCoinsLab];
    
    UILabel *lemonsLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 40, SCREEN_WIDTH / 2, 30)];
    lemonsLab.textAlignment = NSTextAlignmentCenter;
    lemonsLab.textColor = [UIColor lightGrayColor];
    lemonsLab.font = [UIFont systemFontOfSize:14];
    lemonsLab.text = @"我的柠檬币";
    [self addSubview:lemonsLab];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineV];
    
    UILabel *payLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, SCREEN_WIDTH / 2, 30)];
    payLab.textAlignment = NSTextAlignmentLeft;
    payLab.textColor = [UIColor lightGrayColor];
    payLab.font = [UIFont systemFontOfSize:14];
    payLab.text = @"钻石充值";
    [self addSubview:payLab];
    
    _btnbackV = [[UIView alloc] initWithFrame:CGRectMake(15, 140, SCREEN_WIDTH - 30, 130)];
    [self addSubview:_btnbackV];
    
    UILabel *note1Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 270, SCREEN_WIDTH - 30, 30)];
    note1Lab.textAlignment = NSTextAlignmentLeft;
    note1Lab.textColor = [UIColor lightGrayColor];
    note1Lab.font = [UIFont systemFontOfSize:14];
    note1Lab.text = @"* 注: 1元=10钻石";
    [self addSubview:note1Lab];
    
    UILabel *note2Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 300, SCREEN_WIDTH - 30, 40)];
    note2Lab.textAlignment = NSTextAlignmentLeft;
    note2Lab.textColor = [UIColor lightGrayColor];
    note2Lab.font = [UIFont systemFontOfSize:14];
    note2Lab.numberOfLines = 0;
    note2Lab.text = @"* 注: 充值成功后到账可能会有一定的延迟, 请耐心的等候. 若没有到账请及时与客服联系.";
    [self addSubview:note2Lab];
    
    _wxPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 350, SCREEN_WIDTH - 30, 40)];
    [_wxPayBtn setTitle:@"微信支付 ¥ 6.00" forState:UIControlStateNormal];
    _wxPayBtn.backgroundColor = LEMON_MAINCOLOR;
    _wxPayBtn.layer.cornerRadius = 5;
    _wxPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_wxPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wxPayBtn addTarget:self action:@selector(wxPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_wxPayBtn];
    
}

- (void)wxPayBtnClick:(id)sender {
    if (self.payBtnClickBlock) {
        self.payBtnClickBlock(_selModel);
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        _selModel = dataArray[0];
        for (int i = 0; i < dataArray.count; i++) {
            PayModel *model = dataArray[i];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:model.limo forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = i + 10;
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i % 2 == 0) {
                btn.frame = CGRectMake(15, i / 2 * 40, SCREEN_WIDTH / 2 - 60, 30);
            }else {
                btn.frame = CGRectMake(SCREEN_WIDTH / 2 + 15, (i - 1) / 2 * 40, SCREEN_WIDTH / 2 - 60, 30);
            }
            if (i == 0) {
                btn.layer.borderColor = RGB(255, 186, 21).CGColor;
                [btn setTitleColor:RGB(255, 186, 21) forState:UIControlStateNormal];
            }
            [_btnbackV addSubview:btn];
        }
        
    }
}

- (void)payBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i < _btnbackV.subviews.count; i++) {
        UIButton *btn1 = _btnbackV.subviews[i];
        if (btn.tag == btn1.tag) {
            btn1.layer.borderColor = RGB(255, 186, 21).CGColor;
            [btn1 setTitleColor:RGB(255, 186, 21) forState:UIControlStateNormal];
            PayModel *model = _dataArray[btn1.tag - 10];
            _selModel = model;
            NSRange range = [model.money rangeOfString:@"元"];
            NSString *monStr = [model.money substringToIndex:range.location];
            [_wxPayBtn setTitle:[NSString stringWithFormat:@"微信支付 ¥ %@.00", monStr] forState:UIControlStateNormal];
        }else {
            btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
}


@end
