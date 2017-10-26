//
//  XRegisterView.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XRegisterView.h"

@implementation XRegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = VIEW_BACKGROUNDCOLOR;
        
        UIView *bgV = [self bgView];
        [self addSubview:bgV];
        
        [bgV addSubview:self.phoneT];
        [bgV addSubview:self.getCodeBtn];
        [bgV addSubview:self.codeT];
        [self addSubview:self.nextBtn];
        
    }
    return self;
}

// 背景view
-(UIView *)bgView{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 88)];
    bg.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<3; i++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*44, SCREEN_WIDTH, 1)];
        line.backgroundColor = BOARD_COLOR;
        [bg addSubview:line];
        
    }
    return bg;
}

// 手机号
-(MyTextField *)phoneT{
    
    if (_phoneT == nil) {
        _phoneT = [[MyTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 44) Label:@"+86" Placeholder:@"请输入手机号"];
        _phoneT.delegate = self;
        _phoneT.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneT;
}

// 验证码
-(MyTextField *)codeT{
    
    if (_codeT == nil) {
        _codeT = [[MyTextField alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 120, 44) Label:@"验证码" Placeholder:@"请输入验证码"];
        _phoneT.delegate = self;
    }
    return _codeT;
}

// 下一步
-(UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 182, SCREEN_WIDTH - 40, 44)];
        [_nextBtn setBackgroundColor:kNavBarThemeColor];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 5;
    }
    return _nextBtn;
}


// 获取验证码
-(UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        
        _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 7, 80, 30)];
        _getCodeBtn.backgroundColor = kNavBarThemeColor;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.layer.masksToBounds = YES;
        _getCodeBtn.layer.cornerRadius = 5;
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _getCodeBtn;
}


// textfield 代理 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
