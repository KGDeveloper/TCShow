//
//  LMShopCarViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartListModel;
@interface LMShopCarViewCell : UITableViewCell

@property (copy, nonatomic) void (^selBtnClickBlock)(BOOL bl);
@property (copy, nonatomic) void (^priceNumChangeBlock)(NSString *string);
@property (copy, nonatomic) void (^removeBtnClickBlock)();

@property (strong, nonatomic) UIButton *selBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refreshView:(CartListModel*)model;

@end
