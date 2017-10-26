//
//  ShoppingModel.m
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingModel.h"


@implementation ShoppingModel

@synthesize headClickState;

@synthesize headPriceDict;

-(instancetype)initWithShopDict:(NSDictionary *)dict{
    
    self.headID = dict[@"headID"];
    
    self.headState = [dict[@"headState"] integerValue];
    
    self.discount  = dict[@"discount"];
    
    self.headCellArray = [NSMutableArray arrayWithArray:[self ReturnData:dict[@"headCellArray"]]];
    
    self.headClickState = 0;
    
    self.headPriceDict = [[NSDictionary alloc] init];
    self.headPriceDict = @{
                           @"headTitle":[NSString stringWithFormat:@"选择必选单品,即可享受%@折优惠",self.discount],
                           @"footerTitle":@"小计:¥0.00",
                           @"footerMinus":@""
                           };
    
    return self ;
}

-(NSArray *)ReturnData:(NSArray *)array{
    
    NSMutableArray *arrays= [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        
        ShoppingCellModel *model = [[ShoppingCellModel alloc] initWithShopDict:dict];
        [arrays addObject:model];

    }

    return arrays;
}


@end

@implementation ShoppingCellModel

@synthesize row;
@synthesize section;
@synthesize indexState;
@synthesize cellClickState;
@synthesize cellPriceDict;
@synthesize cellEditState;
-(instancetype)initWithShopDict:(NSDictionary *)dict{
    
    self.goods_id = dict[@"goods_id"];
    self.original_img = dict[@"original_img"];
    self.goods_name = dict[@"goods_name"];
//    self.color = dict[@"color"];
//    self.size = dict[@"size"];
    self.goods_price =dict[@"goods_price"];
//    self.mustInteger = [dict[@"mustInteger"] integerValue];
    self.goods_num = [dict[@"goods_num"] integerValue];
//    self.inventoryInt = [dict[@"inventoryInt"] integerValue];
    self.member_goods_price = dict[@"member_goods_price"];
    self.row = 0;
    self.section = 0;
    self.indexState = 0;
    self.cellClickState = 0;
    self.cellEditState = 0;
    self.cellPriceDict = [[NSDictionary alloc] init];
    return self ;
}

@end
