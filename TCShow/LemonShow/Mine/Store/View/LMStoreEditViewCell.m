//
//  LMStoreEditViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMStoreEditViewCell.h"

@implementation LMStoreEditViewCell {
    UIImageView *_imageView;
    UILabel *_titleLab;
    UILabel *_detailLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 15, 15)];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 200, 20)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor grayColor];
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLab];
    
    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 12, 150, 20)];
    _detailLab.textAlignment = NSTextAlignmentRight;
    _detailLab.textColor = [UIColor lightGrayColor];
    _detailLab.font = [UIFont systemFontOfSize:12];
    _detailLab.text = @"123456789";
    [self.contentView addSubview:_detailLab];
    
}

- (void)refreshViewWithImage:(NSString *)imageStr Title:(NSString *)title Detail:(NSString *)datStr {
    _imageView.image = IMAGE(imageStr);
    _titleLab.text = title;
    if (datStr) {
        _imageView.frame = CGRectMake(15, 12, 20, 20);
        _detailLab.hidden = NO;
        _detailLab.text = datStr;
    }else {
        _imageView.frame = CGRectMake(15, 12, 15, 15);
        _detailLab.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
