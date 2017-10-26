//
//  AnimOperationManager.h
//  presentAnimation
//
//  Created by 许博 on 16/7/28.
//  Copyright © 2016年 许博. All rights reserved.
//  新增动画管理类



#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface AnimOperationManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) GiftModel *model;
/**
 动画操作 : 需要UserID和回调

 @param userID 当前登录的用户id
 @param model 解析请求参数的model
 @param finishedBlock 播放动画
 */
- (void)animWithUserID:(NSString *)userID model:(GiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock;
/**
  取消上一次的动画操作

 @param userID 当前登录用户id
 */
- (void)cancelOperationWithLastUserID:(NSString *)userID;
@end
