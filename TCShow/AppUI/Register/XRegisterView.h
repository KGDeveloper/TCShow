//
//  XRegisterView.h
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
@interface XRegisterView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)MyTextField *phoneT;
@property (nonatomic,strong)MyTextField *codeT;
@property (nonatomic,strong)UIButton *getCodeBtn;
@property (nonatomic,strong)UIButton *nextBtn;
@end
