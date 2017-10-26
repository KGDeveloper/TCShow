//
//  CustomElemCmd.m
//  TIMChat
//
//  Created by wilderliao on 16/6/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CustomElemCmd.h"

@implementation CustomElemCmd

- (instancetype)initWith:(NSInteger)command
{
    if (self = [super init])
    {
        _userAction = command;
    }
    return self;
}

- (instancetype)initWith:(NSInteger)command param:(NSString *)param
{
    if (self = [super init])
    {
        _userAction = command;
        _actionParam = param;
    }
    return self;
}

+ (instancetype)parseCustom:(TIMCustomElem *)elem
{
    NSData *data = elem.data;
    if (data)
    {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        CustomElemCmd *parse = [NSObject parse:[CustomElemCmd class] jsonString:dataStr];
        if (parse.msgType == EIMAMSG_InputStatus || parse.msgType == EIMAMSG_SaftyTip)
        {
            parse.customInfo = [parse.actionParam objectFromJSONString];
            
            return parse;
        }
    }
    
   
    return nil;
    
}

- (NSData *)packToSendData
{
    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    [post setObject:@(_userAction) forKey:@"userAction"];
    
    if (_actionParam && _actionParam.length > 0)
    {
        [post setObject:_actionParam forKey:@"actionParam"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:post])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:post options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
           
            return nil;
        }
        
        
        return data;
    }
    else
    {
     
        return nil;
    }
}

- (void)prepareForRender
{
    // 因不用于显示，作空实现
    // do nothing
}

- (NSInteger)msgType
{
    return _userAction;
}

@end
