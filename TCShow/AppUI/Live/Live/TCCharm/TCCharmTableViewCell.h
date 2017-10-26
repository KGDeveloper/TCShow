//
//  TCCharmTableViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCCharmModel;

@interface TCCharmTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)initUIWith:(TCCharmModel *)model index:(NSInteger)index;

@end
