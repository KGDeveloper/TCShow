//
//  SARUserInfo.h
//  SweetAngel
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 GCZ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SARUserInfo : NSObject

// 存储用户信息
+ (void)saveUserInfo:(NSDictionary *)dic;

//存储用户密码
+ (void)saveUserPassword:(NSString *)password;
// 获取用户信息
+ (NSDictionary *)gainUserInfo;
//获取账户的密码
+ (NSString *)gainUserPassword;
// 删除用户信息
+ (void)removeUserInfo;

// 获取用户id
+ (NSString *)userId;
// 是否认证
+ (BOOL *)isCertification;
// 获取用户昵称（如果为空则返回手机号）
+ (NSString *)nickName;
// 获取用户手机号
+ (NSString *)userPhone;
// 附近群id
+ (NSString *)groupId;
// 积分客服id
+ (NSString *)servicePhone;
// 自己服务器群id
+ (NSString *)qunId;
// 头像
+ (NSString *)headUrl;
// 是否是首次登录
+(BOOL)isFirstLogin;
// 记录注册then登录
+ (void)saveRegistLogin:(BOOL)isRegist;
// 是否为注册then登录
+ (BOOL)isRegistLogin;
// 记录请求推送推荐好友的时间戳
+ (void)saveCommendCurrentDate;
+ (NSTimeInterval)commendTimeInterval; // 如过返回-1则代表是第一次请求
// 更新一个字段
+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)key;
// 保存搜索历史记录
+(void)saveSearchHistory:(NSDictionary *)searchStr;
// 获取搜索历史记录
+(NSDictionary *)gainSearchHistory;
// 移除所有的搜索记录
+(void)removeSearchHistory;

// 以下三个用于联系人页面（注：好友id字段为 friend_user_id ）
+ (void)saveContacts:(NSDictionary *)dic;
+ (NSDictionary *)gainContacts;
+ (NSDictionary *)gainUser:(NSString *)phone;
+ (NSString *)gainNickName:(NSString *)phone;
+(void)removeContactsList;//删除联系人列表

// 群列表
+ (void)saveGroupList:(NSArray *)arr;
+ (NSArray *)gainGroupList;
+ (NSDictionary *)groupInfoWith:(NSString *)qunId; // 这里环信与服务器的群id都可以
// 群成员的读取(注:这里的groupId为环信的群id)
+ (void)saveMembers:(NSArray *)arr forGroupId:(NSString *)groupId;
+ (NSArray *)gainMembersWithGroupId:(NSString *)groupId;
+ (NSDictionary *)gainUserFrom:(NSString *)groupId phone:(NSString *)phone;

@end
