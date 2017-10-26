//
//  XLoginView.h
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
@interface XLoginView : UIView<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView *logoImg;// logo图片
@property (nonatomic,strong)MyTextField *userNameT;// 用户名
@property (nonatomic,strong)MyTextField *password;// 密码
@property (nonatomic,strong)UIButton *loginBtn;//登陆
@property (nonatomic,strong)UIButton *registerBtn;// 注册
@property (nonatomic,strong)UIButton *changePasswordBtn;// 忘记密码
@property (nonatomic,strong)UILabel *userAgreementLabel;// 用户协议
@end
