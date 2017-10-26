//
//  LMShopNewViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopNewViewCell.h"
#import "LMShopModel.h"

@implementation LMShopNewViewCell {
    UIImageView *_imageView;
    UILabel *_nameLab;
    UILabel *_priceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat W = (SCREEN_WIDTH-3*15)/2;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, W)];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_imageView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, W, W, 30)];
    _nameLab.numberOfLines = 0;
    _nameLab.text = @"九分牛仔裤";
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, W + 30, W, 20)];
    _priceLab.text = @"¥ 288";
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
}

- (void)refreshUI:(LMShopModel *)model {
    NSString *imgStr = model.original_img;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _nameLab.text = model.goods_name;
    _priceLab.text = model.shop_price;
}

@end
