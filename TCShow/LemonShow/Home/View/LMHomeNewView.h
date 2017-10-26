//
//  LMHomeNewView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMHomeNewView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) void (^itemClickBlock)(TCShowLiveListItem *item);

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame;

@end
