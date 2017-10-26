//
//  SendGiftCell.h
//  直播Test
//
//  Created by admin on 16/5/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellModel.h"
@interface SendGiftCell : UITableViewCell
/**
 背景View
 */
@property (nonatomic,strong)UIView *bgView;
/**
 会话消息（用户名+消息内容）
 */
@property (nonatomic,strong)UILabel *messageLabel;
/**
 解析用的model
 */
@property (nonatomic,strong)MessageCellModel *model;
/**
 送的礼物图片
 */
@property (nonatomic,strong)UIImageView *giftImageView;
@end
