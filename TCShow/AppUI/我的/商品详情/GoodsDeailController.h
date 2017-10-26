//
//  GoodsDeailController.h
//  TCShow
//
//  Created by liberty on 2017/1/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDeailController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy)NSString * collectState;
@end
