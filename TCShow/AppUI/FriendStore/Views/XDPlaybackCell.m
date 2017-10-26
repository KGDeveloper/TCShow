//
//  XDPlaybackCell.m
//  咖秀直播
//
//  Created by tangtianshi on 16/4/6.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "XDPlaybackCell.h"
#import "UIImageView+WebCache.h"
@implementation XDPlaybackCell


-(void)setHuifang:(huifangModel *)huifang{
    _huifang = huifang;
//    [self.livingPic sd_setImageWithURL:[NSURL URLWithString:huifang.pplivecontent] placeholderImage:nil];
    self.livingName.text = huifang.pplivetitle;
//    [self.auNumberBtn setTitle:[NSString stringWithFormat:@"%zi",huifang.broadcastnum] forState:UIControlStateNormal];
}
@end
