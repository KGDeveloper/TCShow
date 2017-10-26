//
//  AllGifts.m
//  TCShow
//
//  Created by wxt on 2017/6/3.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "AllGifts.h"

@implementation Gift
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"name":@"p",
             @"imageName":@"i"
             };
}

-(NSInteger)type
{
    NSScanner *scanner = [NSScanner scannerWithString:self.imageName];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    return number;
}
- (NSInteger)coin
{
    NSScanner *scanner = [NSScanner scannerWithString:self.name];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    return number;
}
@end
@implementation AllGifts
+(NSArray <Gift*> *)AllGifts{
    static dispatch_once_t onceToken;
    static NSArray <Gift*>* array;
    dispatch_once(&onceToken, ^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"gift" ofType:@"plist"];
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        array = [Gift mj_objectArrayWithKeyValuesArray:data];

    });
    return array;
}
@end
