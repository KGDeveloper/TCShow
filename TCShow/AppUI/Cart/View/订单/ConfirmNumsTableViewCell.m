//
//  ConfirmNumsTableViewCell.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/14.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "ConfirmNumsTableViewCell.h"

@implementation ConfirmNumsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// +
- (IBAction)increase:(UIButton *)sender {
    sender.tag = 33;
    [self.delegate btn:self tag:sender.tag];
    
}
// -
- (IBAction)reduce:(UIButton *)sender {
    sender.tag = 34;
    [self.delegate btn:self tag:sender.tag];

}

@end
