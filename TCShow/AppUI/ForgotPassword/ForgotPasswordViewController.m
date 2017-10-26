//
//  ForgotPasswordViewController.m
//  live
//
//  Created by admin on 16/5/27.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "MyTextField.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
@interface ForgotPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)MyTextField *password;
@property (nonatomic,strong)MyTextField *confirmPassword;
@property (nonatomic,strong)UIButton *finishBtn;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation ForgotPasswordViewController


-(void)loadView{
    [super loadView];
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
    
    UIView *bgV = [self bgView];
    [self.view addSubview:bgV];
    
    [bgV addSubview:self.password];
    [bgV addSubview:self.confirmPassword];
    [self.view addSubview:self.finishBtn];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    [_hud hide:YES];
    
    [_finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 完成按钮
-(void)finishBtnClick{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.password.text.length < 7) {
        hud.labelText = @"请输入不少于8位的密码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return;
    }
    
    if ([self.password.text isEqualToString:self.confirmPassword.text]) {
        [[Business sharedInstance] pwdReset:self.password.text phoneNum:self.phone succ:^(NSString *msg, id data) {
            hud.labelText = @"修改成功";
            [SARUserInfo updateValue:self.password.text forKey:@"password"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        } fail:^(NSString *error) {
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
        } code:@"1234"];
        
    }else{
        hud.labelText = @"两次密码不一致";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        
    }
    
    
    
}

#pragma mark -- initView初始化View
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

// 密码
-(MyTextField *)password{
    
    if (_password == nil) {
        _password = [[MyTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 44) Label:@"密码" Placeholder:@"请设置不少于8位的密码"];
        _password.delegate = self;
        _password.secureTextEntry = YES;
        _password.clearButtonMode = UITextFieldViewModeAlways;
        
    }
    return _password;
}

// 确认密码
-(MyTextField *)confirmPassword{
    
    if (_confirmPassword == nil) {
        _confirmPassword = [[MyTextField alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 10, 44) Label:@"确认密码" Placeholder:@"请再次输入"];
        _confirmPassword.delegate = self;
        _confirmPassword.secureTextEntry = YES;
        _confirmPassword.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _confirmPassword;
}

// 下一步
-(UIButton *)finishBtn{
    if (_finishBtn == nil) {
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 182, SCREEN_WIDTH - 40, 44)];
        [_finishBtn setBackgroundColor:BTN_BACKGROUNDCOLOR];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 5;
    }
    return _finishBtn;
}


// textfield 代理 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark -- 重置密码的回调
//-(void)OnPwdResetCommitSuccess:(TLSUserInfo *)userInfo{
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_hud hide:YES];
//        //保存信息
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        [userdefault setObject:self.password.text forKey:@"password"];
//        [userdefault setObject:self.phone forKey:@"phone"];
//        XLoginViewController *login = [[XLoginViewController alloc]init];
//        [self.navigationController pushViewController:login animated:YES];
//
//    });
//    
//}
//
//-(void)OnPwdResetFail:(TLSErrInfo *)errInfo{
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [_hud hideText:errInfo.sErrorMsg atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
//    });
//}

@end
