//
//  LemonPurseView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/9.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKExchangeView.h"
#import "PayModel.h"

@implementation QZKExchangeView {
    UIView *_btnbackV;
    UIButton *_wxPayBtn;
    PayModel *_selModel;
    UIButton *payLab;
    UILabel *msgLabel;
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
    lemonsLab.text = @"我的积分";
    [self addSubview:lemonsLab];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineV];
    
    payLab = [[UIButton alloc] initWithFrame:CGRectMake(15, 90, 100, 30)];
    payLab.backgroundColor = [UIColor lightGrayColor];
    [payLab setTitle:@"积分兑换" forState:UIControlStateNormal];
    payLab.titleLabel.textAlignment = NSTextAlignmentCenter;
    [payLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payLab.titleLabel.font = [UIFont systemFontOfSize:14];
    payLab.layer.cornerRadius = 5.0f;
    payLab.layer.borderWidth = 1.0f;
    payLab.layer.borderColor = [[UIColor whiteColor] CGColor];
    payLab.layer.masksToBounds = YES;
    [payLab addTarget:self action:@selector(payLabDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:payLab];
    
    msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 95, self.frame.size.width - 200, 20)];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.font = [UIFont systemFontOfSize:12];
    msgLabel.text = @"（点击切换到兑换钻石）";
    [self addSubview:msgLabel];
    
    _btnbackV = [[UIView alloc] initWithFrame:CGRectMake(15, 140, SCREEN_WIDTH - 30, 130)];
    [self addSubview:_btnbackV];
    
    UILabel *note1Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 270, SCREEN_WIDTH - 30, 30)];
    note1Lab.textAlignment = NSTextAlignmentLeft;
    note1Lab.textColor = [UIColor lightGrayColor];
    note1Lab.font = [UIFont systemFontOfSize:14];
    note1Lab.text = @"* 注: 1积分=1钻石";
    [self addSubview:note1Lab];
    
    UILabel *note2Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 300, SCREEN_WIDTH - 30, 40)];
    note2Lab.textAlignment = NSTextAlignmentLeft;
    note2Lab.textColor = [UIColor lightGrayColor];
    note2Lab.font = [UIFont systemFontOfSize:14];
    note2Lab.numberOfLines = 0;
    note2Lab.text = @"* 注: 兑换成功后到账可能会有一定的延迟, 请耐心的等候. 若没有到账请及时与客服联系.";
    [self addSubview:note2Lab];
    
    _wxPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 350, SCREEN_WIDTH - 30, 40)];
    [_wxPayBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    _wxPayBtn.backgroundColor = LEMON_MAINCOLOR;
    _wxPayBtn.layer.cornerRadius = 5;
    _wxPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_wxPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wxPayBtn addTarget:self action:@selector(wxPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_wxPayBtn];
    
    self.userNumber = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 30, 220, SCREEN_WIDTH / 2 - 60, 30)];
    self.userNumber.textColor = [UIColor grayColor];
    self.userNumber.textAlignment = NSTextAlignmentCenter;
    self.userNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.userNumber.layer.cornerRadius = 5.0f;
    self.userNumber.layer.borderWidth = 1.0f;
    self.userNumber.layer.borderColor = [[UIColor grayColor] CGColor];
    self.userNumber.placeholder = @"请输入兑换值";
    [self.userNumber addTarget:self action:@selector(textFieldTouchDown:) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:self.userNumber];
    
}

- (void) textFieldTouchDown:(UITextField *)textField
{
    textField.layer.borderColor = RGB(255, 186, 21).CGColor;
    textField.textColor = RGB(255, 186, 21);
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([payLab.titleLabel.text isEqualToString:@"积分兑换"]) {
        
        [_wxPayBtn setTitle:[NSString stringWithFormat:@"兑换%@",self.userNumber.text] forState:UIControlStateNormal];
    }
    else
    {
        [_wxPayBtn setTitle:[NSString stringWithFormat:@"兑换%@",self.userNumber.text] forState:UIControlStateNormal];
    }
    
    [self.userNumber resignFirstResponder];
}

- (void)payLabDidTouchDown:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"积分兑换"]) {
        
        [sender setTitle:@"钻石兑换" forState:UIControlStateNormal];
        
        for (id btu in [_btnbackV subviews]) {
            
            UIButton *searchBut = (UIButton *)btu;
            
            if (searchBut.tag >= 10 && searchBut.tag < 16) {
                
                NSString *title = [searchBut.titleLabel.text stringByReplacingOccurrencesOfString:@"积分" withString:@"钻石"];
                [searchBut setTitle:title forState:UIControlStateNormal];
                
                
            }
            msgLabel.text = @"点击切换到兑换积分";
            
            [_btnbackV setNeedsLayout];
            [_btnbackV layoutIfNeeded];
            [_btnbackV layoutSubviews];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            [self layoutSubviews];
            
        }
    }
    else
    {
        [sender setTitle:@"积分兑换" forState:UIControlStateNormal];
        
        for (id btu in [_btnbackV subviews]) {
            
            UIButton *searchBut = (UIButton *)btu;
            
            if (searchBut.tag >= 10 && searchBut.tag < 16) {
                
                NSString *title = [searchBut.titleLabel.text stringByReplacingOccurrencesOfString:@"钻石" withString:@"积分"];
                [searchBut setTitle:title forState:UIControlStateNormal];
                
            }
            
            [self setDataArray:_dataArray];
            msgLabel.text = @"点击切换到兑换钻石";
            
            [_btnbackV setNeedsLayout];
            [_btnbackV layoutIfNeeded];
            [_btnbackV layoutSubviews];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            [self layoutSubviews];
        }
    }
}

- (void) exchangeIntegral:(NSString *)number
{
    if ([_diamondsCoinsLab.text integerValue] >= [number integerValue]) {
        [[Business sharedInstance] userConisIntegral:[SARUserInfo userId] diamonds_coins:number succ:^(NSString *msg, id data) {
            [[HUDHelper sharedInstance] tipMessage:@"兑换成功"];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:error];
        }];
    }else{
        [[HUDHelper sharedInstance]tipMessage:@"钻石不足,请先充值！"];
    }
}

- (void) exchangeDiamonds:(NSString *)number
{
    if ([_lemonCoinsLab.text integerValue] >= [number integerValue]) {
        [[Business sharedInstance] userIntegralConis:[SARUserInfo userId] integral:number succ:^(NSString *msg, id data) {
            [[HUDHelper sharedInstance] tipMessage:@"兑换成功"];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:error];
        }];
    }else{
       [[HUDHelper sharedInstance]tipMessage:@"积分不足,请先充值！"];
    }
}


- (void)wxPayBtnClick:(UIButton *)sender {
    
    if ([payLab.titleLabel.text isEqualToString:@"积分兑换"]) {
        
        if ([sender.titleLabel.text isEqualToString:@"立即兑换"]) {
            [self exchangeIntegral:[NSString stringWithFormat:@"%d",[self.userNumber.text integerValue]]];
            
        }
        else
        {
            NSArray *tmp = [sender.titleLabel.text componentsSeparatedByString:@"兑换"];
            NSArray *lastArr = [[tmp lastObject] componentsSeparatedByString:@"积分"];
            self.number = [lastArr firstObject];
            
            [self exchangeIntegral:self.number];
        }
        
        
    }
    else
    {
        if ([sender.titleLabel.text isEqualToString:@"立即兑换"]) {
            [self exchangeDiamonds:[NSString stringWithFormat:@"%d",[self.userNumber.text integerValue]]];
        }
        else
        {
            NSArray *tmp = [sender.titleLabel.text componentsSeparatedByString:@"兑换"];
            NSArray *lastArr = [[tmp lastObject] componentsSeparatedByString:@"钻石"];
            self.number = [lastArr firstObject];
            [self exchangeDiamonds:self.number];
        }
        
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;

        for (int i = 0; i < dataArray.count; i++) {
            
            UIButton *btn = [[UIButton alloc] init];
            
            if ([payLab.titleLabel.text isEqualToString:@"积分兑换"]) {
                
               [btn setTitle:[NSString stringWithFormat:@"%@积分",_dataArray[i]] forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"%@钻石",_dataArray[i]] forState:UIControlStateNormal];
            }
            
            
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
        self.userNumber.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.userNumber.textColor = [UIColor lightGrayColor];
        if (btn.tag == btn1.tag) {
            btn1.layer.borderColor = RGB(255, 186, 21).CGColor;
            [btn1 setTitleColor:RGB(255, 186, 21) forState:UIControlStateNormal];
          
            if ([payLab.titleLabel.text isEqualToString:@"积分兑换"]) {
                [_wxPayBtn setTitle:[NSString stringWithFormat:@"兑换%@",btn1.titleLabel.text] forState:UIControlStateNormal];
            }
            else
            {
                [_wxPayBtn setTitle:[NSString stringWithFormat:@"兑换%@",btn1.titleLabel.text] forState:UIControlStateNormal];
            }
            
        }else {
            btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
}


@end
