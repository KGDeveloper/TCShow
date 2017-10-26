//
//  XLoginViewController.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XLoginViewController.h"
#import "XLoginView.h"
#import "TCRegisterViewController.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "PrivacyController.h"
#import <ImSDK/ImSDK.h>
#import "IMALoginParam.h"
#import "LivingListViewController.h"
#import "AgreementController.h"
#import "TCForgetPasswordController.h"
@interface XLoginViewController ()<TLSExchangeTicketListener>
@property (nonatomic,strong)XLoginView  *loginView;
@property (nonatomic,strong)MBProgressHUD *HUD;
//@property (nonatomic,weak) id<TLSPwdLoginListener> delegate;
@end

@implementation XLoginViewController{
     __weak id<WXApiDelegate>    _tlsuiwx;
    NSString *_sig;
    IMALoginParam  *_loginParam;
    TencentOAuth   *_openQQ;
}

- (void)dealloc
{
    _tlsuiwx = nil;
    _openQQ = nil;
    
    [_loginParam saveToLocal];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)loadView{
    [super loadView];
    self.loginView = [[XLoginView alloc] initWithFrame:self.view.frame];
    self.loginView.backgroundColor = VIEW_BACKGROUNDCOLOR;
    self.view = self.loginView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAgreementLabelClick)];
    [self.loginView.userAgreementLabel addGestureRecognizer:tap];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"username"]&&[user objectForKey:@"password"]) {
        self.loginView.userNameT.text = [user objectForKey:@"username"];
        self.loginView.password.text = [user objectForKey:@"password"];
    }
}
- (void)autoLogin
{
    if ([_loginParam isExpired])
    {
        [[HUDHelper sharedInstance] syncLoading:@"刷新票据。。。"];
        //刷新票据
        [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
    }
    else
    {
        [self loginIMSDK];
    }
}
- (void)loginIMSDK
{
    //直接登录
    __weak XLoginViewController *weakSelf = self;
    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
        [weakSelf enterMainUI];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
//            [weakSelf pullLoginUI];
        }];
    }];
}
#pragma mark - 拉起登陆框
- (void)pullLoginUI{
    
}
- (void)enterMainUI
{
    _tlsuiwx = nil;
    _openQQ = nil;
    [[IMAAppDelegate sharedAppDelegate] enterMainUI];
    
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginView.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.changePasswordBtn addTarget:self action:@selector(changePasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (isAutoLogin)
    {
        _loginParam = [IMALoginParam loadFromLocal];
    }
    else
    {
        _loginParam = [[IMALoginParam alloc] init];
    }
    
    [IMAPlatform configWith:_loginParam.config];
    
    if (isAutoLogin && [_loginParam isVailed])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoLogin];
        });
    }
    else
    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self pullLoginUI];
//        });
        
    }
    
   
    
    
}


#pragma mark -- 注册
-(void)registerBtnClick{
    TCRegisterViewController *registerVC = [[TCRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark -- 找回密码
-(void)changePasswordBtnClick{
//
    TCForgetPasswordController *vc = [[TCForgetPasswordController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -- 登录
-(void)loginBtnClick{
    
    //参数判断
    if(![[Common sharedInstance] isValidateMobile:self.loginView.userNameT.text])
    {
        
        
        [[Common sharedInstance] shakeView:self.loginView.userNameT];
        
        return;
    }
    if([self.loginView.password.text  isEqualToString:@""])
    {
        [[Common sharedInstance] shakeView:self.loginView.password];
        
        return;
    }
    
    
    
    [self login];
    
}


-(void)login{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    [[Business sharedInstance] loginPhone:self.loginView.userNameT.text pass:self.loginView.password.text succ:^(NSString *msg, id datas) {
        NSDictionary *responseData = datas;
        NSData *user_data = [NSJSONSerialization dataWithJSONObject:responseData options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:user_data forKey:KEY_FOR_USER_INFO];
        [[NSUserDefaults standardUserDefaults] setObject:datas forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[Business sharedInstance] getTencentSign:self.loginView.userNameT.text succ:^(NSString *msg, id data) {
            _sig = data[@"sig"];
            TIMLoginParam *param = [[TIMLoginParam alloc]init];
            param.accountType = kSdkAccountType;
            param.identifier = self.loginView.userNameT.text;
            param.userSig = _sig;
            param.appidAt3rd = kSdkAppId;
            param.sdkAppId = [kSdkAppId intValue];
            [[TIMManager sharedInstance]login:param succ:^{
                hud.labelText = @"登录IM成功";
                hud.mode = MBProgressHUDModeCustomView;
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:self.loginView.userNameT.text forKey:@"username"];
                [user setObject:self.loginView.password.text forKey:@"password"];
                [user setObject:param.userSig forKey:@"userSig"];
                [user synchronize];
                //                    [self loginWithInfo];
                hud.hidden = YES;
                
                [SARUserInfo saveUserInfo:datas];
                [SARUserInfo saveRegistLogin:YES];
                //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                int ret = [[TLSHelper getInstance] TLSExchangeTicket:self.loginView.userNameT.text andUserSig:_sig andTLSExchangeTicketListener:self];
                if (ret == 0) {
                                                hud.hidden = YES;
                                                [self enterMainUI];
                    
                }
                //                    });
            } fail:^(int code, NSString *msg) {
                hud.labelText = @"登录IM失败";
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
            }];
        } fail:^(NSString *error) {
            hud.hidden = YES;
        }];
    } fail:^(NSString *error) {
        hud.labelText = @"登录失败";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
}
- (void)loginWithInfo
{
    _openQQ = nil;
    _tlsuiwx = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
     
            _loginParam.identifier = [user objectForKey:@"username"];
            _loginParam.userSig = [user objectForKey:@"userSig"];
            _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
        [user synchronize];
            // 获取本地的登录config
            [self loginIMSDK];
        
    });
}

// 登录成功回调
- (void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo
{
    
    /* 登录成功了，在这里可以获取用户票据*/
     [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
    

}

// 登录失败回调
- (void)OnSmsLoginTimeout:(TLSErrInfo *)errInfo
{
//    [_HUD hideText:errInfo.sErrorMsg atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
}

- (void)OnPwdLoginFail:(TLSErrInfo *)errInfo
{
//    [_HUD hideText:errInfo.sErrorMsg atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
}

#pragma mark -- 用户协议的点击事件
-(void)userAgreementLabelClick{
//    privarcyVC.viewTitle = @"用户协议";
    
    AgreementController *vc = [[AgreementController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = kNavBarThemeColor;
    [self presentViewController:nav animated:YES completion:nil];
}

// 登录注释
//- (void)OnSmsLoginVerifyCodeSuccess
//{
//    [[TLSLogin sharedInstance] loginCommit:self.accountTextField.text];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  刷新票据成功
 *  在此回调接口内，可以调用getSSOTicket获取A2等票据
 */
-(void)	OnExchangeTicketSuccess{
    
//   NSDictionary *dic = [[TLSHelper getInstance]getSSOTicket:self.loginView.userNameT.text];
    
    [self loginWithInfo];
}

/**
 *  刷新票据失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnExchangeTicketFail:(TLSErrInfo *)errInfo{

}

/**
 *  刷新票据超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnExchangeTicketTimeout:(TLSErrInfo *)errInfo{
}

@end
