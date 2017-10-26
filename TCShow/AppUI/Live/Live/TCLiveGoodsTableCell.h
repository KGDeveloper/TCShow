//
//  TCLiveGoodsTableCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsManageModel.h"
@protocol AddGoodsCartDelegate <NSObject>
-(void)addGoodsForMyCart:(TCGoodsManageModel *)goodsModel;
@end
@interface TCLiveGoodsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (nonatomic,strong)TCGoodsManageModel * goodsModel;
@property (nonatomic,assign)id<AddGoodsCartDelegate>addCartDelegate;
@end
