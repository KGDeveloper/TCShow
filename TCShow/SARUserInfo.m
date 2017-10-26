//
//  SARUserInfo.m
//  SweetAngel
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 GCZ. All rights reserved.
//

#import "SARUserInfo.h"

static NSString *key_for_user_info = @"key_for_user_info";
static NSString *key_for_user_password = @"key_for_user_password";
static NSString *key_for_user_contacts = @"key_for_user_contacts";
static NSString *key_for_user_group_list = @"key_for_user_group_list";
static NSString *key_for_user_group_member_list = @"key_for_user_group_member_list";
static NSString *key_for_is_regist = @"key_for_is_regist";
static NSString *key_for_commend_date = @"key_for_commend_date";


@implementation SARUserInfo

+ (void)saveUserInfo:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSData *user_data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    [UserDefaults setObject:user_data forKey:key_for_user_info];
    [UserDefaults synchronize];
}

+(void)saveUserPassword:(NSString *)password{
    [UserDefaults setObject:password forKey:key_for_user_password];
    [UserDefaults synchronize];
}

+ (NSDictionary *)gainUserInfo
{
    NSData *data = [UserDefaults objectForKey:key_for_user_info];
    if (!data) {
        return nil;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)data;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dic;
}

+ (NSString *)gainUserPassword{
    NSString * password = [UserDefaults objectForKey:key_for_user_password];
    if (!password) {
        return nil;
    }
    return password;
}

+ (void)removeUserInfo
{
    [UserDefaults removeObjectForKey:key_for_user_info];
    [UserDefaults removeObjectForKey:key_for_user_group_list];
    [UserDefaults removeObjectForKey:key_for_user_contacts];
    [UserDefaults removeObjectForKey:key_for_user_group_member_list];
    [UserDefaults removeObjectForKey:key_for_user_password];
    [UserDefaults removeObjectForKey:@"allGoods"];
    [self removeSearchHistory];
    [self removeContactsList];
}

+ (NSString *)userId
{
    return [self gainUserInfo][@"uid"];
}

+ (NSString *)nickName
{
    NSDictionary *user = [self gainUserInfo];
    NSString *nick = user[@"nickname"];
    return [NSString emptyValidate:nick]?user[@"phone"]:nick;
}

+ (NSString *)userPhone
{
    NSDictionary *user = [self gainUserInfo];
    NSString *phone = user[@"phone"];
    return phone;
}

// 附近群id
+ (NSString *)groupId
{
    NSString *groupId = [self gainUserInfo][@"group_id"];
    return groupId;
}
// 积分客服id
+ (NSString *)servicePhone
{
    NSString *serviceId = [self gainUserInfo][@"ser_phone"];
    return serviceId.length?serviceId:@"18888888888";
}

// 自己服务器群id
+ (NSString *)qunId
{
    NSString *qunId = [self gainUserInfo][@"qun_id"];
    return qunId;
}

// 头像
+ (NSString *)headUrl
{
    NSString *headSmall = [self gainUserInfo][@"headsmall"];
    if (headSmall) {
//        return headSmall;
       return IMG_APPEND_PREFIX(headSmall);
    }
    return nil;
    
}

+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)key
{
    if ([self gainUserInfo]) {
        NSMutableDictionary *dic = [[self gainUserInfo] mutableCopy];
        if (!value || !key) {
            return NO;
        }
        if ([dic respondsToSelector:@selector(safeObj:forKey:)]) {
            [dic safeObj:value forKey:key];
            [self saveUserInfo:dic];
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
}

+(BOOL)isFirstLogin{
    
    NSString *exist = [[self gainUserInfo] objectForKey:@"name"];
    
    if ([exist isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (void)saveRegistLogin:(BOOL)isRegist
{
    [UserDefaults setBool:isRegist forKey:key_for_is_regist];
    [UserDefaults synchronize];
}

+ (BOOL)isRegistLogin
{
    return [UserDefaults boolForKey:key_for_is_regist];
}

// 记录请求推送推荐好友的时间戳
+ (void)saveCommendCurrentDate;
{
    [UserDefaults setObject:[NSDate date] forKey:key_for_commend_date];
    [UserDefaults synchronize];
}
+ (NSTimeInterval)commendTimeInterval;
{
    NSDate *date = [UserDefaults objectForKey:key_for_commend_date];
    if (!date) {
        return -1;
    }
    NSTimeInterval interval = [date timeIntervalSinceNow];
    return interval;
}

+(void)saveSearchHistory:(NSDictionary *)searchStr{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:searchStr forKey:@"searchAry"];
    [userD synchronize];
    
}

+(NSDictionary *)gainSearchHistory{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *ary = [user objectForKey:@"searchAry"];
    return ary;
}

+(void)removeSearchHistory{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ary = [NSMutableDictionary dictionaryWithDictionary:[user objectForKey:@"searchAry"]];
    [ary removeAllObjects];
    [user setObject:ary forKey:@"searchAry"];
    [user synchronize];
}

// 用于联系人
+ (void)saveContacts:(NSDictionary *)dic
{
        [UserDefaults setObject:dic forKey:key_for_user_contacts];
        [UserDefaults synchronize];

}

+ (NSDictionary *)gainContacts
{
    NSDictionary *dic = [UserDefaults objectForKey:key_for_user_contacts];
    if (!dic) {
        return nil;
    }
    return dic;
}

+ (NSDictionary *)gainUser:(NSString *)phone
{
    if (!phone) {
        return nil;
    }
    //    NSData *data = [UserDefaults objectForKey:key_for_user_contacts];
    //    if (!data) {
    //        return nil;
    //    }
    //    if ([data isKindOfClass:[NSDictionary class]]) {
    //        return (NSDictionary *)data;
    //    }
    NSDictionary *dic = [self gainContacts];//[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dic[phone];
}

//删除联系人
+(void)removeContactsList{
    [UserDefaults removeObjectForKey:key_for_user_contacts];
}

+ (NSString *)gainNickName:(NSString *)phone
{
    NSDictionary *dic = [self gainUser:phone];
    NSString *nickname = ![NSString emptyValidate:dic[@"friend_nickname"]]?dic[@"friend_nickname"]: dic[@"name"];
    return ![NSString emptyValidate:nickname]?nickname:phone;
}

// 群列表
+ (void)saveGroupList:(NSArray *)arr
{
    if (!arr || ![arr isKindOfClass:[NSArray class]]) {
        return;
    }
    NSData *user_data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    [UserDefaults setObject:user_data forKey:key_for_user_group_list];
    [UserDefaults synchronize];
}

+ (NSArray *)gainGroupList
{
    NSData *data = [UserDefaults objectForKey:key_for_user_group_list];
    if (!data) {
        return nil;
    }
    if ([data isKindOfClass:[NSArray class]]) {
        return (NSArray *)data;
    }
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return arr;
}

+ (NSDictionary *)groupInfoWith:(NSString *)qunId
{
    if ([NSString emptyValidate:qunId]) {
        return nil;
    }
    NSMutableArray *groupsArr = [[self gainGroupList] mutableCopy];
    NSString *format = @"id == %@";
    if (qunId.length == 18) {
        format = @"huanxin_id == %@";
    }
    NSArray *arr = [groupsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:format,qunId]];
    return [arr firstObject];
}

// 群成员的读取
+ (void)saveMembers:(NSArray *)arr forGroupId:(NSString *)groupId
{
    if (!arr || ![arr isKindOfClass:[NSArray class]]) {
        return;
    }
    if (!groupId || ![groupId isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSData *data = [UserDefaults objectForKey:key_for_user_group_member_list];
    NSDictionary *dic = @{};
    if (data) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = @{};
        }
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:arr forKey:groupId];
    
    NSData *user_data = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:nil];
    
    [UserDefaults setObject:user_data forKey:key_for_user_group_member_list];
    [UserDefaults synchronize];
}

+ (NSArray *)gainMembersWithGroupId:(NSString *)groupId
{
    if (!groupId || ![groupId isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSData *data = [UserDefaults objectForKey:key_for_user_group_member_list];
    if (!data) {
        return nil;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        return ((NSDictionary *)data)[groupId];
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return dic[groupId];
}

+ (NSDictionary *)gainUserFrom:(NSString *)groupId phone:(NSString *)phone
{
    if ([NSString emptyValidate:groupId] || [NSString emptyValidate:phone]) {
        return nil;
    }
    NSMutableArray *groupsArr = [[self gainMembersWithGroupId:groupId] mutableCopy];
    NSArray *arr = [groupsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone == %@",phone]];
    return [arr firstObject];
}

// 是否认证
+ (BOOL *)isCertification{
    
     NSDictionary *user = [self gainUserInfo];
    NSString *verify = user[@"verify"];
    if ([verify isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }

}

@end
