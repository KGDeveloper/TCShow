//
//  GoodsListTableViewCell.h
//  FineQuality
//
//  Created by tangtianshi on 16/6/1.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *figure;   // 图片
@property (weak, nonatomic) IBOutlet UILabel *goodsDescription;   // 描述
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;  // 单价
@property (weak, nonatomic) IBOutlet UILabel *num;  // 数量

@end
