//
//  TCUserProfileView.h
//  TCShow
//
//  Created by tangtianshi on 16/12/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCUserProfileView : UIView<UIActionSheetDelegate>
{
@protected
    
    UIView              *_backView;
@protected
    UIView              *_contentView;
    
    UIImageView         *_icon;//头像
    UILabel             *_name;//昵称
    UIButton            *_report;//举报
//    UILabel             *_signature;//个性签名
//    UILabel             *_desc;//描述
    UILabel             *_attionNumber;//关注
    UILabel             *_fansNumber;//粉丝
    UIButton            *_focus;//关注按钮
    UIButton            *_chat;//私信按钮
    
@protected
    TIMUserProfile      *_showUser;
    NSDictionary * _userDic;
    TCShowLiveListItem * _userModel;
}
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
//@property (weak, nonatomic) IBOutlet UILabel *attionNumber;
//@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet UIButton *attionButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (nonatomic,strong)NSDictionary * userDic;
//@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,copy)void(^chatFromLive)(TCShowLiveListItem *);

- (void)showUser:(TCShowLiveListItem *)user;
@end
