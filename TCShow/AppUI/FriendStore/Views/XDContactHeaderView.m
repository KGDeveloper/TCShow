//
//  XDContactHeaderView.m
//  TCShow
//
//  Created by tangtianshi on 2016/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XDContactHeaderView.h"
#import "XSearchFriendViewController.h"
#import "XDPlaybackController.h"
#import "MJExtension.h"
@interface XDContactHeaderView ()
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightVIew;
@property (strong, nonatomic)NSMutableArray * dataSourceArray;
@end
@implementation XDContactHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self.searchView cornerViewWithRadius:5];
    UITapGestureRecognizer * searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [self.searchView addGestureRecognizer:searchTap];
    
    UITapGestureRecognizer * leftViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftViewClick)];
    [self.leftView addGestureRecognizer:leftViewTap];
    
    UITapGestureRecognizer * rightViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightViewClick)];
    [self.rightVIew addGestureRecognizer:rightViewTap];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[Business sharedInstance] friendLivingList:[SARUserInfo userId] type:nil succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            hud.hidden = YES;
            _dataSourceArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
            [self addLoadVoew];
        }else{
            hud.labelText = msg;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
        }
    } fail:^(NSString *error) {
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
}

-(void)addLoadVoew{
    if (_dataSourceArray.count>0) {
        TCShowLiveListItem * leftViewModel = _dataSourceArray[0];
        if (_dataSourceArray.count>1) {
            TCShowLiveListItem * rightViewModel = _dataSourceArray[1];
             [self.CoverImgArr[1] sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(rightViewModel.cover)] placeholderImage:kDefaultCoverIcon];
            UILabel * rightTitle = _liveStoreLabArr[1];
            rightTitle.text = rightViewModel.title;
        }
        [self.CoverImgArr[0] sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(leftViewModel.cover)] placeholderImage:kDefaultCoverIcon];
        UILabel * leftTitle = _liveStoreLabArr[0];
        leftTitle.text = leftViewModel.title;
    }
}


#pragma mark ---------leftViewClick
-(void)leftViewClick{

}

#pragma mark ---------rightViewClick
-(void)rightViewClick{

}


-(void)searchClick{
    XSearchFriendViewController *vc = [[XSearchFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)moreClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MyInfoStoryboard" bundle:[NSBundle mainBundle]];
    XDPlaybackController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([XDPlaybackController class])];
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
}
@end
