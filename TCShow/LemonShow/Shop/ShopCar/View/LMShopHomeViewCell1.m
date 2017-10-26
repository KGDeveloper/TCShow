//
//  LMShopHomeViewCell1.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopHomeViewCell1.h"
#import "LMShopModel.h"

@implementation LMShopHomeViewCell1 {
    UIImageView *_imageV;
    UILabel *_nameLab;
    UILabel *_priceLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)refreshView:(NSArray *)dataArray {
    CGFloat width = (SCREEN_WIDTH - 4 * 15) / 3;
    for (int i = 0; i < dataArray.count; i++) {
        LMShopModel *model = dataArray[i];
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(i * (width + 15) + 15, 0, width, 200)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.tag = i + 10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [backV addGestureRecognizer:tap];
        [self.contentView addSubview:backV];
        
        NSString *imgStr = model.goods_remark;
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 160)];
        imageV.backgroundColor = [UIColor greenColor];
        imageV.userInteractionEnabled = YES;
        [imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
        [backV addSubview:imageV];
        
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, width, 20)];
        nameLab.text = model.goods_name;
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [UIColor blackColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [backV addSubview:nameLab];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, width, 20)];
        priceLab.text = [NSString stringWithFormat:@"¥ %@", model.shop_price];
        priceLab.font = [UIFont systemFontOfSize:14];
        priceLab.textColor = [UIColor redColor];
        priceLab.textAlignment = NSTextAlignmentLeft;
        [backV addSubview:priceLab];
        
    }
}

- (void)clickItem:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    if (self.btnClickBlock) {
        
        
        self.btnClickBlock(tap.view.tag - 10);
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
