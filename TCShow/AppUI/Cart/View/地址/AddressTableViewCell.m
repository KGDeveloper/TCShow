//
//  AddressTableViewCell.m
//  tangtianshi
//
//  Created by tangtianshi on 16/2/25.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setDef:(UIButton *)sender {
    
    sender.tag = 20;
    [self.delegate btnClick:self angFlag:(int)sender.tag];
    
}

- (IBAction)edit:(UIButton *)sender {
    sender.tag = 21;
    [self.delegate btnClick:self angFlag:(int)sender.tag];
    
}

- (IBAction)deleteAdress:(UIButton *)sender {
    sender.tag = 22;
    [self.delegate btnClick:self angFlag:(int)sender.tag];
    
}

@end
