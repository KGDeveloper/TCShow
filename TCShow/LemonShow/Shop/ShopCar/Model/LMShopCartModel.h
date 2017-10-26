//
//  LMShopCartModel.h
//  TCShow
//
//  Created by 王孟 on 2017/8/24.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShopCartModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *goods_price;
@property (strong, nonatomic) NSString *shiping_price;
@property (strong, nonatomic) NSString *original_img;
@property (strong, nonatomic) NSString *member_goods_price;
@property (strong, nonatomic) NSString *goods_num;
@property (strong, nonatomic) NSString *bar_code;
@property (strong, nonatomic) NSString *selected;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *prom_type;
@property (strong, nonatomic) NSString *prom_id;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *good_standard_size;

@end
