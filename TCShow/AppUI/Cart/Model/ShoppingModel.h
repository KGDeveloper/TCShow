//
//  ShoppingModel.h
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ShoppingModel : NSObject

@property (nonatomic, copy) NSDictionary *headPriceDict;

//头部 id
@property (nonatomic, copy) NSString *headID;

//头部 状态
@property (nonatomic, assign) NSInteger headState;

//头部 选中状态
@property (nonatomic, assign) NSInteger headClickState;

//分组数据
@property (nonatomic, copy) NSMutableArray *headCellArray;

//折扣力度（head）
@property (nonatomic, copy) NSString *discount;

-(instancetype)initWithShopDict:(NSDictionary *)dict;

@end



//cell
@interface ShoppingCellModel : NSObject

@property (nonatomic, copy) NSDictionary *cellPriceDict;

//编辑状态
@property (nonatomic, assign) NSInteger cellEditState;

//图片
@property (nonatomic, copy) NSString *original_img;

//标题
@property (nonatomic, copy) NSString *goods_name;

//颜色
//@property (nonatomic, copy) NSString *color;

//尺码
//@property (nonatomic, copy) NSString *size;

//价格
@property (nonatomic, copy) NSString *goods_price;

//数量
@property (nonatomic, assign) NSInteger goods_num;

//库存
//@property (nonatomic, assign) NSInteger inventoryInt;

//必选
//@property (nonatomic, assign) NSInteger mustInteger;

//ID
@property (nonatomic, copy)  NSString *goods_id;

//折扣
@property (nonatomic, copy) NSString *member_goods_price;

//cell 选中状态
@property (nonatomic, assign) NSInteger cellClickState;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger indexState;

-(instancetype)initWithShopDict:(NSDictionary *)dict;

@end
