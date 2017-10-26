
//
//  MoneyRecordTableCell.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MoneyRecordTableCell.h"

@implementation MoneyRecordTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.surplusMoney.textColor = YCColor(115, 115, 115, 1.0);
    self.dateTimeLabel.textColor = YCColor(183, 183, 183, 1.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
