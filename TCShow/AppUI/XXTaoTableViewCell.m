//
//  XXTaoTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 16/12/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXTaoTableViewCell.h"
#import "XXTao.h"

@implementation XXTaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setTao:(XXTao *)tao{
    _tao = tao;
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PREFIX,tao.original_img]] placeholderImage:[UIImage imageNamed:@"iconPlaceholder"]];

    
    self.goodsName.text = tao.goods_name;
    self.price.text = [NSString stringWithFormat:@"¥%@",tao.shop_price];
}
- (IBAction)cartClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(GoodsManageCell:didClickDelete:)]){
        [self.delegate GoodsManageCell:self didClickDelete:self.tao.indexPath];
    }

    
    
    
}

@end
