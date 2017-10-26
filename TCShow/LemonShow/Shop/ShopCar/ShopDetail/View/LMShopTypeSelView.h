//
//  LMShopTypeSelView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/24.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMShopModel;

@interface LMShopTypeSelView : UIView
@property (nonatomic,copy)NSString * shopPrice;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshUI:(LMShopModel*)model;
- (void)createLeiXing:(NSArray *)array;

@property (nonatomic,strong)LMShopModel * managerModel;

@end
