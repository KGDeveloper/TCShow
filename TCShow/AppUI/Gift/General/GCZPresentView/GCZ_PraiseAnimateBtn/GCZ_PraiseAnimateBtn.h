//
//  GCZ_PraiseAnimateBtn.h
//  PraiseAnimateDemo
//
//  Created by gcz on 15/7/13.
//  Copyright (c) 2015年 gcz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PraiseClickBlock)(UIButton *btn);

@interface GCZ_PraiseAnimateBtn : UIButton

@property (nonatomic, strong) PraiseClickBlock pcBlock;

- (void)showHeartWithNum:(NSInteger)num;

- (void)handlePriaseBlock:(PraiseClickBlock)block;

// 点击是否弹出心
@property (nonatomic) BOOL hideHeart;

@end
