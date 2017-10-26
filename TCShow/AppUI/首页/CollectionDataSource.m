
//
//  CollectionDataSource.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/9.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "CollectionDataSource.h"
#import "HomeCollectionCell.h"
@interface CollectionDataSource ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CollectionCellConfigureBlock configureCellBlock;
@property (nonatomic,copy)id myCell;
@end
@implementation CollectionDataSource
- (id)init
{
    return nil;
}

-(id)initWithItems:(NSMutableArray *)dataSource cellIdentifier:(NSString *)aCellIdentifier myCell:(id)itemCell configureCellBlock:(CollectionCellConfigureBlock)aConfigureCellBlock{
    self = [super init];
    if (self) {
        self.myCell = itemCell;
        self.items = [NSMutableArray arrayWithCapacity:0];
        self.items = dataSource;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
//    return self.items[(NSUInteger) indexPath.row];
    return nil;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.items.count;
    return 6;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _myCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
//    id item = [self itemAtIndexPath:indexPath];
//    self.configureCellBlock(_myCell, item);
    return _myCell;
}

-(NSObject *)reloadData:(NSMutableArray *)newDataArray{
    _items = newDataArray;
    return self;
}

@end
