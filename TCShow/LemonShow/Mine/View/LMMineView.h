//
//  LMMineView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/14.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMMineView : UIView

@property (copy, nonatomic) void (^clickBlock)(NSInteger index);
@property (copy, nonatomic) void (^orderClickBlock)(NSInteger index);
@property (nonatomic,assign) NSString *leveString;
@property (nonatomic,assign) NSString *integral;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshView:(id)responseObject;

@end
