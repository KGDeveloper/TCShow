//
//  IMB_ActionSheet.h
//  InvestChina
//
//  Created by 龚传赞 on 14-4-15.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AllGifts.h"

typedef void (^ClickBlock)(id sender,Gift *g, NSUInteger num);
typedef void (^payBlock)();

@interface GCZCustomView : UIView

@property(nonatomic,copy)ClickBlock cBlock;
@property(nonatomic,copy)payBlock pyBlock;


- (void)releaseResource;


@end

@interface GCZActionSheet : NSObject

@property (nonatomic, strong) UIView *mainView;

- (instancetype)initWithCustomView:(GCZCustomView *)view;

- (void)present:(ClickBlock)block;
-(void)pay:(payBlock)pay;
- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)touchDismissModel;
@end
