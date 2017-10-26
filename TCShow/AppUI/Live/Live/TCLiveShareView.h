//
//  TCLiveShareView.h
//  TCShow
//
//  Created by tangtianshi on 16/12/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCLiveShareView : UIView
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *sinaShare;
@property (weak, nonatomic) IBOutlet UIView *qqShare;
@property (weak, nonatomic) IBOutlet UIView *spaceShare;
@property (weak, nonatomic) IBOutlet UIView *wechatShare;
@property (nonatomic,copy)void(^shareItem)(NSInteger);
@property (nonatomic, assign) BOOL isWhiteMode;
@end
