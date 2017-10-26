//
//  EditCartView.h
//  TDS
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCartViewDelegate <NSObject>

-(void)EditCartView:(NSInteger)num;

-(void)EditCartView;

@end

@interface EditCartView : UIView

@property (nonatomic, weak) id<EditCartViewDelegate>delegate;

@property(nonatomic, assign) NSInteger numInteger;

@property(nonatomic, strong) NSString *styleString;

@property(nonatomic, assign) NSInteger maxInteger;

@property (nonatomic, assign) NSInteger minInteget;

@end
