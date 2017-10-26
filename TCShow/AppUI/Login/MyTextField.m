//
//  MyTextField.m
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

//-(CGRect)leftViewRectForBounds:(CGRect)bounds{
//    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x += 10;
//    return iconRect;
//}
//
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x += 1;
    return placeholderRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 10;
    return editingRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

-(instancetype)initWithFrame:(CGRect)frame Icon:(UIImageView *)icon{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
        [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLaber.textColor"];
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame Label:(UILabel *)label{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftView = label;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}


-(instancetype)initWithFrame:(CGRect)frame Label:(NSString *)labelText Placeholder:(NSString *)placeText{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = labelText;
        
        self.leftView = label;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.placeholder = placeText;
        self.font = [UIFont systemFontOfSize:16];
        
    }
    
    return self;
    
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x +=10;
    return iconRect;
    
}
@end
