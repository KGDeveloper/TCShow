//
//  XPersonalHomePageView.h
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "GCZActionSheet.h"

@interface XPersonalHomePageView : GCZCustomView
@property (weak, nonatomic) IBOutlet UIButton *reportBtn; // 举报按钮
@property (weak, nonatomic) IBOutlet UIImageView *headICon; // 头像图片
- (IBAction)reportBtnClick:(id)sender;
- (IBAction)closeBtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *user_naem; // 名称
- (IBAction)homePageViewBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg; // 性别图片
@property (weak, nonatomic) IBOutlet UILabel *city; // 城市
@property (weak, nonatomic) IBOutlet UILabel *user_number; // 奇客号
@property (weak, nonatomic) IBOutlet UILabel *fun_number; // 粉丝数
@property (weak, nonatomic) IBOutlet UILabel *concern_number; // 关注数
@property (weak, nonatomic) IBOutlet UILabel *usercp_number; // 魅力值
@property (weak, nonatomic) IBOutlet UIButton *followBtn; // 关注按钮


- (IBAction)attentionBtnClick:(id)sender;


@end
