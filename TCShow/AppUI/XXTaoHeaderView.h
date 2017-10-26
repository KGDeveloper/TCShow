//
//  XXTaoHeaderView.h
//  TCShow
//
//  Created by tangtianshi on 16/12/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXTaoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UILabel *onePrice;
@property (weak, nonatomic) IBOutlet UILabel *oneName;


@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UILabel *twoPrice;
@property (weak, nonatomic) IBOutlet UILabel *twoName;

@property (weak, nonatomic) IBOutlet UIImageView *threeImage;
@property (weak, nonatomic) IBOutlet UILabel *threePrice;
@property (weak, nonatomic) IBOutlet UILabel *threeName;


@property (weak, nonatomic) IBOutlet UIButton *bannerBtn;
@property (weak, nonatomic) IBOutlet UIView *banner0;


@end
