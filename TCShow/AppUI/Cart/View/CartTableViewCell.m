//
//  CartTableViewCell.m
//  tangtianshi
//
//  Created by tangtianshi on 16/2/29.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "CartTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CartTableViewCell
// -
- (IBAction)reduction:(UIButton *)sender {
    
    sender.tag = 10;
    [self.delegate btnClick:self angFlag:(int)sender.tag];
    
}
// +
- (IBAction)increase:(UIButton *)sender {
    sender.tag = 11;
     [self.delegate btnClick:self angFlag:(int)sender.tag];
}

- (void)addValue:(CartListModel *)model{
    
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.figure sd_setImageWithURL:[NSURL URLWithString:model.original_img]];
    self.figure.layer.masksToBounds = YES;
    self.figure.layer.cornerRadius = 5;
    [self.figure sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(model.original_img)]];
//        self.title.text = model.goods_name;
    self.specific.text = model.goods_name;
    self.price.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.number.text = model.goods_num;
    self.number.layer.borderWidth = 1;
    self.number.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.isSelect = model.isSelect;
//    self.specificationsLabel.text = model.goodsSpec;
    if (model.isSelect == YES) {
        selectImage.image = [UIImage imageNamed:@"paySelect"];
        
    }else{
       selectImage.image = [UIImage imageNamed:@"灰圆"];
    
    }

    [_select addSubview:selectImage];

}
@end
