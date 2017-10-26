//
//  QZKNotiModel.m
//  TCShow
//
//  Created by Mac on 2017/10/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKNotiModel.h"

@implementation QZKNotiModel

- (instancetype)initWithNsdictionary:(NSDictionary *)dic
{
    if (!self) {
        self = [super init];
    }
    self.userName = dic[@"userName"];
    self.giftName = dic[@"giftName"];
    self.sendName = dic[@"sendName"];
    
    return self;
}

@end
