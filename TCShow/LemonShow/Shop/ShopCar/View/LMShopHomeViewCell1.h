//
//  LMShopHomeViewCell1.h
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMShopHomeViewCell1 : UITableViewCell

@property (copy, nonatomic) void (^btnClickBlock)(NSInteger index);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refreshView:(NSArray *)dataArray;

@end
