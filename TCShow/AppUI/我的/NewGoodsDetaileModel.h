//
//  NewGoodsDetaileModel.h
//  TCShow
//
//  Created by  m, on 2017/8/29.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewGoodsDetaileModel : NSObject

@property(nonatomic,assign) NSString * myID;
@property(nonatomic,assign) NSString * name;

- (id) initWithDiction:(NSDictionary *)dic;

@end
