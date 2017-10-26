//
//  TCShowLiveUSerDeatilView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/5.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCLiveUserList;

@interface TCShowLiveUSerDeatilView : UIView

@property (nonatomic, copy) void (^clickSendMsgBtnBlock)(TCLiveUserList *user);

- (instancetype)initWithUser:(TCLiveUserList *)user;

@end
