//
//  MangerListTableViewCell.h
//  TCShow
//
//  Created by  m, on 2017/9/4.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MangerListTableViewCell;

typedef void (^sendDetiarToController)(NSString * sendStr);
typedef void (^sendStatusToController)(NSString * sendStatus);

@interface MangerListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *shopName;//宝贝名称
@property (weak, nonatomic) IBOutlet UILabel *logistics;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *count;//数量
@property (weak, nonatomic) IBOutlet UILabel *state;//状态
@property (weak, nonatomic) IBOutlet UILabel *shopCount;//需求
@property (weak, nonatomic) IBOutlet UIButton *myButton;//设置按钮
@property (weak, nonatomic) IBOutlet UILabel *wuliuLabel;//物流
@property (nonatomic,copy) sendDetiarToController strString;
@property (nonatomic,copy) sendStatusToController sendStatus;


@end
