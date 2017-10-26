//
//  BrowsHistoryTableCell.h
//  TCShow
//
//  Created by tangtianshi on 16/11/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsManageModel.h"
@interface XXBrowsHistoryTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *stock;  // 库存

@property(nonatomic,strong)TCGoodsManageModel * goodsModel;
@end
