//
//  TCRegisterViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/9.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCRegisterViewController.h"
#import "CheckNumInput.h"
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
#import <CoreText/CoreText.h>
#import "AgreementController.h"
#import "MyTextField.h"
@interface TCRegisterViewController (){
    NSTimeInterval expireTimeInterval_;
}
@property (nonatomic,copy)NSString *phoneStr;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomView;
@property (strong, nonatomic) IBOutlet MyTextField *userName;
@property (strong, nonatomic) IBOutlet MyTextField *passWord;
@property (strong, nonatomic) IBOutlet MyTextField *againPassWord;
@property (strong, nonatomic) IBOutlet MyTextField *phone;
@property (strong, nonatomic) IBOutlet MyTextField *code;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
- (IBAction)codeClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *agreenButton;
@property (strong, nonatomic) IBOutlet UILabel *agreement;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)registerClick:(UIButton *)sender;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int timeCount;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation TCRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    _hud.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    for (UIView * view in _bottomView) {
        [view cornerViewWithRadius:10];
        [view addBorderWithWidth:1.0 color:RGBA(213, 213, 213, 1.0)];
    }
    [self.codeButton cornerViewWithRadius:10];
    [self.registerButton cornerViewWithRadius:10];
    
    NSString *str = @"《服务协议》";
    _agreement.userInteractionEnabled = YES;
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:str];
    [labelText addAttribute:NSForegroundColorAttributeName value:LEMON_MAINCOLOR range:NSMakeRange(0, 6)];
    [labelText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:NSMakeRange(0, 6)];
    [labelText addAttribute:NSStrokeColorAttributeName value:LEMON_MAINCOLOR range:NSMakeRange(0, 6)];
    _agreement.attributedText = labelText;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAgreement)];
    [self.agreement addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self registKeyBoardNoti];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self removeKeyBoardNoti];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -----获取验证码
- (IBAction)codeClick:(UIButton *)sender {
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
- (IBAction)registerClick:(UIButton *)sender {
    if (![self checkPhoneIsNull]) {
        
        return;
    }
    if (![self.passWord.text isEqualToString:self.againPassWord.text]) {
        return;
    }
    if (self.userName.text.length == 0) {
        return;
    }
//    if (self.code.text.length == 0) {
//        return;
//    }
    // 网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"phone":self.phone.text,@"nickname":self.userName.text,@"password":self.passWord.text,@"code":@"1234"};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:REGISTER parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            hud.hidden = YES;
            [[HUDHelper sharedInstance] tipMessage:@"注册成功"];
            [SARUserInfo saveUserPassword:_passWord.text];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
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

#pragma mark ------textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self moveView:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneStr = self.phone.text;
    if ([self.phoneStr rangeOfString:@"-"].location != NSNotFound) {
        self.phoneStr = [self.phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSMutableString *phoneStr = [[NSMutableString alloc] initWithString:self.phoneStr];
    if (phoneStr.length > 4) {
        [phoneStr insertString:@"-" atIndex:4];
    }
    if (phoneStr.length>8) {
        [phoneStr insertString:@"-" atIndex:8];
    }
    
    self.phone.text = phoneStr;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self moveView:NO];
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveView:NO];
    [self.view endEditing:YES];
}

// 移动view
-(void)moveView:(BOOL)yesOrNo{
    
    float movedistance=0;
    
    if (yesOrNo) {
        movedistance = -140;
    }else{
        movedistance = 0;
    }
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = CGRectMake(0,movedistance, self.view.frame.size.width, self.view.frame.size.height);
    } completion:NULL];
}



#pragma mark  ------------tapAgreement 服务协议
-(void)tapAgreement{
    AgreementController *vc = [[AgreementController alloc] init];
    vc.title = @"服务协议";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
