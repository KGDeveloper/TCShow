//
//  MessageCellModel.h
//  直播Test
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
@interface MessageCellModel : NSObject
/**
 内容的高度
 */
@property(nonatomic)float cellheight;
/**
 内容的宽度
 */
@property(nonatomic)float cellwidth;
/**
 用户名
 */
@property (nonatomic,copy)NSString *username;
/**
 消息内容
 */
@property (nonatomic,copy)NSString *message;
/**
 用户名和消息内容 （目的是：改变用户名的显示颜色）
 */
@property (nonatomic,copy)NSMutableAttributedString *content;

/**
 是否为送礼物
 */
@property (nonatomic)BOOL isSendGift;
/**
 最后一个字符的坐标
 */
@property (assign)CGPoint lastPoint;
/**
 送礼物的图片名字
 */
@property (nonatomic,copy)NSString *imageName;
@end
