//
//  ConfirmLeaveTableViewCell.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/14.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "ConfirmLeaveTableViewCell.h"

@implementation ConfirmLeaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leave.placeholder = @"选填,可填写您与卖家达成一致的信息";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
