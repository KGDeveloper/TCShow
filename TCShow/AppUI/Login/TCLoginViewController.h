//
//  TCLoginViewController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "BaseViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface TCLoginViewController : BaseViewController<TencentSessionDelegate,TLSRefreshTicketListener,WXApiDelegate>

@property (nonatomic,assign) NSInteger isFirst;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtu;

@end
