//
//  RG_OnlineUserCollectionCell.m
//  ReadyGo
//
//  Created by gcz on 15/6/30.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//

#import "RG_OnlineUserCollectionCell.h"

@implementation RG_OnlineUserCollectionCell

- (void)awakeFromNib {
    // Initialization code
//    [_headImgV cornerView];
    _headImgV.layer.cornerRadius = 32/2;
    _headImgV.clipsToBounds = YES;
}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//}

@end
