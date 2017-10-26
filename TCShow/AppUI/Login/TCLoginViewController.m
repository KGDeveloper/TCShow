//
//  TCLoginViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCForgetPasswordController.h"
#import "TCRegisterViewController.h"
#import "Common.h"
#import "WXApi.h"
#import "PhoneViewController.h"

#define user_login_type @"user_login_type"
#define user_login_type_phone @"user_login_type_phone"
#define user_login_type_wexin @"user_login_type_wexin"

@interface TCLoginViewController ()<TLSExchangeTicketListener,UITextFieldDelegate>{
    __weak id<WXApiDelegate>    _tlsuiwx;
    NSString *_sig;
    IMALoginParam  *_loginParam;
    TencentOAuth   *_openQQ;
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *loginView;
- (IBAction)forgetPassword:(UIButton *)sender;
- (IBAction)sinaLogin:(UIButton *)sender;
- (IBAction)resgisterClick:(UIButton *)sender;
@end

@implementation TCLoginViewController

- (void)dealloc
{
    _tlsuiwx = nil;
    _openQQ = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_loginParam saveToLocal];
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
    __weak TCLoginViewController *weakSelf = self;
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
    self.navigationController.navigationBar.backgroundColor = LEMON_MAINCOLOR;
    self.navigationController.navigationBar.barTintColor = LEMON_MAINCOLOR;//颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];//透明度
    self.title = @"登录";
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"TCLoginViewController" owner:self options:nil]lastObject];

    // 首先判断上一次登录类型
    NSUserDefaults * uuu = [NSUserDefaults standardUserDefaults];
    if ([[uuu valueForKey:user_login_type]isEqualToString:user_login_type_phone]) {
        [self changeViewUI];
    }else if ([[uuu valueForKey:user_login_type]isEqualToString:user_login_type_wexin]){
        [self wechatLoginByRequestForUserInfo];
    }
    
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
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatLoginByRequestForUserInfo) name:WXLogSUCC object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXinforFial) name:WXLogFail object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([WXApi isWXAppInstalled]) {
        //判断是否有微信
        self.weChatBtu.hidden = NO;
    }
    else
    {
        self.weChatBtu.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatLoginByRequestForUserInfo) name:WXLogSUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXinforFial) name:WXLogFail object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)changeViewUI{
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self.loginView cornerViewWithRadius:10];
    [self.loginView addBorderWithWidth:1.0 color:RGBA(206, 206, 206, 1.0)];
    [self.loginButton cornerViewWithRadius:10];
    self.lineLabel.backgroundColor = RGBA(197, 197, 197, 1.0);
    NSDictionary *user = [SARUserInfo gainUserInfo];
    if ([user objectForKey:@"phone"]) {
        self.phoneTextField.text = [user objectForKey:@"phone"];
    }
    if ([SARUserInfo gainUserPassword]) {
        self.passwordTextField.text = [SARUserInfo gainUserPassword];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginClick:(UIButton *)sender {
    //参数判断
    if(![[Common sharedInstance] isValidateMobile:self.phoneTextField.text])
    {
        [[Common sharedInstance] shakeView:self.phoneTextField];
        
        return;
    }
    if([self.passwordTextField.text isEqualToString:@""])
    {
        [[Common sharedInstance] shakeView:self.passwordTextField];
        return;
    }
    [self login];
}
-(void)loginIMWithPone:(NSString *)phone name:(NSString *)name{
    
    [[Business sharedInstance] getTencentSign:phone succ:^(NSString *msg, id data) {
        _sig = data[@"sig"];
        TIMLoginParam *param = [[TIMLoginParam alloc]init];
        param.accountType = kSdkAccountType;
        param.identifier = phone;
        param.userSig = _sig;
        param.appidAt3rd = kSdkAppId;
        param.sdkAppId = [kSdkAppId intValue];
        [[TIMManager sharedInstance]login:param succ:^{
            hud.labelText = @"登录IM成功";
            hud.mode = MBProgressHUDModeCustomView;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:param.userSig forKey:@"userSig"];
            [user synchronize];
            //                    [self loginWithInfo];
            hud.hidden = YES;
            
            //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int ret = 0;
//            int ret = [[TLSHelper getInstance] TLSExchangeTicket:phone andUserSig:_sig andTLSExchangeTicketListener:self];
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
}
-(void)loginWithPhone{
    [[Business sharedInstance] loginPhone:self.phoneTextField.text pass:self.passwordTextField.text succ:^(NSString *msg, id datas) {
        NSDictionary *responseData = datas;
        NSData *user_data = [NSJSONSerialization dataWithJSONObject:responseData options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:user_data forKey:KEY_FOR_USER_INFO];
        [[NSUserDefaults standardUserDefaults] setObject:user_data forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SARUserInfo saveUserInfo:datas];
        [SARUserInfo saveUserPassword:_passwordTextField.text];
        [SARUserInfo saveRegistLogin:YES];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.phoneTextField.text forKey:@"username"];
        [user setObject:self.passwordTextField.text forKey:@"password"];
        [user synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:user_login_type_phone forKey:user_login_type];
        NSString *namesss = [SARUserInfo nickName];
        [self loginIMWithPone:self.phoneTextField.text name:[SARUserInfo nickName]];
    } fail:^(NSString *error) {
        NSRange range = [error rangeOfString:@"永久封号"];
        hud.hidden = YES;
        if (range.location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
            
        }else {

            hud.labelText = @"登录失败";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
        }

    }];
}
-(void)loginWithWeXi{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";

    NSDictionary *  responseObject= [[NSUserDefaults standardUserDefaults] valueForKey:@"wexinInfo"];
    if (responseObject[@"errcode"] != nil) {
        hud.labelText = @"登录失败";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return;
    }
    
    NSMutableDictionary * dirstDic  = [NSMutableDictionary dictionaryWithDictionary:@{@"login_type":@"2",
                                                                                      @"nickname":[responseObject valueForKey:@"nickname"],
                                                                                      @"openid":[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID],
                                                                                      @"headsmall":[responseObject valueForKey:@"headimgurl" ]
                                                                                      }];
    NSString *sss = [responseObject valueForKey:@"nickname"];
    
    [[Business sharedInstance] IsFirstWithParam:dirstDic succ:^(NSString *msg, id data) {
        if ([[[data valueForKey:@"data"] valueForKey:@"is_first"] integerValue]==1) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userPhone"]) {
                [dirstDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userPhone"] forKey:@"phone"];
            }else{
                hud.hidden = YES;
                [self.navigationController pushViewController:[[PhoneViewController alloc]init] animated:YES];
                return ;
            }
        }
        [[Business sharedInstance] loginWithSthirdParam:dirstDic succ:^(NSString *msg, id data) {
            NSDictionary *responseData = data;
            NSData *user_data = [NSJSONSerialization dataWithJSONObject:responseData options:NSJSONWritingPrettyPrinted error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:user_data forKey:KEY_FOR_USER_INFO];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [SARUserInfo saveUserInfo:data];
            
            [self loginIMWithPone:[SARUserInfo userPhone] name:[SARUserInfo nickName]];
            [[NSUserDefaults standardUserDefaults] setValue:user_login_type_wexin forKey:user_login_type];
         
        } fail:^(NSString *error) {
            NSRange range = [error rangeOfString:@"永久封号"];
            
            if (range.location != NSNotFound) {
                hud.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];

            }else {
                hud.labelText = @"登录失败";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
            }
        }];
        
        
    } fail:^(NSString *error) {
        
    }];

}
-(void)login{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    [self loginWithPhone];
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


/**
 *  刷新票据成功
 *  在此回调接口内，可以调用getSSOTicket获取A2等票据
 */
-(void)	OnExchangeTicketSuccess{
    
    NSDictionary *dic = [[TLSHelper getInstance]getSSOTicket:self.phoneTextField.text];
    
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
- (void)wechatLoginByRequestForUserInfo {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", @"https://api.weixin.qq.com/sns", accessToken, openID];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    // 请求用户数据
    [manager GET:userUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setValue:responseObject forKey:@"wexinInfo"];
        [self loginWithWeXi];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(void)getWXinforFial{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"获取信息失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)forgetPassword:(UIButton *)sender {
    TCForgetPasswordController *vc = [[TCForgetPasswordController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sinaLogin:(UIButton *)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", @"https://api.weixin.qq.com/sns", MXWechatAPPID, refreshToken];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

        [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
//                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
                [self wechatLoginByRequestForUserInfo];
            }
            else {
                [self wechatLogin];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    else {
        [self wechatLogin];
    }
}
- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"GSTDoctorApp";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)resgisterClick:(UIButton *)sender {
    TCRegisterViewController *registerVC = [[TCRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
