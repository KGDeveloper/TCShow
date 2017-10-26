//
//  HomeCollectionCell.m
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = YCColor(218, 218, 218, 1.0).CGColor;
}


- (void)configWith:(TCShowLiveListItem *)item
{
    NSString *imgStr = [item liveCover];
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_personImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:kDefaultCoverIcon];
    
    if (item)
    {
        _titleLabel.text = [item liveTitle];

    }
    else
    {

    }
}

@end
