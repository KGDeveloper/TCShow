//
//  LMShopTypeSelView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/24.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopTypeSelView.h"
#import "LMShopModel.h"

@implementation LMShopTypeSelView {
    UIImageView *_imageV;
    UILabel *_priceLab;
    UILabel *_stockLab;
    UISegmentedControl *_numberSegment;
    UIScrollView *_backScrollV;
    UIView *_numView;
    NSInteger _goodsType;
    UIView *_baseBackV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    _goodsType = 0;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [view addGestureRecognizer:tap];
    
    _baseBackV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 340, SCREEN_WIDTH, 340)];
    _baseBackV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseBackV];
    
    
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, -15, 115, 115)];
    _imageV.backgroundColor = [UIColor lightGrayColor];
    [_baseBackV addSubview:_imageV];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(145, 20, 100, 20)];
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    _priceLab.textColor = [UIColor redColor];
    [_baseBackV addSubview:_priceLab];
    
    _stockLab = [[UILabel alloc] initWithFrame:CGRectMake(145, 50, 100, 20)];
    _stockLab.font = [UIFont systemFontOfSize:14];
    _stockLab.textAlignment = NSTextAlignmentLeft;
    _stockLab.textColor = [UIColor blackColor];
    [_baseBackV addSubview:_stockLab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 15, 25, 25)];
    [btn setImage:IMAGE(@"close") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_baseBackV addSubview:btn];
    
    _backScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
    _backScrollV.backgroundColor = [UIColor whiteColor];
    [_baseBackV addSubview:_backScrollV];
    
    UILabel *leiLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    leiLab.font = [UIFont systemFontOfSize:14];
    leiLab.textAlignment = NSTextAlignmentLeft;
    leiLab.textColor = [UIColor blackColor];
    leiLab.text = @"类型";
    [_backScrollV addSubview:leiLab];
    
    _numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    _numView.backgroundColor = [UIColor whiteColor];
    [_backScrollV addSubview:_numView];
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 30)];
    numLab.font = [UIFont systemFontOfSize:14];
    numLab.textAlignment = NSTextAlignmentLeft;
    numLab.textColor = [UIColor blackColor];
    numLab.text = @"购买数量";
    [_numView addSubview:numLab];
    
    _numberSegment = [[UISegmentedControl alloc] initWithItems:@[@"-",@"1",@"+"]];
    _numberSegment.tintColor = [UIColor lightGrayColor];
    [_numberSegment setEnabled:NO forSegmentAtIndex:1];
    _numberSegment.frame = CGRectMake(SCREEN_WIDTH - 105, 20, 90, 30);
    _numberSegment.momentary = YES;
    
    [_numberSegment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [_numView addSubview:_numberSegment];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH , 40)];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBtn setBackgroundColor:LEMON_MAINCOLOR];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_baseBackV addSubview:addBtn];
    
//    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 300, SCREEN_WIDTH / 2, 40)];
//    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
//    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [payBtn setBackgroundColor:[UIColor redColor]];
//    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_baseBackV addSubview:payBtn];
    
}

- (void)tap {
    [self removeFromSuperview];
}

//- (void)payBtnClick {
//    [[HUDHelper sharedInstance] tipMessage:@"结算中心"];
//}

- (void)addBtnClick {
    if (_goodsType == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择类型"];
        return;
    }
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

- (void)refreshUI:(LMShopModel *)model {
    NSString *imgStr = model.original_img;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    _priceLab.text = [NSString stringWithFormat:@"¥ %@", model.shop_price];
    _stockLab.text = [NSString stringWithFormat:@"库存：%@", model.store_count];
    
}

- (void)createLeiXing:(NSArray *)array {
    int height = 40;
    int width = 15;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = array[i];
        NSString *string = dic[@"good_size"];
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15)
                                           options: NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:style}
                                           context:nil].size;
        if (width + size.width + 20 > SCREEN_WIDTH - 15) {
            width = 15;
            height += 40;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width, height, size.width + 20, 30)];
            [btn setTitle:string forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            btn.tag = i + 10;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(leiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_backScrollV addSubview:btn];
            width += size.width + 20 + 15;
            
        }else {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width, height, size.width + 20, 30)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:string forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            btn.tag = i + 10;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(leiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_backScrollV addSubview:btn];
            width += size.width + 20 + 15;
        }
    }
    _backScrollV .contentSize = CGSizeMake(0, height + 120);
    _numView.frame = CGRectMake(0, height + 40, SCREEN_WIDTH, 80);
}

- (void)leiBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i < _backScrollV.subviews.count; i++) {
        if ([_backScrollV.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn1 = _backScrollV.subviews[i];
            if (btn.tag == btn1.tag) {
                _goodsType = btn.tag;
                btn1.layer.borderColor = RGB(255, 186, 21).CGColor;
                [btn1 setTitleColor:RGB(255, 186, 21) forState:UIControlStateNormal];
                
            }else {
                btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
    }
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
    [_numberSegment setTitle:numberStr forSegmentAtIndex:1];
    _priceLab.text = [NSString stringWithFormat:@"¥%.2lf",[numberStr integerValue] * [_shopPrice floatValue]];
}

- (void)closeBtnClick {
    [self removeFromSuperview];
}

@end
