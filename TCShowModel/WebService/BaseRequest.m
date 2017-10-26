//
//  BaseRequest.m
//
//
//  Created by Alexi on 14-8-4.
//  Copyright (c) 2014年 Alexi Chen. All rights reserved.
//

#import "BaseRequest.h"


// =========================================

@implementation BaseRequest

- (void)dealloc
{
    
}

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler
{
    if (self = [self init])
    {
        self.succHandler = succHandler;
    }
    return self;
}

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail
{
    if (self = [self initWithHandler:succHandler]) {
        self.failHandler = fail;
    }
    return self;
}

- (NSString *)url
{
    return nil;
}


- (BaseResponse *)response
{
    if (!_response)
    {
        _response = [[[self responseClass] alloc] init];
    }
    return _response;
}


- (NSDictionary *)packageParams
{
    return nil;
}
- (NSData *)toPostJsonData
{
    NSDictionary *dic = [self packageParams];
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            
        }
        else
        {
            
        }
        return data;
    }
    else
    {
        
    }
    return nil;
}


- (void)parseResponse:(NSObject *)respJsonObject
{
    if (respJsonObject)
    {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 子线程解析数据
            if (_succHandler)
            {
                // todo handle body
                if ([respJsonObject isKindOfClass:[NSDictionary class]])
                {
                    [self parseDictionaryResponse:(NSDictionary *)respJsonObject];
                }
                else if ([respJsonObject isKindOfClass:[NSArray class]])
                {
                    [self parseArrayResponse:(NSArray *)respJsonObject];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[HUDHelper sharedInstance] tipMessage:@"返回数据格式有误" delay:2 completion:^{
                            // 说明返回内容有问题
                            if (_failHandler)
                            {
                                _failHandler(self);
                            }
                        }];
                        
                    });
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([_response success])
                    {
                        if (_succHandler)
                        {
                            _succHandler(self);
                        }
                    }
                    else
                    {
                        [[HUDHelper sharedInstance] tipMessage:[_response message] delay:2 completion:^{
                            // 返回的数据有业务错误
                            if (_failHandler)
                            {
                                _failHandler(self);
                            }
                        }];
                    }
                   
                });
            }
//            else
//            {
//
//            }
        });
    }
    else
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 说明返回内容有问题
            if (_failHandler)
            {
                _failHandler(self);
            }
        });
    }
}

- (Class)responseClass;
{
    return [BaseResponse class];
}

- (Class)responseDataClass
{
    return [BaseResponseData class];
}

- (void)parseDictionaryResponse:(NSDictionary *)bodyDic
{
    _response = [[[self responseClass] alloc] init];
    _response.errorCode = [bodyDic[@"code"] integerValue];
    _response.errorInfo = bodyDic[@"message"];
    
    NSDictionary *data = bodyDic[@"data"];
    _response.data = [self parseResponseData:data];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}

- (void)parseArrayResponse:(NSArray *)bodyDic
{
    
}

@end

// =========================================


@implementation BaseResponseData

@end


@implementation BaseResponse

- (instancetype)init
{
    if (self = [super init])
    {
        // 默认成功
        _errorCode = 200;
    }
    return self;
}

- (BOOL)success
{
    return _errorCode == 200;
}
- (NSString *)message
{
    return _errorInfo;
}

@end

// =========================================
