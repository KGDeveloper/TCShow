//
//  TCUserDetailController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCLiveUserList.h"
@interface TCUserDetailController : UITableViewController
@property(nonatomic,strong)IMAUser * user;
@property(nonatomic,strong)TCLiveUserList * userModel;
@end
