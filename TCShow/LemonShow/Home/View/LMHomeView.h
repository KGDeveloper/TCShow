//
//  LMHomeView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/8.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMHomeRecommendView, LMHomeNewView, LMHomeLikeView;

@interface LMHomeView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) LMHomeRecommendView *recommendV;
@property (nonatomic, strong) LMHomeNewView *hNewV;
@property (nonatomic, strong) LMHomeLikeView *likeV;

@property (nonatomic, copy) void (^slideBlock)(NSInteger index);
@property (nonatomic, copy) void (^slideEndBlock)(NSInteger index);
@property (nonatomic, copy) void (^itemClickBlock)(TCShowLiveListItem *item);

- (instancetype)initWithFrame:(CGRect)frame;

@end
