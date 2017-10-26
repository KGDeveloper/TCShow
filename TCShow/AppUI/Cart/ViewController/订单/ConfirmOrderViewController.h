//
//  ConfirmOrderViewController.h
//  FineQuality
//
//  Created by tangtianshi on 16/6/2.
//  Copyright © 2016年 QCWL. All rights reserved.
//

/**
 确认订单
 */
#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : UIViewController
@property (nonatomic,assign) BOOL isCart;  // 是否购物车
@property (nonatomic,strong) NSDictionary *goodsDic;
@property (nonatomic,assign) NSString * goods_num;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *spec;
@property (nonatomic,strong)NSArray *cartArray;
@property (nonatomic,strong)NSString * totalPrice;

@property (nonatomic,strong) NSString *ids;

// 整个数据
@property (nonatomic,strong) NSDictionary *dataDic;

@end
