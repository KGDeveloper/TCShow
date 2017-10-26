//
//  LMShopHomeViewCell2.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopHomeViewCell2.h"
#import "LMShopModel.h"

@implementation LMShopHomeViewCell2 {
    UIImageView *_imageV;
    UILabel *_nameLab;
    UILabel *_numLab;
    UILabel *_priceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    };
    return self;
}

- (void)createUI {
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _imageV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_imageV];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 5, SCREEN_WIDTH - 180, 60)];
    _nameLab.numberOfLines = 0;
    _nameLab.text = @"九分牛仔裤";
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _numLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 110, SCREEN_WIDTH - 180, 20)];
    _numLab.text = @"月销11111件";
    _numLab.font = [UIFont systemFontOfSize:14];
    _numLab.textColor = [UIColor lightGrayColor];
    _numLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_numLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 130, SCREEN_WIDTH - 180, 20)];
    _priceLab.text = @"¥ 288";
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 115, 25, 25)];
//    [btn setImage:IMAGE(@"lemon_tianjia") forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(carBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:btn];
//    
}

- (void)carBtnClick {
    if (self.carBtnClickBlock) {
        self.carBtnClickBlock();
    }
}

- (void)refreshUI:(LMShopModel *)model {
    NSString *imgStr = model.original_img;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _nameLab.text = model.goods_name;
    _numLab.text = [NSString stringWithFormat:@"销量%@件",model.sales_sum];
    _priceLab.text = [NSString stringWithFormat:@"¥ %@", model.shop_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
