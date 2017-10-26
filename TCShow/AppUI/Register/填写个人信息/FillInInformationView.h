//
//  FillInInformationView.h
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
@interface FillInInformationView : UIView<UITextFieldDelegate>
@property(nonatomic,strong)MyTextField *name;
@property (nonatomic,strong)MyTextField *password;
@property (nonatomic,strong)MyTextField *confirmPassword;
@property (nonatomic,strong)UIButton *nextBtn;
@end
