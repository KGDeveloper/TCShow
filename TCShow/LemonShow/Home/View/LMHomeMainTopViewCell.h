//
//  LMHomeMainTopViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/16.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMHomeMainTopViewCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshUI:(TCShowLiveListItem *)item index:(NSInteger)index;

@end
