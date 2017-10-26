//
//  LMShopCarViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopCarViewCell.h"
#import "CartListModel.h"

@implementation LMShopCarViewCell {
    UIButton *_selBtn;
    UIImageView *_imageView;
    UILabel *_nameLab;
    UILabel *_desLab;
    UILabel *_priceLab;
    UISegmentedControl *_numberSegment;
    NSString *_shopPrice;
    CartListModel *_cartModel;
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
    _selBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 20, 20)];
    [_selBtn setImage:IMAGE(@"lemon_yuan") forState:UIControlStateNormal];
    [_selBtn setImage:IMAGE(@"lemon_yuanxuanzhong") forState:UIControlStateSelected];
    _selBtn.selected = NO;
    [_selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selBtn];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 15, 70, 70)];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_imageView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, SCREEN_WIDTH - 140, 30)];
    _nameLab.numberOfLines = 0;
    _nameLab.text = @"九分牛仔裤";
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _desLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 45, SCREEN_WIDTH - 140, 20)];
    _desLab.text = @"颜色：白色    标配";
    _desLab.font = [UIFont systemFontOfSize:12];
    _desLab.textColor = [UIColor lightGrayColor];
    _desLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_desLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 65, 100, 20)];
    _priceLab.text = @"¥ 288";
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.adjustsFontSizeToFitWidth = YES;
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
    _numberSegment = [[UISegmentedControl alloc] initWithItems:@[@"-",@"1",@"+"]];
    _numberSegment.tintColor = [UIColor lightGrayColor];
    [_numberSegment setEnabled:NO forSegmentAtIndex:1];
    _numberSegment.frame = CGRectMake(SCREEN_WIDTH - 105, 65, 90, 30);
    _numberSegment.momentary = YES;
    
    [_numberSegment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_numberSegment];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 10, 25, 25)];
    [btn setImage:IMAGE(@"lemon_remove") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
}

- (void)removeBtnClick {
    
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"ids":_cartModel.cart_id};
    [RequestData requestWithUrl:DELETE_CART para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            if (self.removeBtnClickBlock) {
                self.removeBtnClickBlock();
            }
        }else {
            [[HUDHelper sharedInstance] tipMessage:dic[@"message"]];
        }
    } fail:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
    }];

    
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmentControl {
    
    
    NSInteger idx = segmentControl.selectedSegmentIndex;
    NSString * numberStr = [segmentControl titleForSegmentAtIndex:1];
    if (idx == 0) {
        if ([numberStr integerValue] > 1) {
            numberStr = [NSString stringWithFormat:@"%d",[numberStr intValue] - 1];
        }
    }else if (idx == 2){
        numberStr = [NSString stringWithFormat:@"%d",[numberStr intValue] + 1];
    }
//    [_numberSegment setTitle:numberStr forSegmentAtIndex:1];
//    _priceLab.text = [NSString stringWithFormat:@"¥ %.2lf",[numberStr integerValue] * [_shopPrice floatValue]];
    
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"cart_id":_cartModel.cart_id,@"goods_num":numberStr};
    __weak typeof(self) weakself = self;
    [RequestData requestWithUrl:MODIFY_CART_NUM para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"修改成功"];
            [_numberSegment setTitle:numberStr forSegmentAtIndex:1];
            _priceLab.text = [NSString stringWithFormat:@"¥ %.2lf",[numberStr integerValue] * [_shopPrice floatValue]];
            if (weakself.priceNumChangeBlock) {
                weakself.priceNumChangeBlock(numberStr);
            }
            //            [_tableView reloadData];
        }else {
            [[HUDHelper sharedInstance] tipMessage:@"修改失败"];
        }
    } fail:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"修改失败"];
    }];

}

- (void)refreshView:(CartListModel *)model {
    _cartModel = model;
    [_numberSegment setTitle:model.goods_num forSegmentAtIndex:1];
    NSString *imgStr = model.original_img;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _selBtn.selected = model.isSelect;
    _nameLab.text = model.goods_name;
    _priceLab.text = [NSString stringWithFormat:@"¥ %.2f", [model.goods_price floatValue] * [model.goods_num integerValue]];
    _desLab.text = [NSString stringWithFormat:@"类型：%@", model.good_standard_size];
    _shopPrice = model.goods_price;
}

- (void)selBtnClick:(id)sender {
    if (_selBtn.isSelected) {
        _selBtn.selected = NO;
        if (self.selBtnClickBlock) {
            self.selBtnClickBlock(NO);
        }
    }else {
        _selBtn.selected = YES;
        if (self.selBtnClickBlock) {
            self.selBtnClickBlock(YES);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
