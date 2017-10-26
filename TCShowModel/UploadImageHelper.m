//
//  UploadImageHelper.m
//  PLUShow
//
//  Created by AlexiChen on 15/11/28.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "UploadImageHelper.h"

#import "TXYBase.h"
#import "TXYUploadManager.h"

@interface UploadImageHelper ()
{
    TXYUploadManager   *_uploadManager;
    TXYPhotoUploadTask *_uploadPhotoTask;
}

@end

@implementation UploadImageHelper

static UploadImageHelper *_shareInstance = nil;

+ (instancetype)shareInstance;
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _shareInstance = [[UploadImageHelper alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _uploadManager = [[TXYUploadManager alloc] initWithCloudType:TXYCloudTypeForFile persistenceId:nil appId:@"10022853"];
    }
    return self;
}

- (void)upload:(UIImage *)image completion:(void (^)(NSString *imageSaveUrl))completion failed:(void (^)(NSString *failTip))failure
{
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    NSString *sign = host.imgSign.imageSign;
    
    if (!sign.length)
    {
        if (failure)
        {
            failure(@"上传图片SIG为空，无法上传");
        }
        
        return;
    }
    
    if (!image)
    {
        if (failure)
        {
            failure(@"图片为空，不能上传");
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        
        // 以时间戳为文件名
        NSString *photoName = [[NSString alloc] initWithFormat:@"%3.f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *pathSave = [PathUtility getFileCachePath:photoName];
        
       BOOL succ = [imageData writeToFile:pathSave atomically:YES];
        if (succ)
        {
            // 存文件成功
            //1.构造TXYPhotoUploadTask上传任务,
            NSString *dire = [NSString stringWithFormat:@"/%@_%@", [host imUserId], photoName];
            TXYFileUploadTask *task = [[TXYFileUploadTask alloc] initWithPath:pathSave sign:sign bucket:@"sxbbucket" customAttribute:@".png" uploadDirectory:dire msgContext:nil];
//            TXYPhotoUploadTask *task = [[TXYPhotoUploadTask alloc] initWithPath:pathSave sign:sign bucket:@"sxbbucket" expiredDate:0 msgContext:@"上传成功后，传给用户业务后台的信息" fileId:nil];
            
            [_uploadManager upload:task complete:^(TXYTaskRsp *resp, NSDictionary *context) {
//                complete(resp, context);
                TXYFileUploadTaskRsp *taskResp = (TXYFileUploadTaskRsp *)resp;
                
                if (taskResp >= 0 && taskResp.fileURL.length)
                {
                    if (completion)
                    {
                        completion(taskResp.fileURL);
                    }
                }
                else
                {
                    if (failure)
                    {
                        failure(@"上传图片失败");
                    }
                }

            } progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {
            } stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
            }];
        }
        else
        {
            if (failure)
            {
                failure(@"图片为空，不能上传");
            }

        }
    });
    
}

@end
