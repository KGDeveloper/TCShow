//
//  XXAppraisegoodsTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 17/1/12.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "XXAppraisegoodsTableViewCell.h"

@implementation XXAppraisegoodsTableViewCell
// 商品
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)bnt1:(id)sender {
    [self.delegate click:self flag:1];
}
- (IBAction)btn2:(id)sender {
    [self.delegate click:self flag:2];
}
- (IBAction)btn3:(id)sender {
    [self.delegate click:self flag:3];
}
- (IBAction)btn4:(id)sender {
    [self.delegate click:self flag:4];
}
- (IBAction)btn5:(id)sender {
    [self.delegate click:self flag:5];
}

@end
