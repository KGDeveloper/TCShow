//
//  XLoginViewController.h
//  live
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface XLoginViewController : BaseViewController<TencentSessionDelegate,TLSRefreshTicketListener,WXApiDelegate>

@end
