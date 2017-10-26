//
//  XXPhoneBoundViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXPhoneBoundViewController.h"

@interface XXPhoneBoundViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *boundBtn;

@end

@implementation XXPhoneBoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"手机绑定";
    _phoneView.layer.cornerRadius = 5;
    _codeView.layer.cornerRadius = 5;
    _boundBtn.layer.cornerRadius = 5;
    _phoneBtn.layer.cornerRadius = 5;
    
    [_phoneBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    
}
// 获取验证码
- (IBAction)getCode:(id)sender {
}
// 绑定
- (IBAction)bound:(id)sender {
}



@end
