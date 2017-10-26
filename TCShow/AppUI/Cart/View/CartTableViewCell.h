//
//  CartTableViewCell.h
//  tangtianshi
//
//  Created by tangtianshi on 16/2/29.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartListModel.h"

// 添加代理
@protocol CartTableViewCellDelegate <NSObject>

- (void)btnClick:(UITableViewCell *)cell angFlag:(int)flag;

@end
@interface CartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *figure;
//@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *specific;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *reduction;
@property (weak, nonatomic) IBOutlet UIButton *increase;
@property (weak, nonatomic) IBOutlet UIButton *select;
@property (assign, nonatomic) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;

// 代理
@property (assign, nonatomic) id<CartTableViewCellDelegate>delegate;

// 赋值
- (void)addValue:(CartListModel *)model;


@end
