//
//  LMShopNewViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMShopModel;

@interface LMShopNewViewCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshUI:(LMShopModel *)model;

@end
