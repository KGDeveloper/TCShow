//
//  WebModels.m
//  TCShow
//
//  Created by AlexiChen on 15/11/12.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "WebModels.h"

@implementation ImageSignItem

- (BOOL)isVailed
{
    if (!_imageSign.length)
    {
        return NO;
    }
    
    time_t cuetime = [[NSDate date] timeIntervalSince1970];
    // 28天内有效
    BOOL isExpired = (cuetime - _saveSignTime > (1 * 28 * 24* 60 * 60));
    
    return !isExpired;
    
}


@end

/**
 **
 **
 **重写set方法
 **
 **
 **/
//==================================================
@implementation LocationItem

- (instancetype)init
{
    if (self = [super init])
    {
        self.address = @"";
    }
    return self;
}

- (BOOL)isVaild
{
    return _address.length != 0 && _latitude != 0 && _longitude != 0;
}

@end

//==================================================
@implementation TCShowUser : NSObject


- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual)
    {
        if ([object isMemberOfClass:[self class]])
        {
            TCShowUser *uo = (TCShowUser *)object;
            
            isEqual = ![NSString isEmpty:uo.phone] && [uo.phone isEqualToString:self.phone];
        }
    }
    
    return isEqual;
}

- (BOOL)isVailed
{
    return ![NSString isEmpty:_phone];
}


- (NSString *)imUserId
{
    return _phone;
}

- (NSString *)imUserName
{
    return ![NSString isEmpty:_username] ? _username : _phone;
}

- (NSString *)imUserIconUrl
{
    return _avatar;
}

@end

//==================================================

@implementation TCShowLiveCustomAction

- (instancetype)init
{
    if (self = [super init])
    {
        _user = [IMAPlatform sharedInstance].host;
    }
    return self;
}

- (NSData *)actionData
{
    NSDictionary *post = [self serializeSelfPropertyToJsonObject];
    if ([NSJSONSerialization isValidJSONObject:post])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:post options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            return nil;
        }
        
        return data;
    }
    else
    {
        return nil;
    }
}

@end


//==================================================
@implementation TCShowLiveListItem

- (NSString *)liveIMChatRoomId
{
    return self.chatRoomId;
}

- (void)setLiveIMChatRoomId:(NSString *)liveIMChatRoomId
{
    self.chatRoomId = liveIMChatRoomId;
}



// 当前主播信息
- (id<IMUserAble>)liveHost
{
    return _host;
}

// 直播房间Id
- (int)liveAVRoomId
{
    return _avRoomId;
}
//add by zxd on 2016-09-23 13:54
-(NSString *)liveHostId{
    
    return _host.uid;
}
// 直播标题
- (NSString *)liveTitle
{
    return self.title;
}

//直播类型
-(NSString *)liveType{
    return self.live_type;
}

- (NSString *)liveCover
{
    return self.cover;
}

- (void)setLiveAudience:(NSInteger)liveAudience
{
    if (liveAudience < 0)
    {
        liveAudience = 0;
    }
    
    if (liveAudience > _liveAudience)
    {
        _watchCount += (liveAudience - _liveAudience);
    }

    _liveAudience = liveAudience;
}

- (void)setLivePraise:(NSInteger)livePraise
{
    if (livePraise < 0)
    {
        livePraise = 0;
    }
    
    _admireCount = livePraise;
}

- (NSInteger)livePraise
{
    return _admireCount;
}

- (void)setLiveDuration:(NSInteger)liveDuration
{
    self.timeSpan = liveDuration;
}

- (NSInteger)liveDuration
{
    return self.timeSpan;
}

// 点赞次数
- (NSString *)livePraiseCount
{
    return [NSString stringWithFormat:@"%d", (int)self.livePraise];
}

// 观众人数
- (NSString *)liveAudienceCount
{
    return [NSString stringWithFormat:@"%d", (int)self.liveAudience];
}

-(NSString *)liveIsFollow{
    return self.is_follow;
}


- (NSDictionary *)toLiveStartJson
{
//    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
//    [json addString:self.title forKey:@"livetitle"];
////    [json addString:self.cover forKey:@"cover"];
//    [json addString:self.chatRoomId forKey:@"groupid"];
//    [json addInteger:self.avRoomId forKey:@"roomnum"];
//    
//    
////    NSMutableDictionary *host = [[NSMutableDictionary alloc] init];
//    
////    [host addString:[self.host imUserId] forKey:@"uid"];
////    [host addString:[self.host imUserIconUrl] forKey:@"avatar"];
//    [json addString:[self.host imUserName] forKey:@"userphone"];
////    [json setObject:host forKey:@"host"];
    
    
    NSDictionary *lbs = [NSDictionary dictionary];
    if (self.lbs)
    {    
        lbs = [self.lbs serializeSelfPropertyToJsonObject];
        
//        [json setObject:lbs[@"address"] forKey:@"addr"];
    }
  
    NSString* json = [NSString stringWithFormat:@"{\"livetitle\":\"%@\",\"liveType\":\"%@\",\"userphone\":\"%@\",\"roomnum\":%ld,\"groupid\":\"%@\",\"addr\":\"%@\"}", self.title,self.live_type,[IMAPlatform sharedInstance].host.profile.identifier,(long)self.avRoomId,self.chatRoomId,lbs[@"address"]];
    
//    NSDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:json forKey:@"livedata"];
    
    
    return @{@"livedata":json};
}

- (NSDictionary *)toHeartBeatJson
{
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json addString:[self.host imUserId] forKey:@"uid"];
    [json addInteger:self.watchCount forKey:@"watchCount"];
    [json addInteger:self.admireCount forKey:@"admireCount"];
    [json addInteger:self.timeSpan forKey:@"timeSpan"];
    return json;
}

- (NSInteger)liveWatchCount
{
    
    //首先请求当前主播购买的机器人数量
    
    
    
    
    //生成一个随机数，每当有用户进来的时候增加机器人
    int num = 25 + arc4random() % 15;
    
    return _watchCount + num;
}

@end

