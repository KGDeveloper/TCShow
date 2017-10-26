//
//  TCFansCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCFansCell.h"

@implementation TCFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH - 1)/2.0, 6, 1, 38)];
    label.backgroundColor = RGBA(206, 206, 206, 1.0);
    
    [self.contentView addSubview:label];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
