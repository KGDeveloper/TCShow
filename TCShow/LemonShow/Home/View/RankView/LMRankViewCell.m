//
//  LMRankViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMRankViewCell.h"

@implementation LMRankViewCell {
    UILabel *_rankLab;
    UILabel *_nameLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _rankLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
    _rankLab.textColor = [UIColor whiteColor];
    _rankLab.font = [UIFont systemFontOfSize:12];
    _rankLab.backgroundColor = [UIColor lightGrayColor];
    _rankLab.layer.cornerRadius = 3;
    _rankLab.layer.masksToBounds = YES;
    _rankLab.adjustsFontSizeToFitWidth = YES;
    _rankLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rankLab];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, (SCREEN_WIDTH - 3* 15) / 2 - 45, 24)];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.backgroundColor = [UIColor whiteColor];
    _nameLab.layer.cornerRadius = 3;
    _nameLab.layer.masksToBounds = YES;
    _nameLab.adjustsFontSizeToFitWidth = YES;
    _nameLab.font = [UIFont systemFontOfSize:12];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
}

- (void)refreshView:(TCShowLiveListItem *)item index:(NSInteger)index section:(NSInteger)section {
    if (section == 0) {
        _rankLab.hidden = YES;
        _nameLab.frame = CGRectMake(0, 0, [self getSizeWithText:item.host.username].width, [self getSizeWithText:item.host.username].height);
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.backgroundColor = [UIColor lightGrayColor];
        _nameLab.text = item.host.username;
    }else {
        _rankLab.hidden = NO;
        _nameLab.frame = CGRectMake(30, 10, (SCREEN_WIDTH - 3* 15) / 2 - 45, 24);
        _nameLab.backgroundColor = [UIColor whiteColor];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _rankLab.text = [NSString stringWithFormat:@"%ld", index + 1];
        _nameLab.text = item.host.username;
        if (index == 0) {
            _rankLab.backgroundColor = RGB(248, 0, 7);
        }else if (index == 1) {
            _rankLab.backgroundColor = RGB(252, 173, 20);
        }else if (index == 2) {
            _rankLab.backgroundColor = RGB(253, 225, 130);
        }else {
            _rankLab.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

- (CGSize)getSizeWithText:(NSString*)text;
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+5, 24);
}

@end
