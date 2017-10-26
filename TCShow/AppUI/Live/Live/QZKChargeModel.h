//
//  QZKChargeModel.h
//  TCShow
//
//  Created by  m, on 2017/9/27.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZKChargeModel : NSObject

@property (nonatomic,assign) NSString *lemon_id;
@property (nonatomic,assign) NSString *lemon_coins;
@property (nonatomic,assign) NSString *price;
@property (nonatomic,assign) NSString *nums;

-(instancetype)initWithNsdictionary:(NSDictionary *)dic;

@end
