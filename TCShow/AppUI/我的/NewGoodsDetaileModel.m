//
//  NewGoodsDetaileModel.m
//  TCShow
//
//  Created by  m, on 2017/8/29.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "NewGoodsDetaileModel.h"

@implementation NewGoodsDetaileModel

- (id) initWithDiction:(NSDictionary *)dic
{
    
//    self = [super init];
//
//    if (self) {
//        
//        [self setValuesForKeysWithDictionary:dic];
    
        _name = dic[@"name"];
        
        _myID = dic[@"id"];
//    }
    
    return self;
};

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    
//    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        
        _myID = value;
        
    }
    else
    {
        [super setValue:value forKey:key];
    }
    
}

@end
