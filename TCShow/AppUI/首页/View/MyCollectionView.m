//
//  MyCollectionView.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/9.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "MyCollectionView.h"

@implementation MyCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout{
    if (self == [super initWithFrame:frame collectionViewLayout:layout]) {
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self setAllowsMultipleSelection:YES];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
    }
    return self;
}

@end
