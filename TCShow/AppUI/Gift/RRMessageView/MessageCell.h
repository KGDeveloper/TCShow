//
//  MessageCell.h
//  直播Test
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellModel.h"
@interface MessageCell : UITableViewCell

/**
 背景View
 */
@property (nonatomic,strong) UIView *bgView;
/**
 用户等级级别图标
 */
@property (nonatomic,strong) UIImageView *userHearImage;
/**
 用户等级
 */
@property (nonatomic,strong) UILabel *levelLabel;
/**
 会话消息（用户名+消息内容）
 */
@property (nonatomic,strong) UILabel *messageLabel;
/**
 显示等级
 */
@property (nonatomic,strong) UILabel *gradeLabel;

@property (nonatomic,strong) MessageCellModel *model;
@end
