//
//  GoodsListModel.h
//  TCShow
//
//  Created by  m, on 2017/9/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsListModel : NSObject

@property (nonatomic ,strong) NSString *good_size;
@property (nonatomic ,strong) NSString *store_count;

- (instancetype) initWithDictionsry:(NSMutableDictionary *)dic;

@end
