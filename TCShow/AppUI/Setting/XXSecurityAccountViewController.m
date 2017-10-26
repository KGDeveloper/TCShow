//
//  XXSecurityAccountViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXSecurityAccountViewController.h"
#import "XXPhoneBoundViewController.h"
@interface XXSecurityAccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;  // 图
@property (weak, nonatomic) IBOutlet UILabel *grade; // 等级
@property (weak, nonatomic) IBOutlet UILabel *unbound; // 未绑定
@property (weak, nonatomic) IBOutlet UIImageView *shape; // 箭头
@property (weak, nonatomic) IBOutlet UILabel *boundPhone; // 绑定的电话
@property (weak, nonatomic) IBOutlet UIView *boundView;

@end

@implementation XXSecurityAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户安全";
    _boundPhone.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bound)];
    [_boundView addGestureRecognizer:tap];
}

- (void)bound{
    XXPhoneBoundViewController *VC = [[XXPhoneBoundViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    

}

@end
