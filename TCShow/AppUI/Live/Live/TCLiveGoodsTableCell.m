//
//  TCLiveGoodsTableCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCLiveGoodsTableCell.h"

@implementation TCLiveGoodsTableCell
- (IBAction)addGoddsCart:(UIButton *)sender {
    [self.addCartDelegate addGoodsForMyCart:_goodsModel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_contentBottomView cornerViewWithRadius:8];
    [_contentBottomView addBorderWithWidth:1.0 color:RGBA(232, 232, 232, 1.0)];
    [_goodsImageView cornerViewWithRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setGoodsModel:(TCGoodsManageModel *)goodsModel{
    _goodsModel = goodsModel;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX([[goodsModel.original_img componentsSeparatedByString:@";"] objectAtIndex:0])] placeholderImage:IMAGE(@"default_head@2x.jpg")];
    _goodsName.text = goodsModel.goods_name;
    _goodsPrice.text = goodsModel.shop_price;
    
}

@end
