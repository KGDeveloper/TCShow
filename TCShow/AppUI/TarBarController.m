//
//  TarBarController.m
//  JShow
//
//  Created by AlexiChen on 16/2/19.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TarBarController.h"
#import "LiveHomeController.h"
#import "XConcerViewController.h"
#import "ConversationListViewController.h"
#import "SDContactsViewController.h"
#import "XXTaoTableViewController.h"
#import "XDMineController.h"
#import "LMHomeViewController.h"
#import "LMMineViewController.h"
#import "WMPageController.h"
#import "LMFriendsViewController.h"
#import "LMShopTabBarController.h"
#import "IMAAppDelegate.h"
#import "LMShopTabBarController.h"
#import "QZKRequestData.h"
#import <PgyUpdate/PgyUpdateManager.h>


@interface TarBarController ()<UITabBarControllerDelegate>
{
//    UIButton *_liveButton;
    
//    XConcerViewController *_concernController;
    
    ConversationListViewController *_ConversationListViewController;
    NavigationViewController * _msgNav;
    UITabBarItem *_doLiveItem;
    
}

@end

@implementation TarBarController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabBar];

}

#pragma mark 初始化Tab
- (void)initTabBar
{
    LMHomeViewController *dicoverVC = [[LMHomeViewController alloc]init];
    dicoverVC.title = @"首页";
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:dicoverVC];

    NSArray *viewControllers = @[[ConversationListViewController class],[SDContactsViewController class]];
    NSArray *titles = @[@"消息", @"联系人"];
    
    LMFriendsViewController *pageController = [[LMFriendsViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageController.menuHeight = 34;
    pageController.menuViewStyle = WMMenuViewStyleFloodHollow;
    pageController.preloadPolicy = WMPageControllerPreloadPolicyNever;
    pageController.cachePolicy = WMPageControllerCachePolicyLowMemory;
    pageController.titleSizeSelected = 16;
    pageController.titleSizeNormal = 16;
    pageController.itemMargin = 10;
    pageController.showOnNavigationBar = YES;
    pageController.menuBGColor = [UIColor clearColor];
    pageController.titleColorNormal = [UIColor lightGrayColor];
    pageController.titleColorSelected = LEMON_MAINCOLOR;
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    
    SDContactsViewController *contactVC = [[SDContactsViewController alloc] init];
    contactVC.title = @"好友";
    UINavigationController* focusNav = [[UINavigationController alloc] initWithRootViewController:pageController];
    
    //发布直播
    TCPushlishViewController *second = [[TCPushlishViewController alloc] init];
    NavigationViewController *publishNav = [[NavigationViewController alloc]initWithRootViewController:second];
    
    // 淘物
    XXTaoTableViewController *taoVC = [[XXTaoTableViewController alloc]init];
    
     _msgNav = [[NavigationViewController alloc] initWithRootViewController:taoVC];
   
    LMMineViewController *mevc = [[LMMineViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:mevc];
    
    self.viewControllers = [NSArray arrayWithObjects:discoverNav,focusNav,publishNav,_msgNav,meNav,nil];
    self.delegate = self;

    //获取tabBarItem
    UITabBarItem *watchLiveItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *focItem = [self.tabBar.items objectAtIndex:1];
    _doLiveItem = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *msgItem = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *myCenterItem = [self.tabBar.items objectAtIndex:4];
    
    [self setTabBarItem:watchLiveItem withNormalImageName:@"shouye_none" andSelectedImageName:@"shouye_sel" andTitle:@"首页"];
    [self setTabBarItem:focItem withNormalImageName:@"haoyou_none" andSelectedImageName:@"haoyou_sel" andTitle:@"好友"];
    [self setTabBarItem:_doLiveItem withNormalImageName:@"live_none" andSelectedImageName:@"live_none"  andTitle:@"直播"];
    [self setTabBarItem:msgItem withNormalImageName:@"taowu_none" andSelectedImageName:@"taowu_sel" andTitle:@"淘物"];
    [self setTabBarItem:myCenterItem withNormalImageName:@"mine_none" andSelectedImageName:@"mine_sel" andTitle:@"我的"];
    
    //设置未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YCColor(155,155,155,1), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:LEMON_MAINCOLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //设置tabbar背景颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
    //我来直播
//    _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _liveButton.frame = CGRectMake(self.tabBar.frame.size.width/2-30, -15, 60, 60);
//    _liveButton.layer.cornerRadius = 30;
//    _liveButton.layer.borderWidth = 5;
//    _liveButton.layer.borderColor = kWhiteColor.CGColor;
//    _liveButton.layer.masksToBounds = YES;
//    
//    [_liveButton setImage:[UIImage imageNamed:@"home_live"] forState:UIControlStateNormal];
//    _liveButton.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
//    [_liveButton addTarget:self action:@selector(onLiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark 点击我来直播
- (void)onLiveButtonClicked
{
//    DoLiveViewController* live = [[DoLiveViewController alloc] init];
//    live.delegate = (id<DoLiveDelegate>)_watchController;
//    [_watchController presentViewController:live animated:YES completion:nil];
    
#if kShowFuncDisplay
    
    FunctionViewController *vc = [[FunctionViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
#else
    TCPushlishViewController *pvc = [[TCPushlishViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:pvc];
#endif
}

#pragma mark 设置tabBarItem默认图标和选中图标

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        [self clickPushLiveViewControllerWithIndex:tabBarController.selectedIndex];
        return NO;
    }
    else if (viewController == [tabBarController.viewControllers objectAtIndex:3]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController = [[LMShopTabBarController alloc] init];
    }
    
    return YES;
}
- (void)setTabBarItem:(UITabBarItem *) tabBarItem withNormalImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andTitle:(NSString *)title
{
    [tabBarItem setImage:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:title];
}

- (void)clickPushLiveViewControllerWithIndex:(NSInteger)index {
    NSDictionary *dict = @{@"uid":[SARUserInfo userId]};
    __weak typeof(self)weakself = self;
    [[Business sharedInstance] postHostLiveStatesWithParam:dict succ:^(NSString *msg, id data) {
        weakself.selectedIndex = 2;
    } fail:^(NSString *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"禁播通知" message:error delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
//        weakself.selectedIndex = index;
//        weakself.tabBar.hidden = NO;
    }];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if(_liveButton.superview != nil)
//    {
//        [_liveButton removeFromSuperview];
//    }
//    [self.tabBar addSubview:_liveButton];
    
    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    
    NSString *badge = nil;
    if (unRead > 0 && unRead <= 99)
    {
        badge = [NSString stringWithFormat:@"%d", (int)unRead];
    }
    else if (unRead > 99)
    {
        badge = @"99+";
    }
    
//    _msgNav.tabBarItem.badgeValue = badge;
    
//    if(![[MultiIMManager sharedInstance] isLogin])
//    {
//        __weak MBProgressHUD *wh = _HUD;
//        __weak MainTabBarController *ws = self;
//        [_HUD showText:@"正在登录随心播" atMode:MBProgressHUDModeIndeterminate];
//        [[MultiIMManager sharedInstance] loginPhone:[UserInfo sharedInstance].userPhone sig:[UserInfo sharedInstance].userSig succ:^(NSString *msg) {
//            [wh hideText:msg atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
//        } fail:^(NSString *err) {
//            [wh hideText:@"登录IM失败" atMode:MBProgressHUDModeText andDelay:1 andCompletion:^{
//                [ws performSegueWithIdentifier:@"toLogin" sender:ws];
//            }];
//        }];
//    }
}
- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    NavigationViewController *curNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:3];
    if (self.selectedIndex == 3)
    {
        // 选的中会话tab
        // 先检查当前栈中是否聊天界面
        NSArray *array = [curNav viewControllers];
        for (UIViewController *vc in array)
        {
            if ([vc isKindOfClass:[IMAChatViewController class]])
            {
                // 有则返回到该界面
                IMAChatViewController *chat = (IMAChatViewController *)vc;
                [chat configWithUser:user];
                //                chat.hidesBottomBarWhenPushed = YES;
                [curNav popToViewController:chat animated:YES];
                return;
            }
        }
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        
        if ([user isC2CType])
        {
            TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
            if ([imconv getUnReadMessageNum] > 0)
            {
                [vc modifySendInputStatus:SendInputStatus_Send];
            }
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
    }
    else
    {
        NavigationViewController *chatNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:0];
        
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        vc.hidesBottomBarWhenPushed = YES;
        [chatNav pushViewController:vc withBackTitle:@"返回" animated:YES];
        
        [self setSelectedIndex:0];
        
        if (curNav.viewControllers.count != 0)
        {
            [curNav popToRootViewControllerAnimated:YES];
        }
        
    }
}


//#pragma mark 消息和连接代理
//- (void)onConnSucc
//{
//    NSNumber* status = [NSNumber numberWithInt:NETWORK_CONN];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
//}
//- (void)onConnFailed:(int)code err:(NSString*)err
//{
//    NSNumber* status = [NSNumber numberWithInt:NETWORK_FAIL];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
//}
//- (void)onDisconnect:(int)code err:(NSString*)err
//{
//    NSNumber* status = [NSNumber numberWithInt:NETWORK_DISCONN];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
//}
@end
