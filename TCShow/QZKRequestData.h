//
//  QZKRequestData.h
//  TCShow
//
//  Created by  m, on 2017/9/12.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface QZKRequestData : NSObject

/**
 数据请求，返回执行代码

 @param dataDic
 @param block 
 */
+(void)postDataNetWorkingWitData:(NSDictionary *)dataDic success:(void (^)(id netReturn))block;

@end
