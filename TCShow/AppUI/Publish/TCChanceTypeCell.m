

//
//  TCChanceTypeCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/19.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCChanceTypeCell.h"

@implementation TCChanceTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeTitleLabel.textColor = RGBA(71, 71, 71, 1.0);
    // Initialization code
}

-(void)setTypeModel:(TCGoodsTypeModel *)typeModel{
    if (typeModel.isSelect) {
        self.typeTitleLabel.textColor = kNavBarThemeColor;
    }else{
         self.typeTitleLabel.textColor = RGBA(71, 71, 71, 1.0);
    }
    self.typeTitleLabel.text = typeModel.type_name;
}

@end
