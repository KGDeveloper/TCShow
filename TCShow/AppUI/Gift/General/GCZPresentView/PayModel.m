//
//  PayModel.m
//  TCShow
//
//  Created by wxt on 2017/6/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "PayModel.h"

@interface PayModel ()
{
    
}
@end

@implementation PayModel

@end
@implementation AllPays
+(NSArray <PayModel*> *)AllPays{
    static dispatch_once_t onceToken;
    static NSArray <PayModel*>* array;
    dispatch_once(&onceToken, ^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"giftType" ofType:@"plist"];
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
        array = [PayModel mj_objectArrayWithKeyValuesArray:data];
    });
    return array;
}
@end
