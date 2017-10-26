//
//  RRContributeCell.m
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "RRContributeCell.h"

@implementation RRContributeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.head_img.layer.cornerRadius = 22.5;
    self.head_img.layer.masksToBounds = YES;
}

@end
