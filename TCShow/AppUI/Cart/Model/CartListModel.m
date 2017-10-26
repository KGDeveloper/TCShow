//
//  CartListModel.m
//  tangtianshi
//
//  Created by tangtianshi on 16/4/1.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "CartListModel.h"

@implementation CartListModel
/*@property (strong, nonatomic) NSString *ID;
 @property (strong, nonatomic) NSString *uid;
 @property (strong, nonatomic) NSString *gooddid;
 @property (strong, nonatomic) NSString *nums;
 @property (strong, nonatomic) NSString *goodtitle;
 @property (strong, nonatomic) NSString *goodpicture;
 @property (strong, nonatomic) NSString *goodprice;
 @property (assign, nonatomic) BOOL isSelect;*/
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
//        _ID = dict[@"id"];
//        _uid = dict[@"uid"];
        _goods_id = dict[@"goods_id"];  // 商品id
        _goods_num = dict[@"goods_num"];
        _goods_name = dict[@"goods_name"];
        _original_img = dict[@"original_img"];
        _goods_price = dict[@"goods_price"];
        _isSelect = [dict[@"selected"] boolValue];
        _cart_id = dict[@"id"];
        _good_standard_size = dict[@"good_standard_size"];
//        _goodsSpec = dict[@"spec_key_name"];
//        _goodname = dict[@"goodname"];
        
    }
    return self;
}
@end
