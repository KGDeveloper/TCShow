//
//  LMRankViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRankViewCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshView:(TCShowLiveListItem *)item index:(NSInteger)index section:(NSInteger)section;

@end
