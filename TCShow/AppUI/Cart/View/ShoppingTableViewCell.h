//
//  ShoppingTableViewCell.h
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingModel.h"
#import "ShoppingBtn.h"
@protocol ShoppingTableViewCellDelegate <NSObject>

-(void)ShoppingTableViewCell:(ShoppingCellModel *)model;

@end
@interface ShoppingTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShoppingTableViewCellDelegate>delegate;

@property (nonatomic, strong) ShoppingCellModel *model;

@end
