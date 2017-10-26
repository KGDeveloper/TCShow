//
//  WebModels.h
//  TCShow
//
//  Created by AlexiChen on 15/11/12.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSignItem : NSObject

@property (nonatomic, copy)   NSString     *imageSign;
@property (nonatomic, assign) NSInteger     saveSignTime;

- (BOOL)isVailed;
@end


//==================================================

// 位置信息
@interface LocationItem : NSObject

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, copy) NSString *address;

- (BOOL)isVaild;

@end

//==================================================
// 用户基本信息
@interface TCShowUser : NSObject<AVMultiUserAble>

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy)NSString *phone;      //add by zxd on 2016-09-23 09:33

@property (nonatomic, assign) NSInteger avCtrlState;

@property (nonatomic, assign) NSInteger avMultiUserState;       // 多人互动时IM配置

// 互动时，用户画面显示的屏幕上的区域（opengl相关的位置）
@property (nonatomic, assign) CGRect avInteractArea;

// 互动时，因opengl放在最底层，之上是的自定义交互层，通常会完全盖住opengl
// 用户要想与小画面进行交互的时候，必须在交互层上放一层透明的大小相同的控件，能过操作此控件来操作小窗口画面
@property (nonatomic, weak) UIView *avInvisibleInteractView;

- (BOOL)isVailed;


@end

//==================================================

// TODO:添加自定义的命令类型
@interface TCShowLiveCustomAction : NSObject

@property (nonatomic, assign)   NSInteger       userAction;
@property (nonatomic, copy)     NSString        *actionParam;
@property (nonatomic, strong)   id<IMUserAble>  user;

- (NSData *)actionData;

@end


@interface TCShowLiveListItem : NSObject<TCShowLiveRoomAble>

@property (nonatomic, strong) TCShowUser *host;
@property (nonatomic, strong) LocationItem *lbs;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headsmall;
@property (nonatomic, copy) NSString *charm;

@property (nonatomic, assign) NSInteger createTime;         // 创建时间
@property (nonatomic, assign) NSInteger timeSpan;           // 时长

@property (nonatomic, assign) NSInteger liveAudience;      //在线人数

@property (nonatomic, assign) NSInteger admireCount;        // 点赞统计
@property (nonatomic, assign) NSInteger watchCount;         // 观看人次

@property (nonatomic, copy) NSString *chatRoomId;           // 直播聊天室
@property (nonatomic, assign) int avRoomId;                 // 直播房间号

@property(nonatomic,copy)NSString * is_follow;//是否关注该直播 add by yh 2016年12月23日10:23:35
    
@property(nonatomic,copy)NSString * follow_num;//关注过主播人数

@property (nonatomic,copy)NSString *live_type;//直播类型 add by yanghui 2016年12月19日13:35:06
- (NSDictionary *)toLiveStartJson;
- (NSDictionary *)toHeartBeatJson;

@end











