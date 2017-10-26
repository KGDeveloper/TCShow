//
//  TCLiveUserList.h
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLiveUserList : NSObject
@property(nonatomic,strong)NSString * uid;//用户UID
@property(nonatomic,strong)NSString * phone;//用户手机号码
@property(nonatomic,strong)NSString * nickname;//用户昵称
@property(nonatomic,strong)NSString * livenum;//用户直播号
@property(nonatomic,strong)NSString * headsmall;//用户头像地址
@property(nonatomic,strong)NSString * sex;//用户性别 0未填写 1男 2女
@property(nonatomic,strong)NSString * personalized;//个性签名
@property(nonatomic,strong)NSString * birthday;//出生日期 时间戳
@property(nonatomic,strong)NSString * love_status;//情感状态 0保密 1单身 2恋爱中 3已婚
@property(nonatomic,strong)NSString * province;//用户省份
@property(nonatomic,strong)NSString * city;//用户城市
@property(nonatomic,strong)NSString * job;//工作
@property(nonatomic,strong)NSString * verify;//是否认证 0未认证 1认证中 2通过认证 3认证失败
@property(nonatomic,strong)NSString * real_name;//真实姓名
@property(nonatomic,strong)NSString * idcard;//身份证号码
@property(nonatomic,strong)NSString * create_time;//注册时间
@property(nonatomic,strong)NSString * store_name;//商店名字
@property(nonatomic,strong)NSString * live_status;//直播状态 1正在直播 0结束直播
@property(nonatomic,strong)NSString * avRoomId;//直播房间号码
@property(nonatomic,strong)NSString * chatRoomId;//聊天室房间号

/**  ---- 需要自行添加参数 */
@property(nonatomic,strong)NSString * is_live;//是否在直播
@property(nonatomic,strong)NSString * fans;//粉丝数
@property(nonatomic,strong)NSString * follows;//关注数
@end
