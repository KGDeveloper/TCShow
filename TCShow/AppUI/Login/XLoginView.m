//
//  XLoginView.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XLoginView.h"
#import <CoreText/CoreText.h>
#import "PrivacyController.h"

@implementation XLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logoImg];
        [self addSubview:self.userNameT];
        [self addSubview:self.password];
        [self addSubview:self.loginBtn];
        [self addSubview:self.registerBtn];
        [self addSubview:self.changePasswordBtn];
        [self addSubview:self.userAgreementLabel];
        
    }
    return self;
}


-(UIImageView *)logoImg{
    if (_logoImg == nil) {
        _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 70, 100, 100)];
        _logoImg.image = [UIImage imageNamed:@"logo"];
    }
    return _logoImg;
}

-(MyTextField *)userNameT{
    
    if (_userNameT == nil) {
        UIImageView *nameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户名"]];
        _userNameT = [[MyTextField alloc] initWithFrame:CGRectMake(20, _logoImg.frame.origin.y + _logoImg.frame.size.height + 40, SCREEN_WIDTH - 40, 44) Icon:nameImg];
        _userNameT.placeholder = @"用户名/手机号";
        _userNameT.backgroundColor =[UIColor clearColor];
        _userNameT.layer.borderColor = BOARD_COLOR.CGColor;
        _userNameT.layer.borderWidth = 0.5;
        _userNameT.layer.masksToBounds = YES;
        _userNameT.layer.cornerRadius = 20;
        _userNameT.delegate = self;
        
    }
    return _userNameT;
}

-(MyTextField *)password{
    
    if (_password == nil) {
        
        UIImageView *passwordimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
        _password = [[MyTextField alloc] initWithFrame:CGRectMake(20, _userNameT.frame.origin.y + _userNameT.frame.size.height + 20, SCREEN_WIDTH - 40, 44) Icon:passwordimg];
        _password.placeholder = @"请输入密码";
        _password.backgroundColor = [UIColor clearColor];
        _password.layer.borderColor = BOARD_COLOR.CGColor;
        _password.layer.borderWidth = 0.5;
        _password.layer.masksToBounds = YES;
        _password.layer.cornerRadius = 20;
        _password.secureTextEntry = YES;
        _password.delegate = self;
    }
    return _password;
}

-(UIButton *)loginBtn {
    if (_loginBtn == nil) {
        
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _password.frame.origin.y + _password.frame.size.height + 40, SCREEN_WIDTH - 40, 45)];
        _loginBtn.backgroundColor = kNavBarThemeColor;
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 20;
        
    }
    return _loginBtn;
}


-(UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, _loginBtn.frame.origin.y + _loginBtn.frame.size.height + 20, 50, 40)];
        [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        
    }
    return _registerBtn;
}

-(UIButton *)changePasswordBtn{
    if(_changePasswordBtn == nil){
        _changePasswordBtn =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, _loginBtn.frame.origin.y + _loginBtn.frame.size.height + 20, 100, 40)];
        [_changePasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_changePasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    }
    return _changePasswordBtn;
}

-(UILabel *)userAgreementLabel{
    
    if (_userAgreementLabel == nil) {
        NSString *str = @"登录即代表你同意直播商城用户协议";
        CGSize sz =  [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:13.0f], NSFontAttributeName, nil]];
        _userAgreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - sz.width/2, self.frame.size.height - 50, sz.width, 20)];
        _userAgreementLabel.font = [UIFont systemFontOfSize:13];
        _userAgreementLabel.textColor = [UIColor grayColor];
        _userAgreementLabel.textAlignment = NSTextAlignmentCenter;
        _userAgreementLabel.userInteractionEnabled = YES;
        
        NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:str];
        [labelText addAttribute:NSForegroundColorAttributeName value:BTN_BACKGROUNDCOLOR range:NSMakeRange(8, 6)];
        [labelText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:NSMakeRange(8, 6)];
        [labelText addAttribute:NSStrokeColorAttributeName value:BTN_BACKGROUNDCOLOR range:NSMakeRange(8, 6)];
        
        _userAgreementLabel.attributedText = labelText;
        [_userAgreementLabel sizeToFit];
        
    }
    return _userAgreementLabel;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
