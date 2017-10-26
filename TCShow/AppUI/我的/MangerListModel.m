//
//  MangerListModel.m
//  TCShow
//
//  Created by  m, on 2017/9/4.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "MangerListModel.h"

@implementation MangerListModel

- (instancetype) initWithDictionary:(NSMutableDictionary *)dic
{
    self = [super init];
    
    if (self) {
        NSMutableArray *tmp = [NSMutableArray array];
        tmp = dic[@"goods_list"];
        
        
        for (int i = 0; i < tmp.count; i++) {
            
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
            tmpDic = tmp[i];
            self.goods_name = tmpDic[@"goods_name"];
            self.goods_num = tmpDic[@"goods_num"];
            self.goods_price = tmpDic[@"goods_price"];
            self.original_img = tmpDic[@"original_img"];


            
        }
        self.order_sn = dic[@"order_sn"];
        self.shipping_code = dic[@"shipping_code"];
        self.shipping_name = dic[@"shipping_name"];
        self.address = dic[@"address"];
        self.order_status_desc = dic[@"order_status_desc"];
        self.order_id = dic[@"order_id"];
        self.status = dic[@"status"];
        self.ID = dic[@"id"];
    }
    
    return self;
}



@end
