//
//  TCTariffTableController.h
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
@interface TCTariffTableController : UITableViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)NSString * searchName;
@property(nonatomic,strong)NSString * searchType;
@end
