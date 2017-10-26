//
//  LMShopCGoodsViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMShopModel;

@interface LMShopCGoodsViewCell : UITableViewCell

@property (nonatomic, copy) void (^addBtnClickBlock)();

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refreshUI:(LMShopModel *)model;

@end
