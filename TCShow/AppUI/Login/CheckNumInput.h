//
//  CheckNumInput.h
//  live
//
//  Created by admin on 16/5/27.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckNumInput : NSObject
// 匹配手机号
+(BOOL)checkPhoneNumber:(NSString *)telNumber;
@end
