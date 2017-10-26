//
//  CollectionDataSource.h
//  FineQuality
//
//  Created by tangtianshi on 16/9/9.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CollectionCellConfigureBlock)(id cell, id item);
@interface CollectionDataSource : NSObject<UICollectionViewDataSource>
- (id)initWithItems:(NSMutableArray *)dataSource
     cellIdentifier:(NSString *)aCellIdentifier myCell:(id)itemCell
 configureCellBlock:(CollectionCellConfigureBlock)aConfigureCellBlock;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
-(NSObject *)reloadData:(NSMutableArray *)newDataArray;
@end
