//
//  Business.m
//  live
//
//  Created by hysd on 15/8/6.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "Business.h"
#import "Macro.h"
//#import "GoodsListModel.h"

@interface Business(){
}
@end
@implementation Business
static Business *sharedObj = nil;
+ (Business*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

- (void)loginPhone:(NSString*)phone pass:(NSString*)pass succ:(businessSucc)succ fail:(businessFail)fail
{
   
//    AFHTTPRequestOperationManager *MineManager = [AFHTTPRequestOperationManager manager];
//    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\",\"password\":\"%@\",\"force\":1}", phone, pass];
//    NSDictionary *parameter = @{@"logindata":json,@"version":@"33"};

    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:pass forKey:@"password"];
    [paramsDict safeObj:phone forKey:@"phone"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:MINE_LOGIN parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(URLREQUEST_SUCCESS != code)
        {
            if (code == -4) {
                fail(responseObject[@"message"]);
            }else {
                if (fail)
                {
                    fail(@"账号或密码错误");
                }
            }
            
        }
        else
        {
            if (succ)
            {
                
                succ(@"登录成功",[responseObject objectForKey:@"data"]);
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:responseObject[@"data"][@"id"] forKey:@"uid"];
                [user synchronize];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"登录服务器失败");
        }
    }];
}

//获取腾讯云sign
-(void)getTencentSign:(NSString *)phone succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:phone forKey:@"phone"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:MINE_LOGIN_SIGN parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(URLREQUEST_SUCCESS != code)
        {
            if (fail)
            {
                fail(@"账号错误");
            }
        }
        else
        {
            if (succ)
            {
                succ(@"登录成功",[responseObject objectForKey:@"data"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

//- (void)getRoomnumSucc:(businessSucc)succ fail:(businessFail)fail
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    [manager POST:URL_GETROOMID parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
//        NSDictionary* dic = [responseObject objectForKey:@"data"];
//        if (URL_REQUEST_SUCCESS == code)
//        {
//            if([[dic allKeys] containsObject:@"num"])
//            {
//                if (succ)
//                {
//                    succ(@"获取房间号成功",[dic objectForKey:@"num"]);
//                }
//            }
//            else
//            {
//                if (fail)
//                {
//                    fail(@"没有该字段");
//                }
//            }
//        }
//        else
//        {
//            if (fail)
//            {
//                fail(@"获取房间号失败");
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (fail)
//        {
//            fail(@"获取房间号失败");
//        }
//    }];
//}
//发布直播
- (void)insertLive:(NSString*)tilte latitude:(double)latitude room:(NSInteger)room longitude:(double)longitude addr:(NSString*)addr  chat_room_id:(NSString *)chat_room_id  cover:(NSString *)cover live_type:(NSString *)live_type succ:(businessSucc)succ fail:(businessFail)fail
{
//    NSString* json = [NSString stringWithFormat:@"{\"livetitle\":\"%@\",\"userphone\":\"%@\",\"roomnum\":%ld,\"groupid\":\"%@\",\"addr\":\"%@\"}", tilte,phone,(long)room,chat,addr];
////    json = [NSString stringWithFormat:@"{\"livedata\":%@}",json];
////    NSString *json = @"{\"livetitle\":\"这是一个测试\",\"userphone\":\"13692161101\",\"roomnum\":11780,\"groupid\":\"@TGS#3WAUQPAEV\",\"addr\":\"上海浦东发展银行(高新街支行)\"}";
//    NSDictionary *parameter = @{@"livedata":json};
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = [IMAPlatform sharedInstance].host.profile.imUserId;
    params[@"uid"] = [[SARUserInfo gainUserInfo]objectForKey:@"uid"];
    params[@"title"] = tilte;
    params[@"longitude"] = @(longitude);
    params[@"latitude"] = @(latitude);
    params[@"address"] = addr;
    params[@"chat_room_id"] = chat_room_id;
    params[@"live_type"] = live_type;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URL_CREATELIVE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (0 == [[responseObject objectForKey:@"code"] integerValue]){
            if (succ){
                succ(@"插入直播数据成功",nil);
            }
        }else{
            if (fail){
                fail(@"插入直播数据失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail){
            fail(@"插入直播数据失败");
        }
    }];
    
//    [manager POST:URL_CREATELIVE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        // 上传图片，以文件流的格式
////        [formData appendPartWithFileData: UIImageJPEGRepresentation(image, 0.5) name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
//        {
//            if (succ)
//            {
//                succ(@"插入直播数据成功",nil);
//            }
//        }
//        else
//        {
//            if (fail)
//            {
//                fail(@"插入直播数据失败");
//            }
//        }
//    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//        if (fail)
//        {
//            fail(@"插入直播数据失败");
//        }
//    }];
}

-(void)concernList:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:type forKey:@"type"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_CONCERNLIST parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            if (succ)
            {
                succ(@"成功",responseObject[@"data"]);
            }
        }else{
            
            if (fail)
            {
                
                fail(responseObject[@"message"]);
            }
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        if (fail)
        {
            
            fail(@"加载数据失败");
        }
        
        
    }];
    
    
}

//进入房间
- (void)enterRoom:(NSInteger)room phone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail
{
    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\",\"roomnum\":%ld}",
                      phone,(long)room];
    NSDictionary *parameter = @{@"viewerdata":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_ENTERROOM parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* code = [responseObject objectForKey:@"code"];
        
        
        
        if (URL_REQUEST_SUCCESS == [code intValue])
        {
            if (succ)
            {
                succ(@"进入直播数据成功",code);
            }
        }
        else if(URL_ROOM_CLOSE == [code intValue])
        {
            if (succ)
            {
                succ(@"直播已经离开房间",code);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(@"插入进入直播数据失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            
            fail(@"插入进入直播数据失败");
        }
    }];
}


//获取用户信息
- (void)getUserInfoByPhone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail
{
//    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\"}", phone];
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:phone forKey:@"phone"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_GETUSER parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id infoResponseObject) {
    
        
        if (URL_NORMAL_REQUEST_SUCCESS == [[infoResponseObject objectForKey:@"code"] integerValue])
        {
            NSDictionary* infoDic = [infoResponseObject objectForKey:@"data"];
            if (succ)
            {
                succ(@"获取用户信息成功",infoDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取用户信息失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取用户信息失败");
        }
    }];
}

//获取用户详细信息
-(void)getUserInfoByUid:(NSString *)uid userid:(NSString *)userid succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:userid forKey:@"userid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:getUserInfoDelUrl parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id infoResponseObject) {

        
        if (URL_NORMAL_REQUEST_SUCCESS == [[infoResponseObject objectForKey:@"code"] integerValue])
        {
            NSDictionary* infoDic = [infoResponseObject objectForKey:@"data"];
            if (succ)
            {
                succ(@"获取用户信息成功",infoDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(infoResponseObject[@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取用户信息失败");
        }
    }];

}


//点赞
-(void)loveLive:(NSInteger)room addCount:(int)count succ:(businessSucc)succ fail:(businessFail)fail
{
    NSString* json = [NSString stringWithFormat:@"{\"roomnum\":%ld,\"addnum\":%d}", (long)room, count];
    NSDictionary *parameter = @{@"praisedata":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URL_PRAISE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            if (succ)
            {
                succ(@"",nil);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"");
        }
    }];
}

//离开房间
-(void)upLoadLiveCover:(NSInteger)type phone:(NSString *)phone image:(UIImage *)image succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(type);
    params[@"phone"] = phone;
    [manager POST:URL_LIVECOVER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(image != nil)
            {
                [formData appendPartWithFileData:
                 UIImageJPEGRepresentation(image, 0.5) name:@"img" fileName:[NSString stringWithFormat:@"%@_image.jpg",phone] mimeType:@"image/jpg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (0 == [[responseObject objectForKey:@"code"] integerValue])
            {
                if (succ)
                {
                    succ(@"上传图片成功", responseObject[@"data"]);
                }
            }
            else
            {
                if (fail)
                {
                    fail(@"上传图片失败");
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (fail)
            {
                fail(@"上传图片失败");
            }
    }];
}
-(void)closeRoom:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail{
    NSDictionary *parameter = @{@"av_room_id":@(room)};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_CLOSELIVE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (0 == [[responseObject objectForKey:@"code"] integerValue]){
            if (succ){
                succ(@"关闭直播间成功", nil);
            }
        }else{
            if (fail){
                fail(@"关闭房间失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail){
            fail(@"关闭房间失败");
        }
    }];
}
- (void)leaveRoom:(NSInteger)room phone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail{
    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\",\"roomnum\":%ld}",phone,(long)room];
    NSDictionary *parameter = @{@"viewerout":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_DEL_ROOM parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"",nil);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"离开房间失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"离开房间失败");
        }
    }];
}

- (void)logReport:(NSString*)phone log:(NSString*)log
{
    if([phone isEqualToString:@""] || [log isEqualToString:@""])
    {
        return;
    }
    
    NSDictionary *parameter = @{@"userphone":phone,@"logmsg":log};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_LOGREPORT parameters:parameter success:nil failure:nil];
}

- (void)getUserList:(NSString*)phones succ:(businessSucc)succ fail:(businessFail)fail
{
    if([phones isEqualToString:@""])
    {
        return;
    }
    
    NSString* json = [NSString stringWithFormat:@"{\"userphones\":\"%@\"}",phones];
    NSDictionary *parameter = @{@"data":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_USERLIST parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"获取在线用户成功",[responseObject objectForKey:@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取在线用户失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取在线用户失败");
        }
    }];
}


//直播间用户列表
- (void)getUserListByRoom:(NSString *)group_id uid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
//    NSString* json = [NSString stringWithFormat:@"{\"groupid\":\"%ld\"}",(long)room];
//    NSDictionary *parameter = @{@"data":json};
//    if (!page) {
//        page = @"1";
//    }
    NSDictionary *parameter = @{@"group_id":group_id,@"uid":[SARUserInfo userId],@"pa":@"1", @"rebot_fl":@"1"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_USERLIST parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (URL_NORMAL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            succ([responseObject objectForKey:@"message"],responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

- (void)getLive:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail{
    NSString* json = [NSString stringWithFormat:@"{\"roomnum\":\"%ld\"}",(long)room];
    NSDictionary *parameter = @{@"liveinfo":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_LIVEINFO parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue]) {
            if (succ)
            {
                succ(@"",[responseObject objectForKey:@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播信息失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播信息失败");
        }
    }];
}

- (void)saveUserInfo:(NSString*)phone key:(NSString*)key value:(NSString*)value succ:(businessSucc)succ fail:(businessFail)fail{
    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\",\"%@\":\"%@\"}", phone, key, value];
    NSDictionary *parameter = @{@"data":json, @"version":@"34"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_SAVEUSER parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (URL_REQUEST_SUCCESS == code || URL_SAVEUSER_NOIMAGE == code)
        {
            if (succ)
            {
                succ(@"",[responseObject objectForKey:@"data"]);
            }
        }
        else if(URL_SAVE_NAMEUSED == code){
            if (fail)
            {
                fail(@"用户名已经使用");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"保存失败");
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        if (fail)
        {
            fail(@"保存失败");
        }
    }];
}
- (void)saveUserInfo:(NSString*)phone image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail{
    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\"}", phone];
    NSDictionary *parameter = @{@"data":json, @"version":@"34"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URL_SAVEUSER parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image != nil)
        {
            [formData appendPartWithFileData:
             UIImageJPEGRepresentation(image, 0.5) name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (URL_REQUEST_SUCCESS == code || URL_SAVEUSER_NOIMAGE == code)
        {
            if (succ)
            {
                succ(@"保存成功",[responseObject objectForKey:@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"保存失败");
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        if (fail)
        {
            fail(@"保存失败");
        }
    }];
}
- (void)saveUserInfo:(NSString*)phone name:(NSString*)name gender:(NSString*)gender address:(NSString*)address signature:(NSString*)sig image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail{
    int genderInt = ([gender isEqualToString:@"男"]?0:1);
    NSString* json = [NSString stringWithFormat:@"{\"userphone\":\"%@\",\"username\":\"%@\",\"sex\":%d,\"address\":\"%@\",\"signature\":\"%@\"}", phone, name, genderInt, address, sig];
    NSDictionary *parameter = @{@"data":json,@"version":@"34"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_SAVEUSER parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传图片，以文件流的格式
        if(image != nil)
        {
            [formData appendPartWithFileData:
             UIImageJPEGRepresentation(image, 0.5) name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (URL_REQUEST_SUCCESS == code || URL_SAVEUSER_NOIMAGE == code)
        {
            if (succ)
            {
                succ(@"保存成功",[responseObject objectForKey:@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"保存失败");
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        if (fail)
        {
            fail(@"保存失败");
        }
    }];
}

- (void)insertTrailer:(NSString*)tilte phone:(NSString*)phone time:(NSString*)time image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail{
    NSString* json = [NSString stringWithFormat:@"{\"livetitle\":\"%@\",\"userphone\":\"%@\",\"starttime\":\"%@\"}",
                      tilte,phone,time];
    NSDictionary *parameter = @{@"forcastdata":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_CREATETRAILER parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:
         UIImageJPEGRepresentation(image, 0.5) name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"发布成功",nil);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(@"发布失败");
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"发布失败");
        }
    }];
}

- (void)getTrailers:(NSString*)lastTime succ:(businessSucc)succ fail:(businessFail)fail{
    [self getLives:lastTime uid:[SARUserInfo userId]  isConcernLives:NO type:@"1" succ:succ fail:fail];
    return;
    
    NSString* json = [NSString stringWithFormat:@"{\"timelimit\":\"%@\"}",
                      lastTime];
    NSDictionary *parameter = nil;
    if(lastTime != nil && ![lastTime isEqualToString:@""])
    {
        parameter = @{@"forcastlist":json};
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URL_TRAILERLIST parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (succ)
            {
                succ(@"获取预告成功",data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取预告失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取预告失败");
        }
    }];
}

#pragma mark -- 获取直播列表 (萌萌哒的薛荣荣修改参数)
// isConcern 是否是关注列表 type 1代表最新否则不传 帅帅的William修改参数
- (void)getLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString* json = [NSString stringWithFormat:@"{\"timelimit\":\"%@\"}", lastTime];
//    
//    NSDictionary *parameter = nil;
//    if(lastTime != nil && ![lastTime isEqualToString:@""])
//    {
//        parameter = @{@"livelist":json};
//    }
    
    // 是关注列表
    NSMutableDictionary *param = nil;
//    if (isConcern) {
//        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_FOR_USER_INFO];
//    NSDictionary * useeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        param = [@{@"uid":[[SARUserInfo gainUserInfo] objectForKey:@"uid"]} mutableCopy];
    
//    }
//    if (type) {
//        [param setObject:type forKey:@"type"];
//    }
//    [param setObject:@"3" forKey:@"pageSize"];
    if (lastTime) {
        [param setObject:lastTime forKey:@"page"];
    }
    [manager POST:URL_LIVELIST parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (0 == code)
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                fail(@"暂无内容");
                return ;
            }
            if (data.count > 0 && [[data firstObject] isKindOfClass:[NSString class]]) {
               
                fail(@"暂无内容");
                return ;
            }
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"暂无数据");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播失败");
        }
    }];
}

//最新直播列表
- (void)getNewLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param = nil;

    param = [@{@"uid":[[SARUserInfo gainUserInfo] objectForKey:@"uid"]} mutableCopy];
    
    if (lastTime) {
        [param setObject:lastTime forKey:@"page"];
    }
    [manager POST:URL_NEWLIVELIST parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (0 == code)
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                fail(@"暂无内容");
                return ;
            }
            if (data.count > 0 && [[data firstObject] isKindOfClass:[NSString class]]) {
                
                fail(@"暂无内容");
                return ;
            }
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"暂无数据");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播失败");
        }
    }];
}

//主推直播列表
- (void)getMainTopLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param = nil;
    
    param = [@{@"uid":[[SARUserInfo gainUserInfo] objectForKey:@"uid"]} mutableCopy];
    [manager POST:URL_MAINTOPLIVELIST parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (0 == code)
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                fail(@"暂无内容");
                return ;
            }
            if (data.count > 0 && [[data firstObject] isKindOfClass:[NSString class]]) {
                
                fail(@"暂无内容");
                return ;
            }
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"暂无数据");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播失败");
        }
    }];
}

//关注直播列表
- (void)getFollowLives:(NSString*)lastTime uid:(NSString *)uid isConcernLives:(BOOL)isConcern type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param = nil;
    
    param = [@{@"uid":[[SARUserInfo gainUserInfo] objectForKey:@"uid"]} mutableCopy];
    if (lastTime) {
        [param setObject:lastTime forKey:@"page"];
    }
    [manager POST:URL_FOLLOWLIVELIST parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (0 == code)
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                fail(@"暂无内容");
                return ;
            }
            if (data.count > 0 && [[data firstObject] isKindOfClass:[NSString class]]) {
                
                fail(@"暂无内容");
                return ;
            }
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"暂无数据");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播失败");
        }
    }];
}

//附近的直播
-(void)getNearLives:(NSString *)uid latitude:(NSString *)latitude longitude:(NSString *)longitude succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:latitude forKey:@"latitude"];
    [paramsDict safeObj:longitude forKey:@"longitude"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:LIVE_NEARBY parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (0 == code)
        {
            NSArray* data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                fail(@"暂无内容");
                return ;
            }
            if (data.count > 0 && [[data firstObject] isKindOfClass:[NSString class]]) {
               
                fail(@"暂无内容");
                return ;
            }
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else if (URL_REQUEST_NO_DATA == code)
        {
            if (fail)
            {
                fail(@"暂无内容");
            }
        }
        else
        {
            if (fail)
            {
                fail(@"暂无数据");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"获取直播失败");
        }
    }];

}

- (void)heartBeatCheckCrash:(NSString*)phone
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* json = [NSString stringWithFormat:@"{\"livephone\":\"%@\"}",phone];
    NSDictionary *parameter = nil;
    if(phone != nil && ![phone isEqualToString:@""])
    {
        parameter = @{@"heartTime":json};
    }
    
    [manager POST:URL_HEARTTIME parameters:parameter success:nil failure:nil];
}

    
//举报主播
- (void)liveReport:(NSString *)user_id accuse_id:(NSString *)accuse_id cause:(NSString *)cause complement:(NSString *)complement succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:user_id forKey:@"user_id"];
    [paramsDict safeObj:accuse_id forKey:@"accuse_id"];
    [paramsDict safeObj:cause forKey:@"cause"];
    [paramsDict safeObj:complement forKey:@"complement"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_LIVEREPORT parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URL_NORMAL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(responseObject[@"message"],nil);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(responseObject[@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"举报失败");
        }
    }];
}

- (void)forcastReport:(NSString *)fileID reporter:(NSString *)reportID content:(NSString *)reportContent succ:(businessSucc)succ fail:(businessFail)fail
{
    NSString* json = [NSString stringWithFormat:@"{\"file_id\":\"%@\",\"user_id\":\"%@\",\"content\":\"%@\"}",
                      fileID, reportID, reportContent];
    NSDictionary *parameter = @{@"forcast_data":json};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_FORCASTREPORT parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URL_REQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"举报成功",nil);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(@"举报失败");
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"举报失败");
        }
    }];
}

#pragma mark -- 搜索直播列表
-(void)searchLive:(NSString *)search succ:(businessSucc)succ fail:(businessFail)fail{
    
    NSDictionary *parameter = @{@"search":search,@"uid":[SARUserInfo userId]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:SEARCH_LIVE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                NSArray *listAry = [responseObject objectForKey:@"data"];
                succ(@"获取成功",listAry);
            }
        }
        else
        {
            if (fail)
            {
                
                fail([responseObject objectForKey:@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"获取失败");
        }
    }];

}

#pragma mark -- 关注直播/取消关注
-(void)concern:(NSString *)fuid uid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    NSDictionary *parameter = @{@"fuid":fuid,@"uid":uid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:CONCERN_USER_LIVE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ([responseObject objectForKey:@"message"],nil);
            }
        }
        else
        {
            if (fail)
            {
                
                fail([responseObject objectForKey:@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"请求失败");
        }
    }];

    
    
}

#pragma mark - 解散房间
- (void)deleRoom:(NSString *)programid succ:(businessSucc)succ fail:(businessFail)fail{
    {
        // URL_DEL_ROOM
        NSDictionary *parameter = @{@"av_room_id":programid};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:URL_DEL_ROOM parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
            {
                if (succ)
                {
                    succ([responseObject objectForKey:@"message"],nil);
                }
            }
            else
            {
                if (fail)
                {
                    
                    fail([responseObject objectForKey:@"message"]);
                }
            }
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            if (fail)
            {
                
                fail(@"请求失败");
            }
        }];
    }
}


#pragma mark -- 重置密码
-(void)pwdReset:(NSString *)pwd phoneNum:(NSString *)phone succ:(businessSucc)succ fail:(businessFail)fail code:(NSString *)code{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:pwd forKey:@"password"];
    [paramsDict safeObj:phone forKey:@"phone"];
    [paramsDict safeObj:code forKey:@"code"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:RESET_PASSWORD parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ([responseObject objectForKey:@"message"],nil);
            }
        }
        else
        {
            if (fail)
            {
                
                fail([responseObject objectForKey:@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail)
        {
            
            fail(@"请求失败");
        }
    }];
    
}
#pragma mark -- 获取消息列表
-(void)getMessageList:(NSString *)page succ:(businessSucc)succ fail:(businessFail)fail{

    NSString *uid = [SARUserInfo userId];
    
    NSDictionary *parameter = @{@"user_id":uid,@"page":page};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GET_MESSAGE_LIST parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            
            if (succ) {
                
                succ([responseObject objectForKey:@"message"],[responseObject objectForKey:@"data"]);
            }
        }else{
            if (fail) {
                fail([responseObject objectForKey:@"message"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


-(void)messageUnreadNumber:(businessSucc)succ fail:(businessFail)fail{
    
    
    NSString *uid = [SARUserInfo userId];
    
    NSDictionary *parameter = @{@"user_id":uid,@"page":@"1"};

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GET_MESSAGE_LIST parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            int num = 0;
            if (succ) {
                NSArray *msgData = [responseObject objectForKey:@"data"];
                for (NSDictionary *dic in msgData) {
                    if ([dic objectForKey:@"read_num"]) {
                        int number = [[dic objectForKey:@"read_num"] intValue];
                        num += number;
                    }
                }
                succ(nil,[NSString stringWithFormat:@"%d",num]);
            }
        }else{
            if (fail) {
                fail([responseObject objectForKey:@"message"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];

}

-(void)withdrawal:(NSString *)ID integral:(NSString *)integral succ:(businessSucc)succ fail:(businessFail)fail{

  NSDictionary *parameter = @{@"id":ID,@"integral":integral};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:WITHDRAWAL parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
       succ([responseObject objectForKey:@"message"],[responseObject objectForKey:@"code"]);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];


}

//赠送礼物
-(void)giftGiving:(NSString *)giveUserID amount:(NSString *)amount succ:(businessSucc)succ fail:(businessFail)fail{
    
    NSDictionary *parameter = @{@"uid":[SARUserInfo userId],@"give_user_id":giveUserID,@"amount":@"1",@"val":@([amount integerValue])};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GIFTGIVING parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        succ([responseObject objectForKey:@"message"],[responseObject objectForKey:@"code"]);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
  

}

- (NSMutableDictionary*)sysParamsValuesDict{

    return [NSMutableDictionary dictionary];
}



//首页轮播图
-(void)homeCarouselSucc:(businessSucc)succ fail:(businessFail)fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:HOME_SHUFFLING_Figure parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ([responseObject objectForKey:@"message"],responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//首页商品类型
-(void)homeGoodsTypeSucc:(businessSucc)succ fail:(businessFail)fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:HOME_GOODS_TYPE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ([responseObject objectForKey:@"message"],responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//首页热门搜索
-(void)homeHotSearchSucc:(businessSucc)succ fail:(businessFail)fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:HOME_HOT_SEARCH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ([responseObject objectForKey:@"message"],responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//首页搜索
-(void)homeSearchSucc:(businessSucc)succ fail:(businessFail)fail name:(NSString *)name goodsID:(NSString *)goodsID order:(NSString *)order page:(NSString *)page{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:goodsID forKey:@"id"];
    [paramsDict safeObj:name forKey:@"name"];
    [paramsDict safeObj:order forKey:@"order"];
    [paramsDict safeObj:page forKey:@"page"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:HOME_SEARCH parameters:paramsDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//好友店铺正在直播
-(void)friendLivingList:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:type forKey:@"type"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_LIVINGLIST parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//好友列表
-(void)friendList:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_LIST parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}
// 最新物品
- (void)newGoods:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:NEW_GOODS_STYLISH parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
    
}

// 爆款
- (void)groom:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GOODS_STYLISH parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];

    
    
    
    
}

//搜索添加好友
-(void)searchAddFriend:(NSString *)uid name:(NSString *)name succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:name forKey:@"name"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_SEARCH parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


//搜索店铺中的好友
-(void)searchFriendFromMyList:(NSString *)uid name:(NSString *)name succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:name forKey:@"name"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_SEARCH_MYCONLIST parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];

}

//添加好友
-(void)addFriend:(NSString *)uid friend_phone:(NSString *)friend_phone succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:friend_phone forKey:@"friend_phone"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_ADD parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];

}

//删除好友
-(void)delegateFriend:(NSString *)uid friend_phone:(NSString *)friend_phone succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:friend_phone forKey:@"friend_phone"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:FRIEND_DELEGATE parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];

}


//商品管理
-(void)goodsManageUid:(NSString *)uid type:(NSString *)type succ:(businessSucc)succ page:(NSString *)page fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:type forKey:@"type"];
    [paramsDict safeObj:page forKey:@"page"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GOODS_MANAGE_URL parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"加载成功",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            
            fail(@"请求失败");
        }
    }];
}

//将商品添加到购物车
-(void)goodsAddCartUid:(NSString *)user_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:user_id forKey:@"user_id"];
    [paramsDict safeObj:goods_id forKey:@"goods_id"];
    [paramsDict safeObj:goods_num forKey:@"goods_num"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Goods_ADD_CART parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ([responseObject objectForKey:@"message"],responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            
            fail(@"请求失败");
        }
    }];
}

//添加商品到店铺
-(void)releaseGoodsUid:(NSString *)uid cat_id:(NSString *)cat_id goods_name:(NSString *)goods_name shop_price:(NSString *)shop_price store_count:(NSString *)store_count goods_remark:(NSArray *)goods_remark goods_standard:(NSArray *)goods_standard original_img:(NSArray *)original_img goods_content:(NSArray *)goods_content succ:(businessSucc)succ fail:(businessFail)fail{
    
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict setValue:uid forKey:@"uid"];
    [paramsDict setValue:cat_id forKey:@"cat_id"];
    [paramsDict setValue:goods_name forKey:@"goods_name"];
    [paramsDict setValue:shop_price forKey:@"shop_price"];
    [paramsDict setValue:store_count forKey:@"store_count"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:goods_standard options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
//    NSString *goodArr = [goods_standard JSONString];
    
    [paramsDict setValue:jsonString forKey:@"goods_standard"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:STORE_ADD_GOODS parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(original_img.count > 0){
            for(int i=0; i<original_img.count; i++) {
                UIImage *eachImg = [original_img objectAtIndex:i];
                NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
                [formData appendPartWithFileData:eachImgData name:@"original_img" fileName:[NSString stringWithFormat:@"imageg%d.jpg", i+1] mimeType:@"image/jpg"];
            }
        }
        if(goods_remark.count > 0){
            for(int i=0; i<goods_remark.count; i++) {
                UIImage *eachImg = goods_remark[i];
                NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
                NSString *fileName = [NSString stringWithFormat:@"goods_remark%d.jpg", i];
                [formData appendPartWithFileData:eachImgData name:fileName fileName:fileName mimeType:@"image/jpg"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (0 == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"发布商品成功", responseObject[@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(responseObject[@"message"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail)
        {
            fail(@"发布商品失败");
        }
    }];
}


//商品详情
-(void)goodsDetailUid:(NSString *)uid goods_id:(NSString *)goods_id succ:(businessSucc)succ fail:(businessFail)fail{
    
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:goods_id forKey:@"goods_id"];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:GOODS_DEAIL parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            succ(@"",responseObject[@"data"]);
            
        }else{
            fail(responseObject[@"mesage"]);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


//商品收藏与取消收藏
-(void)goodsCollectState:(NSString *)uid goods_id:(NSString *)goods_id succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:goods_id forKey:@"goods_id"];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:GOODS_FAVORITE_UNFAVORITE parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] != 0 & [responseObject[@"code"]integerValue] != 1) {
            fail(responseObject[@"message"]);
        }else{
            succ(responseObject[@"message"],responseObject[@"code"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


//店铺中的商品列表
-(void)storeGoodsList:(NSString *)uid user_id:(NSString *)user_id succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    [paramsDict safeObj:user_id forKey:@"user_id"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:STORE_GOODS_LIST parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


//我的店铺
-(void)getStoreInfoUid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:STORE_MY_INFO parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


//我的店铺交易管理
-(void)getStoreBusMangUid:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail{
    NSMutableDictionary *paramsDict = [self sysParamsValuesDict];
    [paramsDict safeObj:uid forKey:@"uid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:STORE_BUSINESS_MANAGE parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}


- (void)getMyIconWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:MY_ICON parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

- (void)getMyDiamondsWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:MY_DIAMONDS_COINS parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

- (void)getPayListWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:PY_LIST parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}
- (void)limoPayWithWexinWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Limo_Pay parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPhone"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}
-(void)loginWithSthirdParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Third_Log parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else if ([responseObject[@"code"] integerValue] == -4) {
            fail(responseObject[@"message"]);
        }
        else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}
-(void)IsFirstWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Is_first parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succ(@"",responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//获取主播魅力值
- (void)postStarsCoinsWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Star_coins parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"mesage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//获取主播魅力值排行
- (void)postCharmsRankWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:GIFT_RANKING parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//获取主播封禁状态
- (void)postHostLiveStatesWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:LIVE_DISABLE parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

//获取系统消息提示
- (void)getLiveNoticeWithParam:(NSDictionary *)param succ:(businessSucc)succ fail:(businessFail)fail {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:LIVE_NOTICE parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

- (NSString *)is_NullStringChange:(NSString *)string {
    if ([string isEqual:[NSNull null]] || string==nil) {
        
        string =@"";
        
    }
    return string;
}


/**
 查看积分

 @param uid <#uid description#>
 @param succ <#succ description#>
 @param fail <#fail description#>
 */
- (void) getMyIntegral:(NSString *)uid succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:uid forKey:@"uid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:INTEGRAL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];
}


//===========================牛牛游戏


- (void) requestUserDiceData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_Dice_List parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];
}

- (void) requestUserIntegral:(NSString *)user_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:user_id forKey:@"user_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_Dice_User_Integral parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];
}

- (void) requestNextDataDeletace:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_Dice_Shang parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];

}

- (void) requestGamesData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_State_List parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];
}


- (void) requestListData:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_Dice_List_Data parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
  
        
    }];
}

- (void) addGamesState:(NSString *)room_id bet_count_down:(NSString *)bet_count_down rest_count_down:(NSString *)rest_count_down game_state:(NSString *)game_state succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    [dic setValue:bet_count_down forKey:@"bet_count_down"];
    [dic setValue:rest_count_down forKey:@"rest_count_down"];
    [dic setValue:game_state forKey:@"game_state"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_State_Add parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];

}

- (void) requestNumberManay:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:Niuniu_User_Integral_Heartbeat parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
        
    }];
}


- (void) requesetDiceRoom:(NSString *)room_id bet_money:(NSString *)bet_money user_id:(NSString *)user_id table_number:(NSString *)table_number succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    [dic setValue:bet_money forKey:@"bet_money"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:table_number forKey:@"table_number"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:NIUNIU_DICE_USER_INTEGRAL_REDUCE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
        
    }];
}









- (void) userIntegralConis:(NSString *)uid integral:(NSString *)integral succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:integral forKey:@"integral"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:USER_INTEGRAL_COINS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
    }];
    
    
}

- (void) userConisIntegral:(NSString *)uid diamonds_coins:(NSString *)diamonds_coins succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:diamonds_coins forKey:@"diamonds_coins"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:USER_COINS_INTEGRAL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            succ(@"",responseObject);
        }else{
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            fail(@"请求失败");
        }
    }];
}

- (void) sendBetInfoToServer:(NSString *)user_id bet_money:(NSString *)bet_money room_id:(NSString *)room_id table_number:(NSString *)table_number succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:bet_money forKey:@"bet_money"];
    [dic setValue:room_id forKey:@"room_id"];
    [dic setValue:table_number forKey:@"table_number"];
    [dic setValue:user_id forKey:@"user_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:DICE_USER_INTEGRAL_REDUCE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            succ(@"",responseObject[@"data"]);
        }
        else
        {
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            
            fail(@"请求出错");
        }
    }];
}

- (void) getUserManayToBetroom_id:(NSString *)room_id succ:(businessSucc)succ fail:(businessFail)fail
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:room_id forKey:@"room_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:USER_INTEGRAL_HEARTBEAT parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            succ(@"",responseObject[@"data"]);
        }
        else
        {
            fail(responseObject[@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            
            fail(@"请求出错");
        }
    }];
    
}



@end
