//
//  MessageCell.m
//  TCShow
//
//  Created by tangtianshi on 16/10/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MessageNotiCell.h"

@implementation MessageNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = 25;
    self.userImage.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
