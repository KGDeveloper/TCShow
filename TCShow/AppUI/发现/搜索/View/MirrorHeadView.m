//
//  MirrorHeadView.m
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MirrorHeadView.h"

@implementation MirrorHeadView

-(void)updateView:(NSDictionary *)userInfoDic{

    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
    self.headImageView.layer.masksToBounds = YES;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,userInfoDic[@"img"]]] placeholderImage:HOLDER_HEAD];
    self.userNameLabel.text = userInfoDic[@"nickname"];
    if ([userInfoDic[@"sex"] integerValue] == 1) {
        self.userSexImageView.image = [UIImage imageNamed:@"个人主页-性别男图标"];
    }else if ([userInfoDic[@"sex"] integerValue] == 2){
    self.userSexImageView.image = [UIImage imageNamed:@"个人主页-性别"];
    }
    if ([userInfoDic[@"personalized"] isEqualToString:@""]) {
        self.usersignLabel.text = @"这家伙太懒，什么都没留下~";
    }else{
        self.usersignLabel.text = userInfoDic[@"personalized"];
    }
    [self.attentionButton setTitle:[NSString stringWithFormat:@"关注   %@",userInfoDic[@"my_attention"]] forState:UIControlStateNormal];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝   %@",userInfoDic[@"fans_num"]] forState:UIControlStateNormal];
}

#pragma mark ---关注
- (IBAction)attentionClick:(id)sender {
    [self.mirDelegate chooseClick:@"2"];
}

#pragma mark ---粉丝
- (IBAction)fansClick:(id)sender {
    [self.mirDelegate chooseClick:@"1"];
}
@end
