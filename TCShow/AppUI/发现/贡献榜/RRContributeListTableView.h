//
//  RRContributeListTableView.h
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MJBaseTableView.h"

@interface RRContributeListTableView : MJBaseTableView
@property (nonatomic,copy)NSString *headNumber;// 金币数量
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,copy)NSString * userID;//查看用户ID

@end
