//
//  CollectionHeadView.h
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeadView : UICollectionReusableView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) void (^itemClickBlock)(TCShowLiveListItem *item);

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong) UIImageView * sectioniew;
@end
