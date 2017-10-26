//
//  GoodsTypeListTableViewCell.h
//  TCShow
//
//  Created by  m, on 2017/8/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GoodsTypeListTableViewCell;

typedef void (^sendButTag)(NSInteger butTag);


@interface GoodsTypeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLable;//显示规格的lable
@property (weak, nonatomic) IBOutlet UILabel *rightLable;//显示库存的lable
@property (nonatomic ,copy) sendButTag giveTag;
@property (weak, nonatomic) IBOutlet UIButton *deleteBut;



@end
