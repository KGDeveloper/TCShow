//
//  TCUserInfoCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCLiveUserList.h"
@interface TCUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UIButton *liveStateButton;
@property (nonatomic,strong)NSString * is_live;//直播状态
@property (nonatomic,strong)TCLiveUserList * userModel;
@end
