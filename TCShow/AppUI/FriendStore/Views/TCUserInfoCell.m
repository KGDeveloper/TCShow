
//
//  TCUserInfoCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCUserInfoCell.h"

@implementation TCUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.userImageView cornerViewWithRadius:55.0/2.0];
    [self.liveStateButton cornerViewWithRadius:5];
    if ([self.is_live integerValue] == 0) {
        [self.liveStateButton addBorderWithWidth:0.6 color:RGBA(152, 152, 152, 1.0)];
        [self.liveStateButton setTitle:@"  未直播  " forState:UIControlStateNormal];
        [self.liveStateButton setTitleColor:RGBA(152, 152, 152, 1.0) forState:UIControlStateNormal];
    }else{
        [self.liveStateButton addBorderWithWidth:0.6 color:RGBA(252, 82, 67, 1.0)];
        [self.liveStateButton setTitle:@"  正在直播  " forState:UIControlStateNormal];
        [self.liveStateButton setTitleColor:RGBA(252, 82, 67, 1.0) forState:UIControlStateNormal];
    }
}

-(void)setUserModel:(TCLiveUserList *)userModel{
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(userModel.headsmall)] placeholderImage:IMAGE(@"friend_default_head")];
    self.userName.text = userModel.nickname;
    self.userPhone.text = userModel.phone;
    self.is_live = userModel.is_live;
    if ([self.is_live integerValue] == 0) {
        [self.liveStateButton addBorderWithWidth:0.6 color:RGBA(152, 152, 152, 1.0)];
        [self.liveStateButton setTitle:@"  未直播  " forState:UIControlStateNormal];
        [self.liveStateButton setTitleColor:RGBA(152, 152, 152, 1.0) forState:UIControlStateNormal];
    }else{
        [self.liveStateButton addBorderWithWidth:0.6 color:RGBA(252, 82, 67, 1.0)];
        [self.liveStateButton setTitle:@"  正在直播  " forState:UIControlStateNormal];
        [self.liveStateButton setTitleColor:RGBA(252, 82, 67, 1.0) forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
