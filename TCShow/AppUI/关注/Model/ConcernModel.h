//
//  ConcernModel.h
//  TCShow
//
//  Created by tangtianshi on 16/9/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcernModel : NSObject


@property (nonatomic, strong) TCShowUser *host;
@property(nonatomic,copy)NSString *programid;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *userphone;
@property(nonatomic,copy)NSString *user_nickname;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *praisenum;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *header_img;
@property(nonatomic,copy)NSString *coverimagepath;
@property(nonatomic,copy)NSString *groupid;
@property(nonatomic,copy)NSString *begin_time;
@property(nonatomic,copy)NSString *viewernum;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *guanzhu;
/*
 
 programid:   房间id roomnum
 user_id:      创建房间者的用户id
 userphone:    手机号码
 user_nickname:    昵称
 subject:      直播间标题
 praisenum:    点赞次数
 addr:              直播地址
 header_img:    用户头像
 coverimagepath:    直播房间封面图
 groupid:       聊天群组id
 begin_time:    开始时间，时间戳
 viewernum:   在线人数
 amount:    累计收益
 guanzhu:   是否关注该主播
 */
@end
