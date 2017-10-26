//
//  TCForgetPasswordController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/12.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCForgetPasswordController.h"
#import "MyTextField.h"
#import "CheckNumInput.h"
@interface TCForgetPasswordController (){
    NSTimeInterval expireTimeInterval_;
}
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIButton *forgetButton;
- (IBAction)codeButtonClick:(UIButton *)sender;
- (IBAction)forgetButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet MyTextField *phone;
@property (strong, nonatomic) IBOutlet MyTextField *code;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int timeCount;
@end

@implementation TCForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    for (UIView * view in _bottomView) {
        [view cornerViewWithRadius:10];
        [view addBorderWithWidth:1.0 color:RGBA(213, 213, 213, 1.0)];
    }
    [self.codeButton cornerViewWithRadius:10];
    [self.forgetButton cornerViewWithRadius:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ------获取验证码
- (IBAction)codeButtonClick:(UIButton *)sender {
    if (![self checkPhoneIsNull]) {
        return;
    }
    // 网络请求 获取验证码
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    NSDictionary *dic = @{@"phone":_userPhone};
    //
    //    [manager POST:GET_CODE parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
    //        if (URLREQUEST_SUCCESS == code) {
    //            // 获取成功
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeTime:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    hud.labelText = @"验证码发送成功，30分钟内有效。";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.hidden = YES;
    });
    //
    //        }else{
    //            // 手机号已被注册
    //
    //            hud.labelText = [responseObject objectForKey:@"message"];
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                hud.hidden = YES;
    //            });
    //        }
    //
    //    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    //        hud.labelText = @"请检查网络后重试！";
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            hud.hidden = YES;
    //        });
    //    }];

}


#pragma mark --------找回密码
- (IBAction)forgetButtonClick:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 判断手机号是否为nil
    if (self.phone.text == nil || [self.phone.text isEqualToString:@""]) {
        hud.labelText = @"请填写手机号";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return ;
    }
    if (self.password.text.length < 7) {
        hud.labelText = @"请输入不少于8位的密码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return;
    }
    if (self.code.text.length == 0) {
        hud.labelText = @"请输入验证码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return;
    }
    [[Business sharedInstance] pwdReset:self.password.text phoneNum:self.phone.text succ:^(NSString *msg, id data) {
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
}

#pragma mark -----验证码倒计时
-(void)getCodeTime:(NSTimer *)timer{
    
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒",self.timeCount] forState:UIControlStateNormal];
    self.codeButton.backgroundColor = BOARD_COLOR;
    self.codeButton.userInteractionEnabled = NO;
    
    if(self.timeCount > 0){
        self.timeCount --;
    }else{
        
        [self.timer invalidate];
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = YES;
    }
}


#pragma mark -- 检查手机号时候为空 和 时候正确
-(BOOL)checkPhoneIsNull{
    // 判断手机号是否为nil
    if (self.phone.text == nil || [self.phone.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请填写手机号";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return NO;
    }else{
        // 检查是否为正确的手机号
        if(![CheckNumInput checkPhoneNumber:self.phone.text]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"请填写正确的手机号";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            
            return NO;
        }
    }
    
    return YES;
}

// textfield 代理 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dealloc {
    _timer = nil;
}
@end
