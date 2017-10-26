//
//  QZKChargeTopModle.m
//  TCShow
//
//  Created by Mac on 2017/10/16.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKChargeTopModle.h"

@implementation QZKChargeTopModle

- (instancetype)initWithNsdictionary:(NSDictionary *)dic
{
    if (!self) {
        self = [super init];
    }
    self.title = [NSString stringWithString:dic[@"headsmall"]];
    self.nickname = [NSString stringWithString:dic[@"nickname"]];
    self.order_price = dic[@"order_price"];
    self.uid = dic[@"uid"];
    
    return self;
}

@end
