//
//  XPersonalHomePageView.m
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XPersonalHomePageView.h"
#import "UIView+IMB.h"
@interface XPersonalHomePageView ()
@property (weak, nonatomic) IBOutlet UIView *redCircle;


@end

@implementation XPersonalHomePageView


- (void)layoutSubviews
{
    [_redCircle cornerView];
    [_redCircle addBorderWithWidth:2 color:BTN_BACKGROUNDCOLOR];
}

-(void)setHeadICon:(UIImageView *)headICon{
    _headICon = headICon;
    headICon.layer.masksToBounds = YES;
    headICon.layer.cornerRadius = 55;
}

-(void)setReportBtn:(UIButton *)reportBtn{
    _reportBtn = reportBtn;
    reportBtn.layer.masksToBounds = YES;
    reportBtn.layer.cornerRadius =10;
    reportBtn.layer.borderColor = [BTN_BACKGROUNDCOLOR CGColor];
    reportBtn.layer.borderWidth = 1;
}



//- (IBAction)reportBtnClick:(UIButton *)sender {
//    if (self.cBlock) {
//        self.cBlock(sender,[sender tag],1);
//    }
//}

//- (IBAction)closeBtnClick:(UIButton *)sender {
//    if (self.cBlock) {
//        self.cBlock(sender,[sender tag],1);
//    }
//}
//- (IBAction)attentionBtnClick:(UIButton *)sender {
//    if (self.cBlock) {
//        self.cBlock(sender,[sender tag],1);
//    }
//}
//
//- (IBAction)chatClick:(UIButton *)sender {
//    if (self.cBlock) {
//        self.cBlock(sender,[sender tag],1);
//    }
//}
//
//- (IBAction)homePageViewBtnClick:(UIButton *)sender {
//    if (self.cBlock) {
//        self.cBlock(sender,[sender tag],1);
//    }
//}
@end
