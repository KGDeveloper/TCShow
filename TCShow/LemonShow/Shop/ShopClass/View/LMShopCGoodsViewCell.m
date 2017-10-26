//
//  LMShopCGoodsViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopCGoodsViewCell.h"
#import "LMShopModel.h"

@implementation LMShopCGoodsViewCell {
    UIImageView *_imageView;
    UILabel *_nameLab;
    UILabel *_priceLab;
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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_imageView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, SCREEN_WIDTH - 90, 40)];
    _nameLab.numberOfLines = 0;
    _nameLab.text = @"九分牛仔裤";
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, SCREEN_WIDTH - 180, 20)];
    _priceLab.text = @"¥ 288";
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 50, 25, 25)];
//    [btn setImage:IMAGE(@"lemon_tianjia") forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(carBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:btn];

}

- (void)carBtnClick {
    if (self.addBtnClickBlock) {
        self.addBtnClickBlock();
    }
}

- (void)refreshUI:(LMShopModel *)model {
    NSString *imgStr = model.original_img;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _nameLab.text = model.goods_name;
    _priceLab.text = [NSString stringWithFormat:@"¥ %@", model.shop_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
