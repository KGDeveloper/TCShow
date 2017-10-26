//
//  XXTaoTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXTao,XXTaoTableViewCell;

@protocol GoodsManageCellDelegate <NSObject>

- (void)GoodsManageCell:(XXTaoTableViewCell *)cell didClickDelete:(NSIndexPath *)indexPath;


@end

@interface XXTaoTableViewCell : UITableViewCell

@property (weak, nonatomic) id <GoodsManageCellDelegate> delegate;

@property(nonatomic,strong) XXTao *tao;
@property (weak, nonatomic) IBOutlet UIView *bmgView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *cart;

@end
