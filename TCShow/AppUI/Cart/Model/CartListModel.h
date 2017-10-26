//
//  CartListModel.h
//  tangtianshi
//
//  Created by tangtianshi on 16/4/1.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartListModel : NSObject

@property (strong, nonatomic) NSString *cart_id; // 购物车ID
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_num;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *original_img;
@property (strong, nonatomic) NSString *goods_price;
@property (strong, nonatomic) NSString *good_standard_size;
@property (assign, nonatomic) BOOL isSelect;
//@property (nonatomic,strong) NSString *goodsSpec;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
