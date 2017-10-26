//
//  MirrorHeadView.h
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MirrorViewHeaderDelegate <NSObject>
-(void)chooseClick:(NSString *)index;
@end

@interface MirrorHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *usersignLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImageView;
@property (weak, nonatomic) IBOutlet UIButton    *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton    *fansButton;
@property(nonatomic,assign) id<MirrorViewHeaderDelegate>mirDelegate;
- (IBAction)attentionClick:(id)sender;
- (IBAction)fansClick:(id)sender;
-(void)updateView:(NSDictionary *)userInfoDic;
@end
