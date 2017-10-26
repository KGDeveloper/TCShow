//
//  FansTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FansTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (strong, nonatomic) IBOutlet UIImageView *fansStateImage;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;

@end
