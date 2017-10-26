//
//  AddGoodsListView.h
//  TCShow
//
//  Created by  m, on 2017/8/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddGoodsListViewDelegate <NSObject>

- (void) sendArr:(NSMutableArray *)arr;

@end

@interface AddGoodsListView : UIView<AddGoodsListViewDelegate>

@property (nonatomic,weak) id<AddGoodsListViewDelegate>goodDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
