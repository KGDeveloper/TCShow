//
//  NSString+IMB.m
//  ArtPraise
//
//  Created by 闫建刚 on 14-6-1.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//

#import "NSString+IMB.h"


@implementation NSString (IMB)

/**  --# 通用处理 ↓ #--  **/

// 去掉字符串两边的空格
-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//判断字符串是否为空(nil,Null,@"null",@"")
+(BOOL)emptyValidate:(NSString *)string{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string trim] isEqualToString:@"null"]) {
        return YES;
    }
    if ([string trim].length == 0) {
        return YES;
    }
    return NO;
}


// 计算字节长度
- (NSInteger)byteLen{
    NSInteger strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

// 截取指定字符数量，超出字符用“...”填充
- (NSString*)cutDownCharacters:(int)count{
    if ([self length]>count) {
        return [[self substringToIndex: count]stringByAppendingString:@"..."];
    }
    return self;
}

/**  --# 通用处理 ↓ #--  **/


/**  --# 格式转换 ↓ #--  **/

// 转换为UTF8字符集的NSData对象
- (NSData*)dataForUTF8{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// 转换成16进制字符串（hex）
- (NSString *) hex{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

// 从16进制字符串转换为字符串
- (NSString*)hex2str{
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
//    DDLogInfo(@"------字符串=======%@",unicodeString);
    return unicodeString;
}


// ------------------------ Base64 编/解码 ↓ ---------------------------

// 字符串以UTF8编码方式转换base64
- (NSString *) base64EncodedForUTF8{
    return [self base64EncodedWithEncoding:NSUTF8StringEncoding];
}

// 字符串以指定编码方式转换base64
- (NSString *)base64EncodedWithEncoding:(NSStringEncoding)encoding
{
    
    NSData * data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    // 转换到base64
//    data = [IMB_GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

// 字符串以UTF8编码方式执行base64解码
- (NSString *)  base64DecodeForUTF8;{
    return [self base64DecodedWithEncoding:NSUTF8StringEncoding];
}

// 字符串以指定编码方式执行base64解码
- (NSString *)base64DecodedWithEncoding:(NSStringEncoding)encoding{
    NSData * data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    // 转换到base64
//    data = [IMB_GTMBase64 decodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
// ------------------------ Base64 编/解码 ↑ ---------------------------

// UTF8编码后的URL
- (NSString*)encodedURLForUTF8{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

//按照指定的编码转换URL
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("%[]￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding) ;
}

// 转换为中文字符集数据
- (NSData*)toGBKEncodingData{
    NSData *nsData = [self dataUsingEncoding:ENCODING_FOR_GB];
    return nsData;
}

/**  --# 格式转换 ↑ #--  **/


/**  --# 加解密 ↓ #--  **/

// md5加密
- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

// SHA1加密
- (NSString *) sha1{
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
    
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

// SHA1加密转base64字符串
- (NSString *) sha12base64{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    base64 = [IMB_GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

// MD5加密转base64
- (NSString *) md52base64{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
//    base64 = [IMB_GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}


//3des加解密
#define DESKEY   @"这里是加解密使用的密钥"
- (NSString*)tripleDesForEncryptOrDecrypt: (CCOperation)encryptOrDecrypt;
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    
    {
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *) [DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) ;
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [IMB_GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}
/**  --# 加解密 ↓ #--  **/

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil){
        return nil;
    }
    return result;
}

+ (NSString *)JSONString:(id)obj
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:obj
                                                options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:result
                                                 encoding:NSUTF8StringEncoding];
    if (error != nil){
        return nil;
    }
    return jsonString;
}

//所搜索字符串在内容中找到与之完全相符的字符串时 返回YES
- (BOOL)stringContainsAnotherStringEqualSearch:(NSString *)str
{
    NSInteger num = str.length;
    BOOL result = NO;
    for (int i = 0; i < self.length - str.length + 1; i ++) {
        NSRange range;
        range.length = num;
        range.location = i;
        NSString *s = [self substringWithRange:range];
        if ([s isEqualToString:str]) {
            result = YES;
        }
    }
    return result;
}
//所搜索字符串在内容中找到其所有单个字符时 返回YES
- (BOOL)stringContainsAnotherStringFuzzySearch:(NSString *)str
{
    int resultNum = 0;
    for (int i = 0; i < str.length; i ++) {
        NSRange range;
        range.length = 1; //截取长度一位
        range.location = i; //从第i个字符截取
        NSString *s1 = [str substringWithRange:range];  //截取str的一块肉
        for (int j = 0; j < self.length; j ++) {
            NSRange range;
            range.length = 1;
            range.location = j;
            NSString *s2 = [self substringWithRange:range];
            if ([s1 isEqualToString:s2]) {
                resultNum ++;
                break;
            }
        }
    }
    if (resultNum == str.length) {
        return YES;
    }
    return NO;
}

// 判断本身是否为纯数字构成
- (BOOL)isPureDigital
{
    NSString *pureReg = @"\\d+"; //+ 一次或多次匹配前面的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pureReg];
    BOOL isPure = [predicate evaluateWithObject:self];
    return isPure;
}

// 验证是否是有效数字（整数、浮点数）
//- (BOOL)isValidFloat
//{
//    BOOL isFloat = [self isMatchedByRegex:@"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$"];
//    BOOL isDigital = [self isPureDigital];
//    return (isFloat | isDigital);
//}

// 6-12位，字母下划线和数字组成，开头不能为数字
//- (BOOL)isValidUserName
//{
//    BOOL isValid = [self isMatchedByRegex:@"^[a-zA-Z][a-zA-Z0-9_]{5,11}$"];
//    return isValid;
//}

// 只支持英文、数字、汉字
//- (BOOL)isValidNickName
//{
//    BOOL isValid = [self isMatchedByRegex:@"^[\u4E00-\u9FA5A-Za-z0-9]+$"];
//    return isValid;
//}

// 拼接路径
+(NSString *)documentPathWith:(NSString *)fileName
{
    
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}

// 获取当前日期 add by gcz 14.10.16
+ (NSString *)currentDate
{
    //获取日期 并转换格式
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"M月d日 ahh:mm";
    
    //设置为中国格式输出
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)currentDateWithFormat:(NSString *)format
{
    //获取日期 并转换格式
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = format;
    
    //设置为中国格式输出
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    return dateString;
}

- (NSDate *)convertToDateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : format];
    
    NSDate *dateTime = [formatter dateFromString:self];
    return dateTime;
}

// 给某段字符串着色 正序
- (NSMutableAttributedString *)distinctString:(NSString *)distString withColor:(UIColor *)textColor font:(UIFont *)font
{
    
    return [self distinctString:distString withColor:textColor font:font fromBack:NO];
    
//    NSMutableAttributedString * totalAttrStr = [[NSMutableAttributedString alloc] initWithString:self];
//    //获取字符串range(一定范围)
//    NSRange range = [self rangeOfString:distString];
//    if (range.location != NSNotFound) {
//        //字体(一定范围)
//        [totalAttrStr addAttribute:NSFontAttributeName value:font range:range];
//        //颜色(一定范围)
//        [totalAttrStr addAttribute:NSForegroundColorAttributeName value:textColor range:range];
//    }
//    
//    return totalAttrStr;
}

- (NSMutableAttributedString *)distinctString:(NSString *)distString withColor:(UIColor *)textColor font:(UIFont *)font fromBack:(BOOL)fromBack
{
    NSMutableAttributedString * totalAttrStr = [[NSMutableAttributedString alloc] initWithString:self];
    //获取字符串range(一定范围)
    if (!distString) {
        return nil;
    }
    NSRange range = [self rangeOfString:distString];
    if (range.location == NSNotFound) {
        return nil;
    }
    if (fromBack) {
        range = [self rangeOfString:distString options:NSBackwardsSearch];
    }
    if (range.location != NSNotFound) {
        //字体(一定范围)
        [totalAttrStr addAttribute:NSFontAttributeName value:font range:range];
        //颜色(一定范围)
        [totalAttrStr addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    }
    
    return totalAttrStr;
}

+ (NSString *)imgFullUrl:(NSString *)url
{
    if ([url hasPrefix:@"http"]) {
        return url;
    }
    // 101.201.197.104/angel/index.php
    NSString *domainStr = [[API_PICTURE componentsSeparatedByString:@"/"] firstObject];
    if ([url hasPrefix:@"/data"]) {
        return [NSString stringWithFormat:@"http://%@%@",domainStr,url];
    }
    return [NSString stringWithFormat:@"http://%@%@",domainStr,url]; // 101.201.197.104
}


@end
