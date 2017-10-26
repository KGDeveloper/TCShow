//
//  Macro.h
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#ifndef live_Macro_h
#define live_Macro_h

#import "TCShow-Prefix.pch"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCALE ([UIScreen mainScreen].scale)
//状态栏、导航栏、标签栏高度
#define STATUS_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATIONBAR_HEIGHT (self.navigationController.navigationBar.frame.size.height)
#define TABBAR_HEIGHT (self.tabBarController.tabBar.frame.size.height)

//字体颜色
#define COLOR_FONT_RED   0xD54A45
#define COLOR_FONT_WHITE 0xFFFFFF
#define COLOR_FONT_LIGHTWHITE 0xEEEEEE
#define COLOR_FONT_DARKGRAY  0x555555
#define COLOR_FONT_GRAY  0x777777
#define COLOR_FONT_LIGHTGRAY  0x999999
#define COLOR_FONT_BLACK 0x000000

//背景颜色
#define COLOR_BG_GRAY      0xEDEDED
#define COLOR_BG_ALPHABLACK     0x88000000
#define COLOR_BG_ORANGE 0xf69e21
#define COLOR_BG_ALPHARED  0x88D54A45
#define COLOR_BG_LIGHTGRAY 0xEEEEEE
#define COLOR_BG_ALPHAWHITE 0x55FFFFFF
#define COLOR_BG_WHITE     0xFFFFFF
#define COLOR_BG_DARKGRAY     0xAFAEAE
#define COLOR_BG_RED       0xD54A45
#define COLOR_BG_BLUE      0x4586DA
#define COLOR_BG_CLEAR     0x00000000

// 薛荣荣 ***************************************************************
//主色调
#define LEMON_MAINCOLOR [UIColor colorWithRed:252/255.0 green:174/255.0 blue:20/255.0 alpha:1]
// 按钮颜色
#define BTN_BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:88/255.0 blue:71/255.0 alpha:1]
// view的背景色
#define VIEW_BACKGROUNDCOLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
// line 颜色
#define BOARD_COLOR [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]

#define CELL_IMAGE_HEIGHT (([UIScreen mainScreen].bounds.size.height)/568)*290

// 登录之后返回的个人信息 key
#define KEY_FOR_USER_INFO @"KEY_FOR_USER_INFO"

// 网络请求成功code
#define URLREQUEST_SUCCESS 0

#define WXPaySUCC @"WXPaySUCC"
#define WXPayFail @"WXPayFail"
#define WXLogSUCC @"WXLogSUCC"
#define WXLogFail @"WXLogFail"

// ********************************************************************

// rbg转UIColor(16进制)
#define YCColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA16(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbaValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbaValue & 0xFF))/255.0 alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

//url
//已经是群成员
#define URL_REQUEST_SUCCESS 200
#define URL_NORMAL_REQUEST_SUCCESS 0
#define URL_ROOM_CLOSE 562
#define URL_REGISTER_FAIL 561
#define URL_REGISTER_PHONEUSED 562
#define URL_REGISTER_NAMEUSED 563
#define URL_REGISTER_NOIMAGE 260
#define URL_SAVEUSER_NOIMAGE 260
#define URL_SAVE_NAMEUSED 562
#define URL_REQUEST_NO_DATA 400
//入口
#define kForLeaderBeta 0




// 测试地址
#define URL_ENTRY @"http://47.93.32.34:8081/index.php"
//
#define IMG_PREFIX @"http://47.93.32.34:8081"

//#define URL_ENTRY @"192.168.1.115"


//正式地址

//#define URL_ENTRY @"http://47.93.32.34/index.php"
//
//#define IMG_PREFIX @"http://47.93.32.34"

//#else
//#define URL_ENTRY @"http://gugegm.com/index.php"
//#define IMG_PREFIX @"http://gugegm.com%@"
//#endif
#define API_PICTURE @"http://lem.ningmengtv.net"
#define IMG_APPEND_PREFIX(url) [IMG_PREFIX stringByAppendingString:url]


#define URL_ENTRYY @"http://101.201.197.104/guge"
//获取用户信息
#define URL_INFO [URL_ENTRY stringByAppendingString:@"/appapi/Independent/user_info"]
//修改昵称，头像
#define URL_CHANGEICON [URL_ENTRY stringByAppendingString:@"/appapi/Independent/update_info"]
//关注列表
#define URL_CONCERNLIST [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/followLists"]



//主播心跳包
#define URL_Heart [URL_ENTRY stringByAppendingString:@"/appapi/live/Heartbeat"]

//心跳检测
#define URL_HEARTTIME [URL_ENTRY stringByAppendingString:@"/update_heart.php"]

//心跳检测
#define URL_FORCASTREPORT [URL_ENTRY stringByAppendingString:@"/forcast_report.php"]




//直播列表
#define URL_LIVELIST [URL_ENTRY stringByAppendingString:@"/appapi/live/live_list"]
//最新直播列表
#define URL_NEWLIVELIST [URL_ENTRY stringByAppendingString:@"/appapi/live/live_recommend_create_time"]
//主推直播列表
#define URL_MAINTOPLIVELIST [URL_ENTRY stringByAppendingString:@"/appapi/live/live_recommend_charm"]
//关注直播列表
#define URL_FOLLOWLIVELIST [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/page_ifollow"]
//预告列表
#define URL_TRAILERLIST [URL_ENTRY stringByAppendingString:@"/live_forcastlist.php"]
//获取房间号
#define URL_GETROOMID [URL_ENTRY stringByAppendingString:@"/appapi/live/roomnum"]
//创建房间
#define URL_CREATELIVE [URL_ENTRY stringByAppendingString:@"/appapi/live/create"]
//上传直播封面
#define URL_LIVECOVER [URL_ENTRY stringByAppendingString:@"/appapi/Independent/img_uploads"]
//创建预告
#define URL_CREATETRAILER [URL_ENTRY stringByAppendingString:@"/live_forcastcreate.php"]
//关闭房间
#define URL_CLOSELIVE [URL_ENTRY stringByAppendingString:@"/appapi/live/delroom"]
//进入房间
#define URL_ENTERROOM [URL_ENTRY stringByAppendingString:@"/enter_room.php"]
//登录
#define URL_LOGIN [URL_ENTRY stringByAppendingString:@"/Appapi/User/login"]
//注册
#define URL_REGISTER [URL_ENTRY stringByAppendingString:@"/register.php"]
//获取用户信息
#define URL_GETUSER [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/user_info"] // /appapi/live/userinfo edit by gcz 2016-06-07 14:11:25
//修改用户信息
#define URL_SAVEUSER [URL_ENTRY stringByAppendingString:@"/user_saveinfo.php"]
//获取图片url
#define URL_IMAGE [URL_ENTRY stringByAppendingString:@"/image_get.php?imagepath=%@&width=%d&height=%d"]
//点赞
#define URL_PRAISE [URL_ENTRY stringByAppendingString:@"/live_addpraise.php"]
//crash上报
#define URL_LOGREPORT [URL_ENTRY stringByAppendingString:@"/log.php"]
//批量获取用户
#define URL_USERLIST [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/group_member_info"]
//获取特定房间信息
#define URL_LIVEINFO [URL_ENTRY stringByAppendingString:@"/live_infoget.php"]


//Live举报
#define URL_LIVEREPORT [URL_ENTRY stringByAppendingString:@"/appapi/user/complain_master"]


//修改个人信息接口

#define userInfoUrl [URL_ENTRY stringByAppendingString:@"/Appapi/edituser/edit"]
//上传头像
#define imageIconUrl [URL_ENTRY stringByAppendingString:@"/appapi/edituser/index"]

//获取用户信息
#define userInfoDelUrl [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/user_info"]

//获取用户详细信息
#define getUserInfoDelUrl [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/userInfo"]
//获取头像
#define addImageIconUrl [URL_ENTRY stringByAppendingString:@"/appapi/edituser/index"]

//首页轮播图
#define  HOME_SHUFFLING_Figure [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/Carousel"]
//商品类型
#define HOME_GOODS_TYPE [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/get_goodstype"]

//商品管理
#define GOODS_MANAGE_URL [URL_ENTRY stringByAppendingString:@"/appapi/Goods/goods_manager"]

//添加商品到店铺
#define STORE_ADD_GOODS [URL_ENTRY stringByAppendingString:@"/appapi/Goods/add_good"]

//我的店铺
#define STORE_MY_INFO [URL_ENTRY stringByAppendingString:@"/appapi/Goods/MyStore"]

//我的店铺交易管理
#define STORE_BUSINESS_MANAGE [URL_ENTRY stringByAppendingString:@"/appapi/Goods/deal_manager"]

//热门搜索
#define HOME_HOT_SEARCH [URL_ENTRY stringByAppendingString:@"/appapi/Goodcategory/hot_goodscatgory"]
//全部分类
#define SHOP_CLASS [URL_ENTRY stringByAppendingString:@"/appapi/Goodcategory/Allcatgory"]
//分类查询商品
#define SHOP_CLASS_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Goods/categorylist"]

//主播推荐(5条)
#define LIVE_SEARCH_RECOMMEND [URL_ENTRY stringByAppendingString:@"/appapi/Live/search_recommend"]
//主播推荐(5条)
#define LIVE_SEARCH_HOSTLIST [URL_ENTRY stringByAppendingString:@"/appapi/Live/search"]

//热门主播列表(10条)
#define LIVE_SEARCH_HOTLIST [URL_ENTRY stringByAppendingString:@"/appapi/Live/search_hot"]
//首页搜索
#define HOME_SEARCH [URL_ENTRY stringByAppendingString:@"/appapi/Goodcategory/search"]


// 新接口  薛荣荣*******************************************************

// 获取验证码
#define GET_CODE [URL_ENTRY stringByAppendingString:@"/appapi/Independent/getcode"]

// 验证手机短信验证码
#define VERIFY_CODE [URL_ENTRY stringByAppendingString:@"/appapi/Independent/verify"]
//注册
#define REGISTER [URL_ENTRY stringByAppendingString:@"/appapi/user/register"]
//登录
#define MINE_LOGIN [URL_ENTRY stringByAppendingString:@"/appapi/user/login"]

//腾讯云sign登录
#define MINE_LOGIN_SIGN [URL_ENTRY stringByAppendingString:@"/appapi/user/getSig"]

// 搜索直播列表
#define SEARCH_LIVE [URL_ENTRY stringByAppendingString:@"/appapi/live/search"]

//附近的直播
#define LIVE_NEARBY [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/nearlive"]

// 关注直播/取消关注
#define CONCERN_USER_LIVE [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/followHandle"]

// 退出房间时请求的接口，解散房间
#define URL_DEL_ROOM [URL_ENTRY stringByAppendingString:@"/appapi/live/delroom"]

// 修改密码
#define RESET_PASSWORD [URL_ENTRY stringByAppendingString:@"/appapi/user/passwordReset"]

// 获取消息列表
#define GET_MESSAGE_LIST [URL_ENTRY stringByAppendingString:@"/appapi/message/lists"]

// 设置信息为已读
#define SET_MESSAGE_READ [URL_ENTRY stringByAppendingString:@"/appapi/message/read"]

// 返回两个用户的聊天记录
#define GET_HISTORY_MESSAGE [URL_ENTRY stringByAppendingString:@"/appapi/message/meslist"]
// 发送私信
#define SEND_MESSAGE [URL_ENTRY stringByAppendingString:@"/appapi/message"]

// 获取粉丝列表/获取我的关注列表、
#define GET_FUN_LIST [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/followLists"]

// 贡献榜
#define GET_CORNTRIBUTE_LIST [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/top"]

// 提现操作
#define WITHDRAWAL [URL_ENTRY stringByAppendingString:@"/appapi/withdraw/withdraw"]

// 赠送礼物
#define GIFTGIVING [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/sendgift"]

// 加入黑名单
#define ADD_MASK [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/black"]

// 隐私声明/ 收益规则
#define INTRODUCTIONS_TEXT [URL_ENTRY stringByAppendingString:@"/appapi/article/index?"]

// 帮助、文章列表
#define HELP_LIST [URL_ENTRY stringByAppendingString:@"/appapi/article/lists"]

// 帮助文章详情
#define HELP_DETAIL [URL_ENTRY stringByAppendingString:@"/appapi/article/detail?"]



//****************************好友店铺
//正在直播的列表
#define FRIEND_LIVINGLIST [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/livelists"]

//搜索添加好友
#define FRIEND_SEARCH [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/searchfriend"]

//搜索好友店铺中的好友
#define FRIEND_SEARCH_MYCONLIST [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/search_friendname"]

//好友列表
#define FRIEND_LIST [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/friendLists"]

//添加好友
#define FRIEND_ADD [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/add_friend"]

//删除好友
#define FRIEND_DELEGATE [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/del_friend"]
// *******************************************************************

//****************************XX
//关注/取消关注用户
#define FOCUS_UNFOLLOW_USER [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/followHandle"]

//获取用户个人信息
#define GET_USER_INFO [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/user_info"]

//编辑个人资料
#define MODIFY_USER_INFO [URL_ENTRY stringByAppendingString:@"/appapi/ucenter/edit"]

//用户反馈之热门问题
#define RETROACT_HOT [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/retroact_Hot"]

//用户订单列表
#define USER_ORDER_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Cart/getOrderList/"]

//取消订单
#define CANCEL_ORDER [URL_ENTRY stringByAppendingString:@"/appapi/Cart/cancelOrder"]

//收货确认
#define ORDER_CONFIRM [URL_ENTRY stringByAppendingString:@"/appapi/Cart/orderConfirm"]

//购物车列表
#define CART_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Cart/cartList/"]


// 爆款
#define GOODS_STYLISH [URL_ENTRY stringByAppendingString:@"/appapi/Goods/stylish"]

// 新款物品
#define NEW_GOODS_STYLISH [URL_ENTRY stringByAppendingString:@"/appapi/Goods/newlist"]

// 商品详情
#define GOODS_DEAIL [URL_ENTRY stringByAppendingString:@"/appapi/Goods/goodsInfo"]

//店铺中的商品列表
#define STORE_GOODS_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Goods/store_goodlists"]

// 收藏
#define COOLLECTION_URL [URL_ENTRY stringByAppendingString:@"/appapi/Goods/goods_collect"]




//修改购物车商品数量
#define MODIFY_CART_NUM [URL_ENTRY stringByAppendingString:@"/appapi/Cart/edit_cartgoods_num/"]

//删除购物车的商品
#define DELETE_CART [URL_ENTRY stringByAppendingString:@"/appapi/Cart/delCart/"]

//购物车第二步确定页面(结算)
#define CLEARING_CART [URL_ENTRY stringByAppendingString:@"/appapi/Cart/cart2/"]

//在商品详情进行购买第二部确认页面
#define GOODS_CLEARING_CART [URL_ENTRY stringByAppendingString:@"/appapi/Cart/goods_order/"]

//添加商品到购物车
#define Goods_ADD_CART [URL_ENTRY stringByAppendingString:@"/appapi/Cart/addCart/"]

//获取收货地址
#define GET_ADDRESS_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/getAddressList/"]

//添加、编辑收货地址
#define ADD_EDIT_ADDRESS [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/addAddress"]

//获取订单商品价格 或者提交 订单
#define COMMIT_ORDER [URL_ENTRY stringByAppendingString:@"/appapi/Cart/cart3/"]

//获取订单商品价格 或者提交 订单
#define COMMIT_ORDER_CART4 [URL_ENTRY stringByAppendingString:@"/appapi/Cart/cart4/"]

//收藏列表
#define GET_GOODS_COLLECT [URL_ENTRY stringByAppendingString:@"/appapi/Goods/getGoodsCollect"]

//浏览足迹
#define GET_FOOTMARK [URL_ENTRY stringByAppendingString:@"/appapi/Goods/footmark"]

//商品收藏及取消
#define GOODS_FAVORITE_UNFAVORITE [URL_ENTRY stringByAppendingString:@"/appapi/Goods/goods_collect"]

//用户反馈接口
#define USER_RETROACT [URL_ENTRY stringByAppendingString:@"/appapi/Goodstype/user_retroact"]

//获取订单详情
#define GET_ORDER_DETAIL [URL_ENTRY stringByAppendingString:@"/appapi/Cart/getOrderDetail"]

//账单明细
#define BILL_DEATILS [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/Bill_details"]

//多个订单商品添加评论
#define ADD_COMMENT [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/add_comment"]
//评论显示接口
#define COMMENT_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/comment_list"]

//黑名单列
#define BLACK_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/blackLists"]

//拉黑取消操作接口
#define BLACK_OPERATION [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/pullBlack"]


//自定义消息命令
#define MSG_SEPERATOR @"&"
#define MSG_PRAISE @"%@&%d&%d&%d" //userphone&cmd&praisecount&isFirst
#define MSG_ADDUSER @"%@&%d&%@&%@&%@"  //userphone&cmd&username&userlogo&id
#define MSG_DELUSER @"%@&%d" //userphone&cmd
#define MSG_SENDPRESENT @"%@&%d&%@&%@&%d&%d" //userphone&cmd&username&userlogo&type&num
#define MSG_CMD_PRAISE 1
#define MSG_CMD_ADDUSER 2
#define MSG_CMD_DELUSER 3
#define MSG_CMD_SENDPRESENT 12


//const int PRIASE_MSG = 1;
//const int MEMBER_ENTER_MSG = 2;
//const int MEMBER_EXIT_MSG = 3;
#define VIDEOCHAT_INVITE  4
#define YES_I_JOIN  5
#define NO_I_REFUSE 6
#define MUTEVOICE  7
#define UNMUTEVOICE 8
#define MUTEVIDEO  9
#define UNMUTEVIDEO 10

// 取消互动
#define VIDEOCHAT_Cancel_INVITE  11

#define MSG_INVITE_FORMAT @"%@&%d&%@&%@&"


//通知标识
#define NOTIFICATION_IMNETWORK @"NOTIFICATION_IMNETWORK"
#endif

//sdk类型item文本显示
#define LIVE_AVSDK_TYPE_NORMAL @"普通开发SDK业务"
#define LIVE_AVSDK_TYPE_IOTCamera @"普通物联网摄像头SDK业务"
#define LIVE_AVSDK_TYPE_COASTCamera @"滨海摄像头SDK业务"


//获取主播机器人
#define USER_ROBOT [URL_ENTRY stringByAppendingString:@"/Appapi/Ucenter/user_robot"]

//获取柠檬币数量
#define MY_ICON [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/have_charm"]
//获取钻石数量
#define MY_DIAMONDS_COINS [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/diamonds_coins"]

#define PY_LIST [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/coinLists"]
// 明星关注 follows
#define Star_follows [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/follows"]
// 播主魅力值 have_coins
#define Star_coins [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/have_coins"]

// 柠檬订单
#define Limo_Pay [URL_ENTRY stringByAppendingString:@"/appapi/Cart/recharge"]
// 第三方登录
#define Third_Log [URL_ENTRY stringByAppendingString:@"/appapi/user/thirdLogin"]

#define Is_first [URL_ENTRY stringByAppendingString:@"/appapi/user/is_first"]
//魅力值排行榜
#define GIFT_RANKING [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/gift_Ranking"]
//全部主播魅力值排行榜
#define GIFT_ALLRANKING [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/platform_charm_list"]
//主播封禁状态 Ucenter/user_live_disable
#define LIVE_DISABLE [URL_ENTRY stringByAppendingString:@"/appapi/Ucenter/user_live_disable"]
//获取系统通知
#define LIVE_NOTICE [URL_ENTRY stringByAppendingString:@"/appapi/live/live_notice"]

//我的店铺点击
#define STORE_CLICK [URL_ENTRY stringByAppendingString:@"/appapi/Myorder/my_order"]
//http://47.93.32.34:8081/index.php/Appapi/Myorder/my_order/uid/18

//我的店铺点击
#define APPLY_ORDER [URL_ENTRY stringByAppendingString:@"/Appapi/Myorder/apply_order"]

//订单查询
#define MYORDER_ORDER [URL_ENTRY stringByAppendingString:@"/Appapi/Myorder/myorder_order"]

//设置发货
#define MYORDER_SHIPPING [URL_ENTRY stringByAppendingString:@"/Appapi/Myorder/myorder_shipping"]

//申请退换货
#define ORDER_RETURN [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/order_return"]

//退货信息
#define GET_ORDER_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/order_return_list"]

//退货列表
#define ORDER_RETURN_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/order_return_list"]

//售后
#define MYORDER_SELL_AFTER [URL_ENTRY stringByAppendingString:@"/Appapi/Myorder/myorder_sell_after"]

//商家退货审核
#define MYORDER_SELL_UP [URL_ENTRY stringByAppendingString:@"/Appapi/Myorder/myorder_sell_up"]

//请求用户等级小图标
#define LIVE_GRADE [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_grade"] 

//用户退货物流
#define ORDER_RETURN_WL_ADD [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/order_return_wl_add"]

//判断是否隐藏直播
#define LIVE_HIDE [URL_ENTRY stringByAppendingString:@"/Appapi/ucenter/live_hide"]

//==========================骰子游戏==============================
//主播开始玩游戏请求心跳包
#define DICEGAME_STATE_ADD [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dicegame_state_add"]

//用户进入房间获取游戏状态的心跳包
#define DICEGAME_STATE_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dicegame_state_list"]

//用户下注减少金额的接口
#define DICE_USER_INTEGRAL_REDUCE [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dice_user_integral_reduce"]

//下注池金额请求心跳包
#define USER_INTEGRAL_HEARTBEAT [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/user_integral_heartbeat"]

//下一局游戏开始清除上一句游戏数据
#define DICE_SHANG [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dice_shang"]

//用户刷新自己的积分
#define DICE_USER_INTEGRAL [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dice_user_integral"]

//获取骰子数据
#define DICE_LIST_DATA [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dice_list_data"]

//调用摇骰子
#define DICE_LIST [URL_ENTRY stringByAppendingString:@"/Appapi/Dicegame/dice_list"]

/**
 钻石转换积分

 @return
 */
#define USER_COINS_INTEGRAL [URL_ENTRY stringByAppendingString:@"/Appapi/Ucenter/user_coins_integral"]
/**
 积分转换钻石

 @return
 */
#define USER_INTEGRAL_COINS [URL_ENTRY stringByAppendingString:@"/Appapi/Ucenter/user_integral_coins"]
/**
 用户积分

 @return 
 */
#define INTEGRAL [URL_ENTRY stringByAppendingString:@"/Appapi/Ucenter/integral"]


//牛牛游戏接口块==================================================
//用户下注金额减少接口
#define NIUNIU_DICE_USER_INTEGRAL_REDUCE [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_dice_user_integral_reduce"]

//每桌金额总值
#define Niuniu_User_Integral_Heartbeat [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_user_integral_heartbeat"]

//添加游戏状态
#define Niuniu_State_Add [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_state_add"]

//获取游戏状态
#define Niuniu_State_List [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_state_list"]

//游戏下局开始清除上局数据
#define Niuniu_Dice_Shang [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_dice_shang"]

//用户刷新自己的积分
#define Niuniu_Dice_User_Integral [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_dice_user_integral"]

//获取牛牛数据接口
#define Niuniu_Dice_List_Data [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_dice_list_data"]

//发牌接口
#define Niuniu_Dice_List [URL_ENTRY stringByAppendingString:@"/Appapi/Niuniu/niuniu_dice_list"]

//删除商品
#define DELE_GOODS [URL_ENTRY stringByAppendingString:@"/Appapi/goods/dele_goods"]

//======================飘屏以及排行榜接口块============================
//直播间获取大额充值数据接口
#define LIVE_CONINLISTS [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_coinLists"]

//大额充值时生成订单
#define RECHARGE_DE [URL_ENTRY stringByAppendingString:@"/Appapi/Cart/recharge_de"]

//大额充值微信支付接口
#define RWXNOTIFY_DE [URL_ENTRY stringByAppendingString:@"/Appapi/Pay/rwxnotify_de"]

//微信大额充值用户列表
#define LIVE_RECHARGE_LIST_DE [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_recharge_list_de"]

//大额充值所有直播间飘屏接口
#define LIVE_RECHARGE_PP [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_recharge_pp"]

//大礼物飘屏所有直播间
#define LIVE_GIGT_PP [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_gift_pp"]

//消费到指定金额进入直播间开始飘屏
#define LIVE_PP [URL_ENTRY stringByAppendingString:@"/Appapi/Live/live_pp"]



































