//
//  NSString+IMB.h
//  ArtPraise
//
//  Created by 闫建刚 on 14-6-1.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "IMB_GTMBase64.h"


@interface NSString (IMB)

/**  --# 通用处理 ↓ #--  **/

/**
 *  去掉字符串两边的空格
 *
 *  @return 截取空格后的字符串
 */
-(NSString*)trim;

/**
 *  判断字符串是否为空(nil,@"",@"null",Null)
 *
 *  @param string 检查的字符串
 *
 *  @return 判断结果
 */
+(BOOL)emptyValidate:(NSString*)string;

/**
 *  计算字节长度
 *
 *  @return 字节长度
 */
- (NSInteger)byteLen;

// 截取指定字符数量，超出字符用“...”填充
- (NSString*)cutDownCharacters:(int)count;

/**  --# 通用处理 ↓ #--  **/


/**  --# 格式转换 ↓ #--  **/

/**
 *  转换为UTF8字符集的NSData对象
 *
 *  @return data对象
 */
- (NSData*)dataForUTF8;


/**
 *  转换成16进制字符串（hex）
 *
 *  @return hex
 */
- (NSString *) hex;

/**
*  从16进制字符串转换为字符串
*
*  @return 转换后的字符串
*/
- (NSString*)hex2str;

/**
 *  字符串以UTF8编码方式执行base64编码
 *
 *  @return 以UTF8编码方式转换的base64字符串
 */
- (NSString *) base64EncodedForUTF8;

/**
 *  字符串以指定编码方式执行base64编码
 *
 *  @param encoding 指定编码集
 *
 *  @return  以UTF8编码方式编码base64字符串
 */
- (NSString *)base64EncodedWithEncoding:(NSStringEncoding)encoding;

/**
 *  字符串以UTF8编码方式执行base64解码
 *
 *  @return 返回解码后的字符串
 */
- (NSString *)  base64DecodeForUTF8;

/**
 *  字符串以指定编码方式执行base64解码
 *
 *  @param encoding 指定编码集
 *
 *  @return  以UTF8编码方式解码base64字符串
 */
- (NSString *)base64DecodedWithEncoding:(NSStringEncoding)encoding;


/**
 *  UTF8编码后的URL
 *
 *  @return UTF8编码后的URL字符串
 */
- (NSString *)encodedURLForUTF8;

/**
 *  按照指定的编码转换URL
 *
 *  @param encoding 编码解
 *
 *  @return 编码后的URL
 */
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

/**  --# 格式转换 ↑ #--  **/

/**  --# 编码转换 ↓ #--  **/

/**
 *  转换为GBK编码数据
 *
 *  @return 返回GBK编码数据
 */
- (NSData*)toGBKEncodingData;

/**  --# 编码转换 ↑ #--  **/

/**  --# 加解密 ↓ #--  **/

/**
 *  md5加密
 *
 *  @return MD5加密后的字符串
 */
- (NSString *) md5;

/**
 *  MD5加密转base64
 *
 *  @return MD5加密后转base64
 */
- (NSString *) md52base64;

/**
 *  SHA1加密
 *
 *  @return SHA1加密后的字符串
 */
- (NSString *) sha1;

/**
 *  SHA1加密转base64字符串
 *
 *  @return SHA1加密后转base64
 */
- (NSString *) sha12base64;

/**
 *  3DES加解密
 *
 *  @param encryptOrDecrypt   kCCEncrypt/kCCDecrypt（加密/解密）
 *
 *  @return 返回加密或解密后的结果
 */
- (NSString*)tripleDesForEncryptOrDecrypt: (CCOperation)encryptOrDecrypt;

/**  --# 加解密 ↑ #--  **/

/**
 *  字符串转对象 add by gcz
 *
 *  @return 生成对象
 */
-(id)JSONValue;

/**
 *  对象转json字符串 add by gcz
 *
 *  @param  obj   要解析的对象
 *  @return 生成的json字符串
 */
+ (NSString *)JSONString:(id)obj;

/**
 *  所搜索字符串在内容中找到与之完全相符的字符串时 返回YES（非模糊查询）
 *  add by gcz 14.7.2
 *
 *  @param str 搜索的字符串
 *
 *  @return YES 相符 NO 不相符
 */
- (BOOL)stringContainsAnotherStringEqualSearch:(NSString *)str;

/**
 *  所搜索字符串在内容中找到其所有单个字符时 返回YES（模糊查询）
 *  add by gcz 14.7.2
 *
 *  @param str 搜索字符串
 *
 *  @return YES 相符 NO 不相符
 */
- (BOOL)stringContainsAnotherStringFuzzySearch:(NSString *)str;

/**
 *  判断本身是否由纯数字构成
 *
 *  @return YES 是纯数字 NO 非纯数字
 */
- (BOOL)isPureDigital;

/**
 *  验证是否是有效数字（整数、浮点数）
 *
 *  @return YES 是 NO 不是有效
 */
- (BOOL)isValidFloat;

// 6-12位，字母下划线和数字组成，开头不能为数字
- (BOOL)isValidUserName;
// 只支持英文、数字、汉字
- (BOOL)isValidNickName;

/**
 *  根据文件名拼接路径
 *
 *  @param fileName 文件名
 *
 *  @return 文件路径
 */
+(NSString *)documentPathWith:(NSString *)fileName;

// 获取当前日期 add by gcz 14.10.16
+ (NSString *)currentDate;
+ (NSString *)currentDateWithFormat:(NSString *)format;

/**
 *  字符串转date (deprecated)
 *
 *  @param format 时间格式
 *
 *  @return 时间date
 */
- (NSDate *)convertToDateWithFormat:(NSString *)format;

/**
 *  给某段字符串着色
 *
 *  @param distString 需要着色的一段字符串
 *  @param textColor  颜色
 *  @param font       字体
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)distinctString:(NSString *)distString withColor:(UIColor *)textColor font:(UIFont *)font;

/**
 *  给某段字符串着色
 *
 *  @param distString 需要着色的一段字符串
 *  @param textColor  颜色
 *  @param font       字体
 *  @param fromBack   YES 从字符串尾部搜索distString NO 则为正序搜索
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)distinctString:(NSString *)distString withColor:(UIColor *)textColor font:(UIFont *)font fromBack:(BOOL)fromBack;

+ (NSString *)imgFullUrl:(NSString *)url;

@end
