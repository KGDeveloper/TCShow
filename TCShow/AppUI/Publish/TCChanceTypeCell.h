//
//  TCChanceTypeCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/19.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsTypeModel.h"
@interface TCChanceTypeCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (strong,nonatomic) TCGoodsTypeModel * typeModel;
@end
