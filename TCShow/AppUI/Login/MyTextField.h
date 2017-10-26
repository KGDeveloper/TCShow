//
//  MyTextField.h
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextField : UITextField
-(instancetype)initWithFrame:(CGRect)frame Icon:(UIImageView *)icon;
-(instancetype)initWithFrame:(CGRect)frame Label:(UILabel *)label;
-(instancetype)initWithFrame:(CGRect)frame Label:(NSString *)labelText Placeholder:(NSString *)placeText;
@end
