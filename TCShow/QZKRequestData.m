//
//  QZKRequestData.m
//  TCShow
//
//  Created by  m, on 2017/9/12.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKRequestData.h"

@implementation QZKRequestData

+(void)postDataNetWorkingWitData:(NSDictionary *)dataDic success:(void (^)(id netReturn))block{
    
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.requestSerializer.timeoutInterval =20;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    [manager POST:LIVE_HIDE parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        block(responseObject);
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];

    
}

@end
