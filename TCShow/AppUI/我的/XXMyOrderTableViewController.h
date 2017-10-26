//
//  XXMyOrderTableViewController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface XXMyOrderTableViewController : UITableViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic,strong) NSString *orderType;

@end
