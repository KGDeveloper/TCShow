//
//  TCAddGoodsForCart.h
//  TCShow
//
//  Created by tangtianshi on 17/1/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsManageModel.h"

@protocol AddCartViewDelegate <NSObject>
-(void)closeCartView;
-(void)inputOrderGoodsId:(NSString *)goods_id goods_number:(NSString *)goods_number;
@end

@interface TCAddGoodsForCart : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *stockNumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberSegment;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldBottom;
@property (nonatomic,copy)NSString * shopPrice;
@property (nonatomic,assign)id<AddCartViewDelegate>addCartDelegate;
@property (nonatomic,strong)TCGoodsManageModel * managerModel;
@end
