//
//  LMHomeView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/8.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeView.h"
#import "LMHomeRecommendView.h"
#import "LMHomeNewView.h"
#import "LMHomeLikeView.h"

@implementation LMHomeView {
    UIScrollView *_backScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
//    _backScrollView.backgroundColor = [UIColor redColor];
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.frame.size.height);
    _backScrollView.pagingEnabled = YES;
    _backScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    _backScrollView.showsHorizontalScrollIndicator = YES;
    _backScrollView.delegate = self;
    _likeV = [[LMHomeLikeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
//    _likeV.backgroundColor = [UIColor grayColor];
    [_backScrollView addSubview:_likeV];
    
    _recommendV = [[LMHomeRecommendView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height)];
    
    [_backScrollView addSubview:_recommendV];
    
    _hNewV = [[LMHomeNewView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.frame.size.height)];
    
    [_backScrollView addSubview:_hNewV];
    
    [self addSubview:_backScrollView];
    __weak typeof(self) weakself = self;
    _likeV.itemClickBlock = ^(TCShowLiveListItem *item) {
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(item);
        }
    };
    _recommendV.itemClickBlock = ^(TCShowLiveListItem *item) {
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(item);
        }
    };
    _hNewV.itemClickBlock = ^(TCShowLiveListItem *item) {
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(item);
        }
    };
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.slideBlock) {
        self.slideBlock(scrollView.contentOffset.x);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (self.slideEndBlock) {
        self.slideEndBlock(scrollView.contentOffset.x / SCREEN_WIDTH);
    }
}
@end
