//
//  CheckNumInput.m
//  live
//
//  Created by admin on 16/5/27.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "CheckNumInput.h"

@implementation CheckNumInput
+(BOOL)checkPhoneNumber:(NSString *)telNumber{
    NSString*pattern =@"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
@end
