//
//  GoodsListModel.m
//  TCShow
//
//  Created by  m, on 2017/9/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel

- (instancetype) initWithDictionsry:(NSMutableDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.good_size = dic[@"good_size"];
        self.store_count = dic[@"store_count"];
        
    }
    
    return self;
}

@end
