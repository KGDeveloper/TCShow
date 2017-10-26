//
//  RRMessageView.h
//  直播消息Demo
//
//  Created by gongcz on 16/5/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellModel.h"

@interface RRMessageView : UIView

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *datasource;

@end
