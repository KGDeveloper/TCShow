//
//  XXNoticeViewController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXNoticeViewController;

//定义代理协议
@protocol PassingValueDelegate<NSObject>

@required

-(void)sendArray:(NSArray *)arr type:(NSString *)type;



@end

@interface XXNoticeViewController : UIViewController

//定义代理
@property(nonatomic,weak)id<PassingValueDelegate>strDelegate;//通过代理传值

@end
