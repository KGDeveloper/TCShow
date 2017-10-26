//
//  TCSalesTableController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

//销量
#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
@interface TCSalesTableController : UITableViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)NSString * searchName;
@property(nonatomic,strong)NSString * searchType;
@end
