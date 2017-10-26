//
//  TCLiveShareView.m
//  TCShow
//
//  Created by tangtianshi on 16/12/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCLiveShareView.h"

@implementation TCLiveShareView
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * sinaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sinaTap:)];
    [_sinaShare addGestureRecognizer:sinaTap];
    
    UITapGestureRecognizer * qqTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqTap:)];
    [_qqShare addGestureRecognizer:qqTap];
    
    UITapGestureRecognizer * spaceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(spaceTap:)];
    [_spaceShare addGestureRecognizer:spaceTap];
    
    UITapGestureRecognizer * wechatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wechatTap:)];
    [_wechatShare addGestureRecognizer:wechatTap];
    
    UITapGestureRecognizer * tipTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipTap:)];
    [_tipView addGestureRecognizer:tipTap];
}


#pragma mark ------sinaTap
-(void)sinaTap:(UITapGestureRecognizer *)sender{
    self.shareItem(0);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
    
}


#pragma mark ------tipTap
-(void)tipTap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
}


#pragma mark ------qqTap
-(void)qqTap:(UITapGestureRecognizer *)sender{
    self.shareItem(1);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
    
}


#pragma mark ------spaceTap
-(void)spaceTap:(UITapGestureRecognizer *)sender{
    self.shareItem(2);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
}


#pragma mark ------wechatTap
-(void)wechatTap:(UITapGestureRecognizer *)sender{
    self.shareItem(3);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self close];
    }
}

- (void)close
{
#if kSupportFTAnimation
    [self animation:^(id selfPtr) {
        [self fadeOut:0.25 delegate:nil];
    } duration:0.3 completion:^(id selfPtr) {
        [self removeFromSuperview];
    }];
#else
    [self removeFromSuperview];
#endif
}

- (void)setIsWhiteMode:(BOOL)isWhiteMode{
    _isWhiteMode = isWhiteMode;
}


@end
