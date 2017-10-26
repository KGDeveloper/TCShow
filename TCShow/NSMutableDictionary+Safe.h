//
//  NSMutableDictionary+Safe.h
//  TeaHorseRoad
//
//  Created by GCZ on 15/5/14.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)

// 安全存储
- (void)safeObj:(id)anObj forKey:(id<NSCopying>)aKey;

@end
