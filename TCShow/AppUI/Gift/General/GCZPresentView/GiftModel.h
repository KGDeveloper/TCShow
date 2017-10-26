//
//  GiftModel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject
/**
 头像
 */
@property (nonatomic,strong) NSString *headImage; // 头像
/**
 礼物
 */
@property (nonatomic,strong) UIImage *giftImage; // 礼物
/**
 送礼物者
 */
@property (nonatomic,copy) NSString *name; // 送礼物者
/**
 礼物名称
 */
@property (nonatomic,copy) NSString *giftName; // 礼物名称
/**
 礼物个数
 */
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数


//@property (nonatomic,retain) NSString *senderName;
//@property (nonatomic,retain) NSString *text;
/**
 赠送礼物的用户id
 */
@property (nonatomic,retain) NSString *senderChatID;
/**
 礼物类型
 */
@property (nonatomic,assign) NSInteger type;


@end
