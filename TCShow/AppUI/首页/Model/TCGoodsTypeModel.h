//
//  TCGoodsTypeModel.h
//  TCShow
//
//  Created by tangtianshi on 16/12/12.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoodsTypeModel : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * type_name;
@property(nonatomic,strong)NSString * type_img;
@property(nonatomic)BOOL isSelect;
@end
