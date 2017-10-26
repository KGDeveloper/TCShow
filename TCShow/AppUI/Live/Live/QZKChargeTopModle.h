//
//  QZKChargeTopModle.h
//  TCShow
//
//  Created by Mac on 2017/10/16.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZKChargeTopModle : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *order_price;
@property (nonatomic,copy) NSString *uid;

-(instancetype)initWithNsdictionary:(NSDictionary *)dic;

@end
