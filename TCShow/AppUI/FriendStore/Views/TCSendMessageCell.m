//
//  TCSendMessageCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCSendMessageCell.h"

@implementation TCSendMessageCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.sendMessageButton cornerViewWithRadius:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)sendMessageButton:(UIButton *)sender {
    self.sendMessage();
}
@end
