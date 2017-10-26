

//
//  ContributeTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContributeTableViewCell.h"

@implementation ContributeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userHeadImage.layer.cornerRadius = 30;
    self.userHeadImage.layer.masksToBounds = YES;
    
    self.rankLabel.backgroundColor = kNavBarThemeColor;
    self.rankLabel.textColor = [UIColor whiteColor];
    
    self.contrNumber.textColor = kNavBarThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
