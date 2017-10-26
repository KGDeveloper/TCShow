//
//  BrowsHistoryTableCell.m
//  TCShow
//
//  Created by tangtianshi on 16/11/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXBrowsHistoryTableCell.h"

@implementation XXBrowsHistoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_img cornerViewWithRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setGoodsModel:(TCGoodsManageModel *)goodsModel{
    [_img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX([goodsModel.original_img componentsSeparatedByString:@";"][0])] placeholderImage:IMAGE(@"headurl")];
    _content.text = goodsModel.goods_remark;
    _price.text = [NSString stringWithFormat:@"¥%@",goodsModel.shop_price];
    _stock.text = goodsModel.store_count;

}

@end
