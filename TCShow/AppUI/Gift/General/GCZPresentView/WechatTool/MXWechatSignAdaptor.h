/**
 @@create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 @return MXWechatSignAdaptor（微信签名工具类）
 */

#import <Foundation/Foundation.h>

@interface MXWechatSignAdaptor : NSObject

@property (nonatomic,strong) NSMutableDictionary *dic;

/**
 重新初始化方法

 @param wechatAppId 微信开放平台的id
 @param wechatMCHId 微信商户号
 @param tradeNo 随机字符串变量 这里最好使用和安卓端一致的生成逻辑
 @param wechatPartnerKey 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串
 @param payTitle 支付标题
 @param orderNo 随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
 @param totalFee 总价格
 @param deviceIp 设备Id地址
 @param notifyUrl 交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
 @param tradeType 交易类型
 @return 保存字典返回
 */
- (instancetype)initWithWechatAppId:(NSString *)wechatAppId
                        wechatMCHId:(NSString *)wechatMCHId
                            tradeNo:(NSString *)tradeNo
                   wechatPartnerKey:(NSString *)wechatPartnerKey
                           payTitle:(NSString *)payTitle
                           orderNo :(NSString *)orderNo
                           totalFee:(NSString *)totalFee
                           deviceIp:(NSString *)deviceIp
                          notifyUrl:(NSString *)notifyUrl
                          tradeType:(NSString *)tradeType;

///创建发起支付时的SIGN签名(二次签名)
- (NSString *)createMD5SingForPay:(NSString *)appid_key
                        partnerid:(NSString *)partnerid_key
                         prepayid:(NSString *)prepayid_key
                          package:(NSString *)package_key
                         noncestr:(NSString *)noncestr_key
                        timestamp:(UInt32)timestamp_key;
@end
