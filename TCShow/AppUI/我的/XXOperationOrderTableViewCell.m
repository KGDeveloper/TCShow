//
//  XXOperationOrderTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXOperationOrderTableViewCell.h"

@implementation XXOperationOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)B1:(UIButton *)sender {
    [self.delegate clickTableViewCell:self flag:sender.tag];
}
- (IBAction)B2:(UIButton *)sender {
    
    
    if ([sender.titleLabel.text isEqualToString:@"提醒发货"]) {
        
        [self.B2 setTitle:@"已发送提醒" forState:UIControlStateNormal];
        
        self.B2.enabled = NO;
    }
    else if ([sender.titleLabel.text isEqualToString:@"设置物流"]){
        
        [self.delegate AlertViewMessage:@"提醒" buttonTitle:@"设置物流" srderid:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        
        [sender setTitle:@"已设置" forState:UIControlStateNormal];
        sender.enabled = NO;
    }
    [self.delegate clickTableViewCell:self flag:sender.tag];
    
    
}



@end
