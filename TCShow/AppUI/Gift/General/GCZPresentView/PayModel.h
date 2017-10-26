//
//  PayModel.h
//  TCShow
//
//  Created by wxt on 2017/6/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

/**
 钻石
 */
@property(nonatomic,copy)NSString * money;
/**
 轿车
 */
@property(nonatomic,copy)NSString * limo;
/**
 描述
 */
@property(nonatomic,copy)NSString * mark;
/**
 应付金额
 */
@property(nonatomic,copy)NSString * payMoney;

@end
@interface AllPays : NSObject
+(NSArray <PayModel*> *)AllPays;
@end
