//
//  FansTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FansTableViewCell.h"

@implementation FansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userHeadImage.layer.cornerRadius = 25;
    self.userHeadImage.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
