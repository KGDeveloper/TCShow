//
//  LMShopBaseViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopBaseViewController.h"
#import "TarBarController.h"
#import "QZKRequestData.h"

@interface LMShopBaseViewController ()

@end

@implementation LMShopBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"lemon_guanbi") style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)exit {
    
    
    
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController = [[TarBarController alloc] init];
    
    
    
    
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
