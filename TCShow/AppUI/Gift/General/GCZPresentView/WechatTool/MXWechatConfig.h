/**
 @@create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 @return 配置文件
 */
#ifndef MXWechatConfig_h
#define MXWechatConfig_h

//#import "WXApi.h"
#import "WXApiManager.h"
#import "MXWechatPayHandler.h"  //微信支付调用类
#import "MXWechatSignAdaptor.h" //微信签名工具类
#import "XMLDictionary.h"       //XML转换工具类

/**
 -----------------------------------
 微信支付需要配置的参数
 -----------------------------------
 */

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"


// 开放平台登录https://open.weixin.qq.com的开发者中心获取APPID
#define MXWechatBaseUrl     @"https://api.weixin.qq.com/sns"

#define MXWechatAPPID       @"wx6846e27866f95324"
// 开放平台登录https://open.weixin.qq.com的开发者中心获取AppSecret。
#define MXWechatAPPSecret   @"7d95fb63dd550c648fd3114da9e574e0"
// 微信支付商户号
#define MXWechatMCHID       @"1450618302"
// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com
// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define MXWechatPartnerKey  @"898d70dede1d3f271f0ab09700f2b4ae"


// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define UMENG_APPID  @"58cb8eb3717c1974ac00044d"

/**
 -----------------------------------
 微信下单接口
 -----------------------------------
 */

#define kUrlWechatPay       @"https://api.mch.weixin.qq.com/pay/unifiedorder"


/**
 -----------------------------------
 统一下单请求参数键值
 -----------------------------------
 */

#define WXAPPID         @"appid"            // 应用id
#define WXMCHID         @"mch_id"           // 商户号
#define WXNONCESTR      @"nonce_str"        // 随机字符串
#define WXSIGN          @"sign"             // 签名
#define WXBODY          @"body"             // 商品描述
#define WXOUTTRADENO    @"out_trade_no"     // 商户订单号
#define WXTOTALFEE      @"total_fee"        // 总金额
#define WXEQUIPMENTIP   @"spbill_create_ip" // 终端IP
#define WXNOTIFYURL     @"notify_url"       // 通知地址
#define WXTRADETYPE     @"trade_type"       // 交易类型
#define WXPREPAYID      @"prepay_id"        // 预支付交易会话

#endif /* MXWechatConfig_h */
