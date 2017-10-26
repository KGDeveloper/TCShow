//
//  NSMutableDictionary+Safe.m
//  TeaHorseRoad
//
//  Created by GCZ on 15/5/14.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
- (void)safeObj:(id)anObj forKey:(id<NSCopying>)aKey
{
    if (!anObj || !aKey) {
        return;
    }
    [self setObject:anObj forKey:aKey];
}

@end
