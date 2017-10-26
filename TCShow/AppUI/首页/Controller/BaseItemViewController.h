//
//  BaseItemViewController.h
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionView.h"
#import "HomeCollectionCell.h"
@interface BaseItemViewController : UIViewController
@property(nonatomic,strong)NSString * sectionTitle;
@property(nonatomic,strong)NSString * sectionImagePath;
@property(nonatomic,strong)MyCollectionView *collectionView;
@property(nonatomic,strong)HomeCollectionCell * homeCell;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
