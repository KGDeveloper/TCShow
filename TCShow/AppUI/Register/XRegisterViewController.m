//
//  XRegisterViewController.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XRegisterViewController.h"
#import "XRegisterView.h"
#import "FillInInformationViewController.h"
#import "ForgotPasswordViewController.h"
#import "CheckNumInput.h"
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
@interface XRegisterViewController ()
{
    NSTimeInterval expireTimeInterval_;
}
@property (nonatomic,strong)XRegisterView *registerView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int timeCount;
@property (nonatomic,copy)NSString *code;// 获取到的验证码
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,copy)NSString *userPhone;
@end

@implementation XRegisterViewController

-(void)loadView{
    [super loadView];
    self.registerView = [[XRegisterView alloc] initWithFrame:self.view.frame];
    self.view = self.registerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.type isEqualToString:@"找回密码"]) {
        self.title = self.type;
    }else{
        self.title = @"注册";
    }
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    _hud.hidden = YES;
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.registerView.getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside
     ];
    [self.registerView.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma meak -- 获取验证码
-(void)getCodeBtnClick{
    
    if (![self checkPhoneIsNull]) {
        return;
    }
    
//    [_hud showText:nil atMode:MBProgressHUDModeIndeterminate];
    if ([self.type isEqualToString:@"找回密码"]) {
        // 找回密码
        [self forgotPwd];
    }else{
        // 注册新用户
        [self registerUser];
    }
    
}

//倒计时
-(void)getCodeTime:(NSTimer *)timer{
    
    [self.registerView.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",self.timeCount] forState:UIControlStateNormal];
    self.registerView.getCodeBtn.backgroundColor = BOARD_COLOR;
    self.registerView.getCodeBtn.userInteractionEnabled = NO;
    
    if(self.timeCount > 0){
        self.timeCount --;
    }else{
        
        [self.timer invalidate];
        [self.registerView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.registerView.getCodeBtn.backgroundColor = BTN_BACKGROUNDCOLOR;
        self.registerView.getCodeBtn.userInteractionEnabled = YES;
        
    }
}
#pragma mark -- 下一步
-(void)nextBtnClick{
    [self.view endEditing:YES];
    if (![self checkPhoneIsNull]) {
        return;
    }
    
    //判断验证码是否正确
    // 验证码
//    self.code = self.registerView.codeT.text;
    self.code = @"1234";
    
    if (self.code) {
        if ([self.type isEqualToString:@"找回密码"]) {
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.labelText = @"";
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            NSDictionary *dic = @{@"phone":_userPhone,@"code":self.code,@"type":@"2"};
//            
//            [manager POST:VERIFY_CODE parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                // 验证成功
//                if(URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]){
//                    hud.hidden = YES;
//                    
                    ForgotPasswordViewController *FP = [[ForgotPasswordViewController alloc] init];
                    FP.phone = _userPhone;
                    [self.navigationController pushViewController:FP animated:YES];
//
//                    
//                }else{
//                    hud.labelText = [responseObject objectForKey:@"message"];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        hud.hidden = YES;
//                       
//                    });
//                  
//                }
//                
//            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                
//                hud.labelText = @"验证码不正确，请重新获取~" ;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    hud.hidden = YES;
//                   
//                });
//
//            }];
            
            
        }else{
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.labelText = @"";
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            NSDictionary *dic = @{@"phone":_userPhone,@"code":self.code};
//            
//            [manager POST:VERIFY_CODE parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                // 验证成功
//                if(URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]){
//                    hud.hidden = YES;
//                    
                    // 填写个人信息
                    FillInInformationViewController *vc = [[FillInInformationViewController alloc] init];
                    vc.registerPhone = _userPhone;
                    [self.navigationController pushViewController:vc animated:YES];
//
//                }else{
//                    hud.labelText = [responseObject objectForKey:@"message"] ;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        hud.hidden = YES;
//                    });
//                    
//                }
//                
//            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                
//                hud.labelText = @"验证码不正确，请重新获取~" ;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    hud.hidden = YES;
//                });
//            }];
            
            
        }
        
        
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请输入验证码" ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }
  
}

#pragma mark -- 检查手机号时候为空 和 时候正确
-(BOOL)checkPhoneIsNull{
    // 用户手机号
    self.userPhone = self.registerView.phoneT.text;
    // 判断手机号是否为nil
    if (_userPhone == nil || [_userPhone isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请填写手机号";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return NO;
    }else{
        // 检查是否为正确的手机号
        if(![CheckNumInput checkPhoneNumber:_userPhone]){
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

#pragma mark-- 忘记密码请求
-(void)forgotPwd{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"phone":_userPhone,@"type":@"2"};
    
    [manager POST:GET_CODE parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (URLREQUEST_SUCCESS == code) {
            // 获取成功
            self.timeCount = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeTime:) userInfo:nil repeats:YES];
            [self.timer fire];
            
            hud.labelText = @"验证码发送成功，30分钟内有效。";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            
        }else{
            // 手机号已被注册
            
            hud.labelText = [responseObject objectForKey:@"message"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        hud.labelText = @"请检查网络后重试！";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
    
}
#pragma mark -- 注册新用户 获取验证码
-(void)registerUser{
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

@end
