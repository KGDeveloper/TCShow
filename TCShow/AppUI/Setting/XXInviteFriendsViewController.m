//
//  XXInviteFriendsViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXInviteFriendsViewController.h"

@interface XXInviteFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *curtainView; // 幕布

@end

@implementation XXInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    _img.layer.cornerRadius = 30;
    _inviteBtn.layer.cornerRadius = 2.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_curtainView addGestureRecognizer:tap];
    _shareView.hidden = YES;
    _curtainView.hidden = YES;
}
- (IBAction)invite:(id)sender {
    _shareView.hidden = NO;
    _curtainView.hidden = NO;
    
}

- (void)dismiss{
    _shareView.hidden = YES;
    _curtainView.hidden = YES;

}

@end
