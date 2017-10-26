//
//  DragView.m
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "DragView.h"
#import "Business.h"
#import "AFNetworking.h"
//#import "UserInfo.h"
#import "MBProgressHUD.h"
@implementation DragView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubView];
    }
    
    return self;
}

-(void)updateView:(NSNumber *)isAttend{

    _imageView = (UIImageView*)[self viewWithTag:7777];
    _bottomLabel = (UILabel*)[self viewWithTag:9999];
    if ([isAttend integerValue] == 1) {
        _imageView.hidden = YES;
        _bottomLabel.text = @"已关注";
        _bottomLabel.frame = CGRectMake((SCREEN_WIDTH/3.0-60)/2.0, 10, 60, 30);
        _bottomLabel.textColor = [UIColor darkGrayColor];
        self.isAttend  = [NSNumber numberWithInt:1];
    }else if ([isAttend integerValue] == 0){
        _imageView.hidden = NO;
        _bottomLabel.text = @"关注";
        _bottomLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)+5, 10, 40, 30);
        _bottomLabel.textColor = [UIColor whiteColor];
        self.isAttend  = [NSNumber numberWithInt:0];
    }

}

-(void)addSubView{
    NSArray * imageArr = @[@"个人主页-导航栏-需关注",@"私信",@"个人主页-导航栏-拉黑"];
    NSArray * labelArray = @[@"关注",@"私信",@"拉黑"];
    for (int i = 0; i<3; i++) {
        
        UIView * view = [[UIView alloc]init];
        view.userInteractionEnabled = YES;
        view.frame = CGRectMake(0+SCREEN_WIDTH/3.0*i, 0, SCREEN_WIDTH/3.0, 49);
        view.backgroundColor = YCColor(251, 86, 88, 1.0);
        view.tag = 8888+i;
        [self addSubview:view];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delegateOrAdd:)];
        [view addGestureRecognizer:tap];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/3.0 - 60)/2.0, 12, 25, 25)];
        _imageView.tag = 7777+i;
        _imageView.image =[UIImage imageNamed:imageArr[i]];
        [view addSubview:_imageView];
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+5, 10, 40, 30)];
        _bottomLabel.tag = 9999+i;
        _bottomLabel.text = labelArray[i];
        _bottomLabel.textColor = [UIColor whiteColor];
        [view addSubview:_bottomLabel];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*i-1, 10, 1, 29)];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
    }
}

-(void)delegateOrAdd:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag == 8888) {
        
        __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        if (self.attendId.integerValue == [[IMAPlatform sharedInstance].host.profile.identifier integerValue]) {
            hud.labelText = @"你时刻都在关注着自己~";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//            [wh hideText:@"你时刻都在关注着自己~" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
            return;
        }
        
        [[Business sharedInstance] concern:self.attendId uid:[SARUserInfo userId]  succ:^(NSString *msg, id data) {
            if ([data[@"code"] integerValue] == 0) {
                _imageView = (UIImageView*)[self viewWithTag:7777];
                _bottomLabel = (UILabel*)[self viewWithTag:9999];
                if ([self.isAttend integerValue] == 0) {
                    _imageView.hidden = YES;
                    _bottomLabel.text = @"已关注";
                    _bottomLabel.frame = CGRectMake((SCREEN_WIDTH/3.0-60)/2.0, 10, 60, 30);
                    _bottomLabel.textColor = [UIColor darkGrayColor];
                    self.isAttend  = [NSNumber numberWithInt:1];
                    hud.labelText = @"已关注";
                }else if ([self.isAttend integerValue] == 1){
                    _imageView.hidden = NO;
                    _bottomLabel.text = @"关注";
                    _bottomLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)+5, 10, 40, 30);
                    _bottomLabel.textColor = [UIColor whiteColor];
                    self.isAttend  = [NSNumber numberWithInt:0];
                    hud.labelText = @"取消关注";
                }
//                hud.mode = MBProgressHUDModeCustomView;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
//                });

            }else if([data[@"code"] integerValue] == -1){
                
                hud.labelText = data[@"message"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
//                [hud hideText:data[@"message"] atMode:MBProgressHUDModeText andDelay:1 andCompletion:^{
//                }];
            }
        } fail:^(NSString *error) {
            hud.labelText = error;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
//         [hud hideText:error atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
        }];
        
    }else if(tap.view.tag == 8889){
       

        if (self.attendId.integerValue == [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]integerValue]) {
            MBProgressHUD *wh = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            wh.labelText = @"不能跟自己聊天哦~";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wh.hidden = YES;
            });

            return;
        }
        [self.chooseDelegatel getChooseIndex];
    }
    else if(tap.view.tag == 8890){
       
        
        if (self.attendId.integerValue == [[IMAPlatform sharedInstance].host.profile.identifier integerValue]) {
            MBProgressHUD *wh = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            wh.labelText = @"不能将自己拉黑哦~";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wh.hidden = YES;
            });
//            [wh hideText:@"不能将自己拉黑哦~" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"拉黑后将收不到对方信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //拉黑按钮点击确认
            [self confirm];
        }];
        [defaultAction setValue:YCColor(76, 199, 207, 1.0) forKey:@"titleTextColor"];
        [alertController addAction:defaultAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:YCColor(76, 199, 207, 1.0) forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
        [self.levelController presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma maerk --提示框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
//        [self mask];
    }
}

-(void)confirm{
    
    // 加入黑名单接口
    [self mask];
}


#pragma mark -- 拉黑
-(void)mask{

    NSDictionary *dic = @{@"from_user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"],@"black_user_id":self.attendId};
   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.superview];
    [self.superview addSubview:hud];
    [hud show:YES];
    
    [manager POST:ADD_MASK parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [[TIMFriendshipManager sharedInstance] AddBlackList:@[self.phone] succ:^(NSArray *friends) {
                // 从好友分组中移除
                hud.labelText = @"加入黑名单成功";
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
                
                
            } fail:^(int code, NSString *err) {
               
                hud.labelText = @"加入黑名单失败";
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
            }];
        }else{
            
            hud.labelText = [responseObject objectForKey:@"message"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            
        }
  
//        [hud hideText:[responseObject objectForKey:@"message"] atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
 
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        hud.labelText = @"添加失败，请检查网络连接，稍后重试~";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [hud hideText:@"添加失败，请检查网络连接，稍后重试~" atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
    }];
}


@end
