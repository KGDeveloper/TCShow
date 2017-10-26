//
//  LMShopTabBarController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopTabBarController.h"
#import "LMShopHomeViewController.h"
#import "LMShopClassViewController.h"
#import "LMShopCarViewController.h"
#import "LMShopNewViewController.h"
#import "LMMineViewController.h"
#import "QZKRequestData.h"

@interface LMShopTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LMShopTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTabBar];
    
}

- (void)initTabBar
{
    
    LMShopHomeViewController *dicoverVC = [[LMShopHomeViewController alloc]init];
    dicoverVC.title = @"柠檬商城";
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:dicoverVC];
    
    
    LMShopClassViewController *contactVC = [[LMShopClassViewController alloc] init];
    contactVC.title = @"分类";
    UINavigationController* focusNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    
    
    LMShopNewViewController *second = [[LMShopNewViewController alloc] init];
    second.title = @"新品";
    NavigationViewController *publishNav = [[NavigationViewController alloc]initWithRootViewController:second];
    
    
    LMShopCarViewController *mevc = [[LMShopCarViewController alloc]init];
    mevc.title = @"购物车";
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:mevc];
    
//    [QZKRequestData postDataNetWorkingWitData:@{@"uid":[SARUserInfo userId]} success:^(id netReturn) {
//        
//        if ([netReturn[@"data"] integerValue] == 1) {
//            
//            LMMineViewController *mine = [[LMMineViewController alloc] init];
//            UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
//            
//            
//            
//            self.viewControllers = [NSArray arrayWithObjects:discoverNav,focusNav,publishNav,meNav,mineNav,nil];
//            self.delegate = self;
//            //
//            //获取tabBarItem
//            UITabBarItem *watchLiveItem = [self.tabBar.items objectAtIndex:0];
//            UITabBarItem *focItem = [self.tabBar.items objectAtIndex:1];
//            UITabBarItem *msgItem = [self.tabBar.items objectAtIndex:2];
//            UITabBarItem *myCenterItem = [self.tabBar.items objectAtIndex:3];
//            UITabBarItem *mineCenter = [self.tabBar.items objectAtIndex:4];
//            //设置tabBarItem背景图标
//            //    [self setTabBarItem:watchLiveItem withNormalImageName:@"video" andSelectedImageName:@"video_hover" andTitle:nil];
//            //    [self setTabBarItem:doLiveItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
//            //    [self setTabBarItem:myCenterItem withNormalImageName:@"User" andSelectedImageName:@"User_hover" andTitle:nil];
//            
//            
//            [self setTabBarItem:watchLiveItem withNormalImageName:@"lemon_shangchang_none" andSelectedImageName:@"lemon_shangchang_sel" andTitle:@"商城"];
//            [self setTabBarItem:focItem withNormalImageName:@"lemon_class_none" andSelectedImageName:@"lemon_class_sel" andTitle:@"分类"];
//            [self setTabBarItem:msgItem withNormalImageName:@"lemon_new_none" andSelectedImageName:@"lemon_new_sel" andTitle:@"新品"];
//            [self setTabBarItem:myCenterItem withNormalImageName:@"taowu_none" andSelectedImageName:@"taowu_sel" andTitle:@"购物车"];
//            [self setTabBarItem:mineCenter withNormalImageName:@"mine_none" andSelectedImageName:@"mine_sel" andTitle:@"我的"];
//        }
//        else
//        {
            self.viewControllers = [NSArray arrayWithObjects:discoverNav,focusNav,publishNav,meNav,nil];
            self.delegate = self;
            //
            //获取tabBarItem
            UITabBarItem *watchLiveItem = [self.tabBar.items objectAtIndex:0];
            UITabBarItem *focItem = [self.tabBar.items objectAtIndex:1];
            UITabBarItem *msgItem = [self.tabBar.items objectAtIndex:2];
            UITabBarItem *myCenterItem = [self.tabBar.items objectAtIndex:3];
           
            //设置tabBarItem背景图标
            //    [self setTabBarItem:watchLiveItem withNormalImageName:@"video" andSelectedImageName:@"video_hover" andTitle:nil];
            //    [self setTabBarItem:doLiveItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
            //    [self setTabBarItem:myCenterItem withNormalImageName:@"User" andSelectedImageName:@"User_hover" andTitle:nil];
            
            
            [self setTabBarItem:watchLiveItem withNormalImageName:@"lemon_shangchang_none" andSelectedImageName:@"lemon_shangchang_sel" andTitle:@"商城"];
            [self setTabBarItem:focItem withNormalImageName:@"lemon_class_none" andSelectedImageName:@"lemon_class_sel" andTitle:@"分类"];
            [self setTabBarItem:msgItem withNormalImageName:@"lemon_new_none" andSelectedImageName:@"lemon_new_sel" andTitle:@"新品"];
            [self setTabBarItem:myCenterItem withNormalImageName:@"taowu_none" andSelectedImageName:@"taowu_sel" andTitle:@"购物车"];
            
//        }
//    }];

    //设置未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YCColor(155,155,155,1), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:LEMON_MAINCOLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //设置tabbar背景颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
}

- (void)setTabBarItem:(UITabBarItem *) tabBarItem withNormalImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andTitle:(NSString *)title
{
    [tabBarItem setImage:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:title];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
