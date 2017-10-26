
//
//  TCSearchCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCSearchCell.h"

@implementation TCSearchCell
- (IBAction)tariffClick:(UIButton *)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.goodsImageView cornerViewWithRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSearchModel:(TCSearchModel *)searchModel{
    NSString * imagePath = @"";
    if (searchModel.original_img.length>0) {
        NSArray * imageArray = [searchModel.original_img componentsSeparatedByString:@";"];
        imagePath = imageArray[0];
    }
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(imagePath)] placeholderImage:IMAGE(@"001")];
    self.goodsName.text = searchModel.goods_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥%@",searchModel.shop_price];
    self.tariffNumber.text = [NSString stringWithFormat:@"月销%@",searchModel.sales_sum];
}

@end
