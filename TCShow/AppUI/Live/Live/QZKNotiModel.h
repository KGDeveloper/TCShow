//
//  QZKNotiModel.h
//  TCShow
//
//  Created by Mac on 2017/10/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZKNotiModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *giftName;
@property (nonatomic,copy) NSString *sendName;

-(instancetype)initWithNsdictionary:(NSDictionary *)dic;

@end
