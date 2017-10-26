





//
//  AppDelegate.m
//  TCShow
//
//  Created by AlexiChen on 16/4/11.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LMShopTabBarController.h"

#define PGY_APP_ID @"c629d79576bb2cf0a06358cc3810bd40"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)configAppLaunch
{
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //关闭摇一摇激活反馈意见
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    //启动基本SDK
    [WXApi registerApp:MXWechatAPPID withDescription:@"微信支付"];

    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"c629d79576bb2cf0a06358cc3810bd40"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
    
    
//    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    /* 设置友盟appkey */
    
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPID];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:MXWechatAPPID appSecret:MXWechatAPPSecret redirectURL:MXWechatBaseUrl];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

    [IMAPlatform configHostClass:[TCShowHost class]];
    [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
#if kSupportNetReachablity
    [[NetworkUtility sharedNetworkUtility] startCheckWifi];
    
#endif
    
//    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"STAR_LIVE_AVROOMID"];

    
}


#if kIsIMAAppFromBase
#else
// 一般用户自己App都会重写该方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self configAppLaunch];
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
//
//// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
#endif

- (void)enterMainUI
{
    NSNumber *has = [[NSUserDefaults standardUserDefaults] objectForKey:@"HasReadUserProtocol"];
    if (!has || !has.boolValue)
    {
        UserProtocolViewController *vc = [[UserProtocolViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.barTintColor = [UIColor whiteColor];
        self.window.rootViewController = nav;
        return;
    }
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"STAR_LIVE_AVROOMID"];

    
    [[Business sharedInstance]closeRoom:[str integerValue] succ:^(NSString *msg, id data) {
        
        
        
    } fail:^(NSString *error) {
        
        
        
    }];
    
    
    self.window.rootViewController = [[TarBarController alloc] init];
        
    
//    self.window.rootViewController = [[TarBarController alloc] init];
//    self.window.rootViewController = [[LMShopTabBarController alloc]init];
    
}


- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    
    TarBarController *tab = (TarBarController *)self.window.rootViewController;
    [tab pushToChatViewControllerWith:user];
}


@end









