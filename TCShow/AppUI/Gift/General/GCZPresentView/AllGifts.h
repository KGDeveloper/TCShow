//
//  AllGifts.h
//  TCShow
//
//  Created by wxt on 2017/6/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gift : NSObject
/**
 礼物类型
 */
@property (nonatomic,assign) NSInteger type;
/**
 根据name取值
 */
@property (nonatomic,assign) NSInteger coin;
/**
 礼物名称
 */
@property(nonatomic,copy)NSString * name;
/**
 礼物图片名称
 */
@property(nonatomic,copy)NSString * imageName;

@end
@interface AllGifts : NSObject
+(NSArray <Gift*> *)AllGifts;
@end
