//
//  LMRecommendCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRecommendCell : UICollectionViewCell

/**
 头像
 */
@property (strong, nonatomic) UIImageView * iconImgV;

/**
 状态
 */
@property (strong, nonatomic) UIImageView * statesImgV;

/**
 观众 View
 */
@property (strong, nonatomic) UIView * viewerV;

/**
 观众人数
 */
@property (strong, nonatomic) UILabel * viewerNumLab;

/**
 主播名称
 */
@property (strong, nonatomic) UILabel * nameLab;

/**
 主播定位
 */
@property (strong, nonatomic) UILabel * cityLab;


- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshUI:(TCShowLiveListItem *)item;

@end
