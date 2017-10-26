//
//  GCZPresentMenu.h
//  PresentDemo
//
//  Created by gongcz on 16/5/27.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "GCZActionSheet.h"
// 260/375
@interface GCZPresentMenu : GCZCustomView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *balanceNumLbl;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (nonatomic) NSUInteger selectedType;

@end
