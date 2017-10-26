//
//  lineLayout.m
//  test
//
//  Created by GCZ on 15/6/17.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//

#import "LineLayout.h"

@implementation LineLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(32, 32);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return self;
    
}

@end
