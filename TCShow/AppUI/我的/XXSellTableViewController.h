//
//  XXSellTableViewController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
@interface XXSellTableViewController : UITableViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)NSString * goodsType;
@end
