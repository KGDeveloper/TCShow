//
//  GoodsTypeListTableViewCell.m
//  TCShow
//
//  Created by  m, on 2017/8/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GoodsTypeListTableViewCell.h"

@implementation GoodsTypeListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    return self;
}

- (IBAction)butTouch:(UIButton *)sender {
    
    self.giveTag(sender.tag - 1);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
