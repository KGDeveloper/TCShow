//
//  PayListCell.h
//  TCShow
//
//  Created by wxt on 2017/6/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayListCell : UITableViewCell
/**
 支付平台name
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 显示是否选择
 */
@property (weak, nonatomic) IBOutlet UILabel *show;

@end
