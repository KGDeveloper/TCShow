//
//  TCGoodsManageModel.h
//  TCShow
//
//  Created by tangtianshi on 17/1/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoodsManageModel : NSObject

@property(nonatomic,strong)NSString * goods_id;//商品id
@property(nonatomic,strong)NSString * cat_id;//所属分类id
@property(nonatomic,strong)NSString * goods_name;//商品名称
@property(nonatomic,strong)NSString * click_count;//点击数 （暂不用）
@property(nonatomic,strong)NSString * store_count;//库存
@property(nonatomic,strong)NSString * comment_count;//评论数（暂不用）
@property(nonatomic,strong)NSString * weight;//商品重量（暂不用）
@property(nonatomic,strong)NSString * shop_price;//商品价格
@property(nonatomic,strong)NSString * shiping_price;//运费（暂不用）
@property(nonatomic,strong)NSString * goods_remark;//商品简介文字描述
@property(nonatomic,strong)NSString * goods_content;//商品详情图片
@property(nonatomic,strong)NSString * original_img;//商品图片（以分号隔开为多图）
@property(nonatomic,strong)NSString * is_real;//是否为实物
@property(nonatomic,strong)NSString * is_checked;//审核 0未通过 1通过（暂不用）
@property(nonatomic,strong)NSString * is_on_sale;//是否上架 0未上 1上架
@property(nonatomic,strong)NSString * is_free_shipping;//是否包邮0否1是
@property(nonatomic,strong)NSString * on_time;//上架时间
@property(nonatomic,strong)NSString * last_update;//最后修改时间（暂不用）
@property(nonatomic,strong)NSString * goods_type;//商品类型id
@property(nonatomic,strong)NSString * sales_sum;//销售量
@property(nonatomic,strong)NSString * prom_type;//活动类型（暂不用）
@property(nonatomic,strong)NSString * uid;//商品所属用户id
@property(nonatomic,strong)NSString * prom_id;//活动id （暂不用）


@end
