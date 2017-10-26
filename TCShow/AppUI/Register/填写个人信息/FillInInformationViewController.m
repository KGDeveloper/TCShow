//
//  FillInInformationViewController.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 '. All rights reserved.
//

#import "FillInInformationViewController.h"
#import "FillInInformationView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Business.h"
#import "UserProtocolViewController.h"
#import "AppDelegate.h"

@interface FillInInformationViewController ()
@property (nonatomic,strong)FillInInformationView *informationView;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation FillInInformationViewController

-(void)loadView{
    [super loadView];
    self.informationView = [[FillInInformationView alloc] initWithFrame:self.view.frame];
    self.view = self.informationView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写个人信息";
    
//    _hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_hud];
//    [_hud show:YES];
//    _hud.hidden = YES;
    
    [self.informationView.nextBtn addTarget:self action:@selector(finishBtnClik) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}


#pragma mark -- 完成
-(void)finishBtnClik{
    
    if (![self checkFillInfoIsNull]) {
        return;
    }
    NSString *name = self.informationView.name.text;
    NSString *password = self.informationView.password.text;
    // 网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"phone":_registerPhone,@"nickname":name,@"password":password,@"code":@"1234"};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:REGISTER parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            hud.hidden = YES;
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

#pragma mark -- 检查输入项是否为nil
-(BOOL)checkFillInfoIsNull{
    
    
    NSString *name = self.informationView.name.text;
    NSString *password = self.informationView.password.text;
    NSString *confimP = self.informationView.confirmPassword.text;
    if (name == nil || [name isEqualToString:@""]) {
//        [_hud hideText:@"昵称不能为空~" atMode:MBProgressHUDModeText andDelay:1.0 andCompletion:nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"昵称不能为空~";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        return NO;
    }
    
    if (password == nil || [password isEqualToString:@""] ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请设置密码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [_hud hideText:@"请设置密码" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
        return NO;
    }else if ([password length]<8){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请输入不少于8位的密码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [_hud hideText:@"请输入不少于8位的密码" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
        return NO;
    }
    
    if (![password isEqualToString:confimP]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"两次密码不一致~";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [_hud hideText:@"两次密码不一致~" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
        return NO;
    }

    return YES;
}



@end
