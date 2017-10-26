//
//  LMShopModel.h
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShopModel : NSObject

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *click_count;
@property (nonatomic, strong) NSString *store_count;
@property (nonatomic, strong) NSString *comment_count;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *shop_price;
@property (nonatomic, strong) NSString *shiping_price;
@property (nonatomic, strong) NSString *goods_remark;
@property (nonatomic, strong) NSString *goods_content;
@property (nonatomic, strong) NSString *original_img;
@property (nonatomic, strong) NSString *is_real;
@property (nonatomic, strong) NSString *is_checked;
@property (nonatomic, strong) NSString *is_on_sale;
@property (nonatomic, strong) NSString *is_free_shipping;
@property (nonatomic, strong) NSString *on_time;
@property (nonatomic, strong) NSString *last_update;
@property (nonatomic, strong) NSString *goods_type;
@property (nonatomic, strong) NSString *sales_sum;
@property (nonatomic, strong) NSString *prom_type;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *prom_id;

@end
