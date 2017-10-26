//
//  LMFriendsViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/18.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMFriendsViewController.h"

@interface LMFriendsViewController ()

@end

@implementation LMFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contact_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    
    
}

-(void)rightAtemClick{
    AddFriendViewController *vc = [[AddFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
