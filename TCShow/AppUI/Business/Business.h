//
//  Business.h
//  live
//
//  Created by hysd on 15/8/6.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

/**
 *  成功回调
 */
typedef void (^businessSucc)(NSString* msg, id data);
/**
 *  失败回调
 */
typedef void (^businessFail)(NSString *error);


@interface Business : NSObject
/**
 * 获取单例
 */
+ (Business*) sharedInstance;
/**
 *  登录
 *  @param phone  账号（电话号码）
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)loginPhone:(NSString*)phone pass:(NSString*)pass succ:(businessSucc)succ fail:(businessFail)fail;


/**
 获取腾讯sign

 @param phone 用户手机号
 @param succ  获取成功
 @param fail  获取失败
 */
- (void)getTencentSign:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  关注列表
 *
 *  @param user_id     用户id
 *  @param type        请求类型 1我的关注 2我的粉丝 默认为1
 *  @param succ
 *  @param fail
 */
-(void)concernList:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  获取房间号
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getRoomnumSucc:(businessSucc)succ fail:(businessFail)fail;
/**
 *  插入创建直播到数据库
 *  @param title  直播标题
 *  @param phone  账号（电话号码）
 *  @param room   直播房间号
 *  @param chat   聊天室号码
 *  @param image  直播封面
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)insertLive:(NSString*)tilte latitude:(double)latitude room:(NSInteger)room longitude:(double)longitude addr:(NSString*)addr  chat_room_id:(NSString *)chat_room_id  cover:(NSString *)cover live_type:(NSString *)live_type succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  插入进入直播到数据库
 *  @param phone  观众账号（电话号码）
 *  @param room   直播房间号
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)enterRoom:(NSInteger)room phone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取用户信息
 *  @param phone  账号（电话号码）
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserInfoByPhone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取用户详细信息
 *  @param uid     登录等用户id
 *  @param userid  要看的用户id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserInfoByUid:(NSString*)uid userid:(NSString *)userid succ:(businessSucc)succ fail:(businessFail)fail;


/**
 *  点赞
 *  @param room   房间号
 *  @param count  增加点赞数
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
-(void)loveLive:(NSInteger)room addCount:(int)count succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  上传直播封面
 *
 *  @param type  1头像  2直播封面
 *  @param phone 手机号
 *  @param image 上传图片
 *  @param succ  成功
 *  @param fail  失败
 */
-(void)upLoadLiveCover:(NSInteger)type phone:(NSString *)phone image:(UIImage *)image succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  关闭房间
 *  @param room   房间号
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
-(void)closeRoom:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  离开房间
 *  @param room   房间号
 *  @param phone  用户手机
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)leaveRoom:(NSInteger)room phone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  日志上报
 *  @param phone  用户手机
 *  @param log    日志
 */
- (void)logReport:(NSString*)phone log:(NSString*)log;
/**
 *  获取用户列表
 *  @param phones  用户手机号（15002626262&15282837462）
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserList:(NSString*)phones succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取用户列表
 *  @param room   房间id
 *  @param room   用户id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserListByRoom:(NSString *)group_id uid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  获取直播信息
 *  @param room   房间id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getLive:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  保存用户信息
 *  @param phone  账号（电话号码）
 *  @param name   用户昵称
 *  @param gender 写别
 *  @param address地址
 *  @param sig    个人签名
 *  @param image  头像
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)saveUserInfo:(NSString*)phone name:(NSString*)name gender:(NSString*)gender address:(NSString*)address signature:(NSString*)sig image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  保存用户信息
 *  @param phone  账号（电话号码）
 *  @param key    字段名
 *  @param value  字段值
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)saveUserInfo:(NSString*)phone key:(NSString*)key value:(NSString*)value succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  保存用户头像
 *  @param phone  账号（电话号码）
 *  @param image  头像
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)saveUserInfo:(NSString*)phone image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  插入预告数据
 *  @param title  标题
 *  @param phone  账号（电话号码）
 *  @param time   时间
 *  @param image  封面
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)insertTrailer:(NSString*)tilte phone:(NSString*)phone time:(NSString*)time image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  获取预告列表
 *  @param lastTime 最新时间
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getTrailers:(NSString*)lastTime succ:(businessSucc)succ fail:(businessFail)fail;



/**
 *  获取直播列表
 *  @param lastTime 最新时间
 *  @param uid  用户id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;

- (void)getNewLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;
//主推直播列表
- (void)getMainTopLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;
//关注直播列表
- (void)getFollowLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;

/**
 附近的直播

 @param uid 用户uid
 @param latitude 纬度
 @param longitude 经度
 @param succ 成功回调
 @param fail 失败回调
 */
-(void)getNearLives:(NSString *)uid latitude:(NSString *)latitude longitude:(NSString *)longitude succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  心跳检查,主播房间是否还存在
 *  @param phone 主播电话
 */
- (void)heartBeatCheckCrash:(NSString*)phone;



/**
 直播间主播举报
 @param user_id 当前用户id
 @param accuse_id 被举报主播id
 @param cause 举报原因
 @param complement 举报原因补充说明
 @param succ 请求成功
 @param fail 请求失败
 */
- (void)liveReport:(NSString *)user_id accuse_id:(NSString *)accuse_id cause:(NSString *)cause complement:(NSString *)complement succ:(businessSucc)succ fail:(businessFail)fail;

- (void)forcastReport:(NSString *)fileID reporter:(NSString *)reportID content:(NSString *)reportContent succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取总的消息未读数
 */
-(void)messageUnreadNumber:(businessSucc)succ fail:(businessFail)fail;


/**
 *  搜索直播
 *  @param search 搜索的关键字
 */
-(void)searchLive:(NSString *)search succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  关注直播/取消关注
 *  @param userId 被关注的用户id
  * @param userId 关注的用户id
 */
-(void)concern:(NSString *)fuid uid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  退出房间时请求的接口，解散房间
 *  @param programid 房间的roomnum	在房间列表中可以获取
 */
- (void)deleRoom:(NSString *)programid succ:(businessSucc)succ fail:(businessFail)fail;



/**
 忘记密码
 @param pwd   用户密码
 @param phone 用户电话
 @param succ  找回密码成功
 @param fail  找回密码失败
 @param code  短信验证码
 */
-(void)pwdReset:(NSString *)pwd phoneNum:(NSString *)phone succ:(businessSucc)succ fail:(businessFail)fail code:(NSString *)code;

/**
 *  消息列表
 *  @param pwd 密码
 */
-(void)getMessageList:(NSString *)page succ:(businessSucc)succ fail:(businessFail)fail;

/**   XX
 *  提现操作
 *  用户ID id
 *  提现金额 消耗的鸪鸽币 integral
 */
-(void)withdrawal:(NSString *)ID integral:(NSString *)integral succ:(businessSucc)succ fail:(businessFail)fail;

/**   XX
 *  赠送礼物
 *  来自哪个用户送的礼物，from_user_id
 *  送给哪个用户，用户id give_user_id
 *  送多少个积分  amount
 */
-(void)giftGiving:(NSString *)giveUserID amount:(NSString *)amount succ:(businessSucc)succ fail:(businessFail)fail;


/**
 首页轮播图

 @param succ 请求成功
 @param fail 请求失败
 */
-(void)homeCarouselSucc:(businessSucc)succ fail:(businessFail)fail;


/**
 首页商品类型

 @param succ 请求成功
 @param fail 请求失败
 */
-(void)homeGoodsTypeSucc:(businessSucc)succ fail:(businessFail)fail;


/**
 首页热门搜索

 @param succ 请求成功
 @param fail 请求失败
 */
-(void)homeHotSearchSucc:(businessSucc)succ fail:(businessFail)fail;



/**
 首页搜索

 @param succ    请求成功
 @param fail    请求失败
 @param name    搜索分类名称或是商品名称
 @param goodsID 搜索分类id
 @param order 排序类型（默认不传是综合按goods_id倒序，sales_sum按销量倒序，shop_price价格升序）
 @param page  第几页（默认10条）
 */
-(void)homeSearchSucc:(businessSucc)succ fail:(businessFail)fail name:(NSString *)name goodsID:(NSString *)goodsID order:(NSString *)order page:(NSString *)page;


/**
 好友店铺正在直播列表

 @param uid  用户uid
 @param type 点击更多（type的值为more）
 @param succ 成功回调
 @param fail 失败回调
 */
-(void)friendLivingList:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail;


/**
 好友列表

 @param uid  用户id
 @param succ 成功回调
 @param fail 失败回调
 */
-(void)friendList:(NSString * )uid succ:(businessSucc)succ fail:(businessFail)fail;


/**
 搜索加好友

 @param uid  用户id
 @param name 搜索添加的好友电话或昵称
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)searchAddFriend:(NSString *)uid name:(NSString *)name succ:(businessSucc)succ fail:(businessFail)fail;


/**
 搜索好友店铺中的好友

 @param uid 用户uid
 @param name 搜索的好友电话或昵称
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)searchFriendFromMyList:(NSString *)uid name:(NSString *)name succ:(businessSucc)succ fail:(businessFail)fail;


/**
 添加好友
 @param uid 用户id
 @param friend_phone 需要添加的好友的电话
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)addFriend:(NSString *)uid friend_phone:(NSString *)friend_phone succ:(businessSucc)succ fail:(businessFail)fail;


/**
 删除好友

 @param uid 用户id
 @param friend_phone 要删除的好友电话
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)delegateFriend:(NSString *)uid friend_phone:(NSString *)friend_phone succ:(businessSucc)succ fail:(businessFail)fail;


/**
 最新物品
 
 @param uid 用户id
 @param 
 @param succ 请求成功
 @param fail 请求失败
 */
- (void)newGoods:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;



/**
 商品管理

 @param uid 用户uid
 @param type 在售商品1  已售商品2
 @param page 第几页
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)goodsManageUid:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ page:(NSString *)page fail:(businessFail)fail;


/**
 添加商品到购物车
 
 @param user_id  用户uid
 @param goods_id 商品 id
 @param goods_num 商品数量
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)goodsAddCartUid:(NSString *)user_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num succ:(businessSucc)succ fail:(businessFail)fail;


/**
 添加商品到店铺

 @param uid 用户uid
 @param cat_id 分类id
 @param image 图片
 @param goods_name 分类id
 @param shop_price 商品价格
 @param store_count 商品库存
 @param goods_remark 商品描述
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)releaseGoodsUid:(NSString *)uid cat_id:(NSString *)cat_id goods_name:(NSString *)goods_name shop_price:(NSString *)shop_price store_count:(NSString *)store_count goods_remark:(NSArray *)goods_remark goods_standard:(NSArray *)goods_standard original_img:(NSArray *)original_img goods_content:(NSArray *)goods_content succ:(businessSucc)succ fail:(businessFail)fail;


/**
 商品详情

 @param uid 用户uid
 @param goods_id 商品id
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)goodsDetailUid:(NSString *)uid goods_id:(NSString *)goods_id succ:(businessSucc)succ fail:(businessFail)fail;



/**
 商品收藏与取消

 @param uid 用户uid
 @param goods_id 商品id
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)goodsCollectState:(NSString *)uid goods_id:(NSString *)goods_id succ:(businessSucc)succ fail:(businessFail)fail;



/**
 店铺中的商品列表

 @param uid 用户uid
 @param user_id 店主uid
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)storeGoodsList:(NSString *)uid user_id:(NSString *)user_id succ:(businessSucc)succ fail:(businessFail)fail;


/**
 我的店铺
 @param uid  用户id
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)getStoreInfoUid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;


/**
 我的店铺交易管理

 @param uid 用户id
 @param succ 请求成功
 @param fail 请求失败
 */
-(void)getStoreBusMangUid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;

- (void)groom:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;

/**
 获取用户积分

 @param uid
 @param succ
 @param fail
 */
- (void)getMyIntegral:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail;
/**
 用户钻石兑换积分

 @param uid
 @param diamonds_coins
 @param succ
 @param fail
 */
- (void)userConisIntegral:(NSString *)uid diamonds_coins:(NSString *)diamonds_coins succ:(businessSucc)succ fail:(businessFail)fail;
/**
 用户积分兑换钻石

 @param uid
 @param integral
 @param succ
 @param fail 
 */
- (void)userIntegralConis:(NSString *)uid integral:(NSString *)integral succ:(businessSucc)succ fail:(businessFail)fail;
// 获取我的柠檬币
- (void)getMyIconWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

//获取我的钻石数量
- (void)getMyDiamondsWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;


// 获取充值列表
- (void)getPayListWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;
- (void)limoPayWithWexinWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

-(void)loginWithSthirdParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;
//Is_first
-(void)IsFirstWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

// 获取主播魅力值
- (void)postStarsCoinsWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

// 获取魅力值排行
- (void)postCharmsRankWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

//获取主播封禁状态
- (void)postHostLiveStatesWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;
//获取系统消息提示
- (void)getLiveNoticeWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail;

- (NSString *)is_NullStringChange:(NSString *)string;

/**
 用户下注池下注金额减少接口

 @param user_id 用户uid
 @param bet_money 用户下注的金额
 @param room_id 房间号
 @param table_number 桌号
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) sendBetInfoToServer:(NSString *)user_id bet_money:(NSString *)bet_money room_id:(NSString *)room_id table_number:(NSString *)table_number succ:(businessSucc)succ fail:(businessFail)fail;


/**
 获取下注池金额

 @param user_id <#user_id description#>
 @param bet_money <#bet_money description#>
 @param room_id <#room_id description#>
 @param table_number <#table_number description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) getUserManayToBetroom_id:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;

/**
 请求发牌

 @param room_id <#room_id description#>
 */
- (void) requestUserDiceData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 发牌数据接口

 @param room_id <#room_id description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requestListData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 用户刷新自己积分

 @param user_id <#user_id description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requestUserIntegral:(NSString *)user_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 请求清除上吧数据

 @param room_id <#room_id description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requestNextDataDeletace:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 请求游戏处于什么状态

 @param room_id <#room_id description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requestGamesData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 添加游戏状态

 @param room_id <#room_id description#>
 @param bet_count_down <#bet_count_down description#>
 @param rest_count_down <#rest_count_down description#>
 @param game_state <#game_state description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) addGamesState:(NSString *)room_id bet_count_down:(NSString *)bet_count_down rest_count_down:(NSString *)rest_count_down game_state:(NSString *)game_state succ:(businessSucc)succ fail:(businessFail)fail;
/**
 获取每桌下注金额

 @param room_id <#room_id description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requestNumberManay:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail;
/**
 用户下注金额减少接口

 @param room_id <#room_id description#>
 @param bet_money <#bet_money description#>
 @param user_id <#user_id description#>
 @param table_number <#table_number description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) requesetDiceRoom:(NSString *)room_id bet_money:(NSString *)bet_money user_id:(NSString *)user_id table_number:(NSString *)table_number succ:(businessSucc)succ fail:(businessFail)fail;

























@end
