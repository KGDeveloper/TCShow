//
//  NewAddressViewController.h
//  tangtianshi
//
//  Created by tangtianshi on 16/2/25.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//



/**
 添加收货地址
 */
#import <UIKit/UIKit.h>

@interface NewAddressViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL isModify;
@property (strong, nonatomic) NSMutableArray *modifyArr;
@property (strong, nonatomic) NSMutableDictionary *arr;
@property (strong, nonatomic) NSString *aid;
@property (strong, nonatomic) NSString *provinceStr;
@property (strong, nonatomic) NSString *cityStr;
@property (strong, nonatomic) NSString *districtStr;
@property (nonatomic,assign)NSInteger selectDic;
@end





