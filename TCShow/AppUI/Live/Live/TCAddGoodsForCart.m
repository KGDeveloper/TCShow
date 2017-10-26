//
//  TCAddGoodsForCart.m
//  TCShow
//
//  Created by tangtianshi on 17/1/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCAddGoodsForCart.h"

@implementation TCAddGoodsForCart

-(void)awakeFromNib{
    [super awakeFromNib];
    [_goodsImageView cornerViewWithRadius:5];
    [_textFieldBottom cornerViewWithRadius:13];
    _remarkTextField.delegate = self;
     [_numberSegment addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
}

- (IBAction)closeCartView:(UIButton *)sender {
    [self.addCartDelegate closeCartView];
}


- (IBAction)addCart:(UIButton *)sender {
    [[Business sharedInstance] goodsAddCartUid:[SARUserInfo userId] goods_id:self.managerModel.goods_id goods_num:[_numberSegment titleForSegmentAtIndex:1] succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"加入购物车成功"];
            [self removeFromSuperview];
        }else{
            [[HUDHelper sharedInstance]tipMessage:msg];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance]tipMessage:error];
    }];
}
- (IBAction)buy:(UIButton *)sender {
    [self.addCartDelegate inputOrderGoodsId:self.managerModel.goods_id goods_number:[_numberSegment titleForSegmentAtIndex:1]];
    [[HUDHelper sharedInstance] tipMessage:@"结算中心"];
}


#pragma mark -------textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_remarkTextField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.centerY = self.centerY - 110;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.centerY = self.centerY + 110;
    return YES;
}


#pragma mark ----segmentClick
- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
    NSInteger idx = segmentControl.selectedSegmentIndex;
    NSString * numberStr = [segmentControl titleForSegmentAtIndex:1];
    if (idx == 0) {
        if ([numberStr integerValue] > 1) {
            numberStr = [NSString stringWithFormat:@"%d",[numberStr intValue] - 1];
        }
    }else if (idx == 2){
        numberStr = [NSString stringWithFormat:@"%d",[numberStr intValue] + 1];
    }
    [_numberSegment setTitle:numberStr forSegmentAtIndex:1];
    _goodsPrice.text = [NSString stringWithFormat:@"¥%.2lf",[numberStr integerValue] * [_shopPrice floatValue]];
}


-(void)setManagerModel:(TCGoodsManageModel *)managerModel{
    _managerModel = managerModel;
    _stockNumber.text = [NSString stringWithFormat:@"库存：%@",managerModel.store_count];
    _goodsPrice.text = [NSString stringWithFormat:@"¥%@",managerModel.shop_price];
    if (managerModel.original_img.length>0) {
        NSArray * imageArray = [managerModel.original_img componentsSeparatedByString:@";"];
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(imageArray[0])] placeholderImage:IMAGE(@"headurl")];
    }
}

@end
