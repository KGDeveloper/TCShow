//
//  QZKChargeModel.m
//  TCShow
//
//  Created by  m, on 2017/9/27.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKChargeModel.h"

@implementation QZKChargeModel

- (instancetype)initWithNsdictionary:(NSDictionary *)dic
{
    if (!self) {
        
        self = [super init];
    }
    
    self.lemon_id = dic[@"lemon_id"];
    self.lemon_coins = dic[@"lemon_coins"];
    self.price = dic[@"price"];
    self.nums = dic[@"nums"];
    
    return self;
}

@end
