//
//  GCZPresentView.h
//  PresentDemo
//
//  Created by gongcz on 16/5/23.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import <UIKit/UIKit.h>
// views
#import "GCZPresentItem.h"
#import "GiftModel.h"
static NSUInteger numOfLines = 2; // 行数

@interface GCZPresentView : UIView

+ (instancetype)instance;

/**
 *  显示送礼物视图
 *
 *  @param headImg     头像
 *  @param name        昵称
 *  @param presentType 礼物类型
 *  @param num         礼物数量
 */
- (void)showPresentViewWith:(NSString *)headImgUrl
                       name:(NSString *)name
                       type:(PresentType)presentType
                        num:(NSUInteger)num;
/**
 *  根据类型获取图片名
 *
 *  @param type 类型
 *
 *  @return 图片名
 */
- (NSString *)nameWithType:(PresentType)type;


- (void)showPresentViewWith:(NSString *)headImgUrl
                       name:(NSString *)name
                       type:(PresentType)presentType
                        num:(NSUInteger)num
                      image:(UIImage *)image
                      title:(NSString *)title;

-(void)animationWith:(GiftModel *)gift;
- (NSString *)nameWithType:(PresentType)type;
@end
