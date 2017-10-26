//
//  LMRankHeaderView.h
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRankHeaderView : UICollectionReusableView

@property (weak,nonatomic) UIButton *delectButton;

@property (weak,nonatomic) UILabel* textLabel;

@property (weak,nonatomic) UIImageView *imageView;

@property (copy, nonatomic) void(^btnClick)();

- (void) setText:(NSString*)text;

- (void) setImage:(NSString *)image;

@end
