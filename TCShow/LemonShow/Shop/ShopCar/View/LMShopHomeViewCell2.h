//
//  LMShopHomeViewCell2.h
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMShopModel;

@interface LMShopHomeViewCell2 : UITableViewCell

@property (copy, nonatomic) void (^carBtnClickBlock)();

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refreshUI:(LMShopModel *)model;

@end
