//
//  FillInInformationView.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "FillInInformationView.h"

@implementation FillInInformationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = VIEW_BACKGROUNDCOLOR;
        
        UIView *bgV = [self bgView];
        [self addSubview:bgV];
        
        [bgV addSubview:self.name];
        [bgV addSubview:self.password];
        [bgV addSubview:self.confirmPassword];
        [self addSubview:self.nextBtn];
        
    }
    return self;
}

// 背景view
-(UIView *)bgView{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 132)];
    bg.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<4; i++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*44, SCREEN_WIDTH, 1)];
        line.backgroundColor = BOARD_COLOR;
        [bg addSubview:line];
        
    }
    return bg;
}

// 手机号
-(MyTextField *)name{
    
    if (_name == nil) {
        _name = [[MyTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 44) Label:@"昵称" Placeholder:@"主人取个名字吧"];
        _name.delegate = self;
        _name.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _name;
}
// 密码
-(MyTextField *)password{
    
    if (_password == nil) {
        _password = [[MyTextField alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH-10, 44) Label:@"密码" Placeholder:@"请输入不少于8位的密码"];
        _password.delegate = self;
        _password.clearButtonMode = UITextFieldViewModeAlways;
        _password.secureTextEntry = YES;
    }
    return _password;
}

// 设置密码
-(MyTextField *)confirmPassword{
    
    if (_confirmPassword == nil) {
        _confirmPassword = [[MyTextField alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH-10, 44) Label:@"确认密码" Placeholder:@"请再次输入"];
        _confirmPassword.delegate = self;
        _confirmPassword.clearButtonMode = UITextFieldViewModeAlways;
        _confirmPassword.secureTextEntry = YES;
    }
    return _confirmPassword;
}

// 下一步
-(UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 226, SCREEN_WIDTH - 40, 44)];
        [_nextBtn setBackgroundColor:BTN_BACKGROUNDCOLOR];
        [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 5;
    }
    return _nextBtn;
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
