//
//  TCAllTableController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

//综合
#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
@interface TCAllTableController : UITableViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)NSString * searchName;
@end
