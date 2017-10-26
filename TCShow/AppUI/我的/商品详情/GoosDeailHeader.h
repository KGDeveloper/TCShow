//
//  GoosDeailHeader.h
//  TCShow
//
//  Created by liberty on 2017/1/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoosDeailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *fmImage;
@property (weak, nonatomic) IBOutlet UILabel *saleNumber;
@property (weak, nonatomic) IBOutlet UILabel *province;

@property (weak, nonatomic) IBOutlet UIButton *catBtn;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *commLab;
@property (weak, nonatomic) IBOutlet UILabel *allNumber;
@property (weak, nonatomic) IBOutlet UILabel *collection;
@property (weak, nonatomic) IBOutlet UIImageView *appraiseIcon;
@property (weak, nonatomic) IBOutlet UILabel *appraiseName;
@property (weak, nonatomic) IBOutlet UILabel *appraiseDes;

@property (weak, nonatomic) IBOutlet UILabel *appraiseZanwu;


@property (nonatomic,copy)void(^diannpuBtnClickBlock)(void);
@property (nonatomic,copy)void(^leixingBtnClickBlock)(void);
@property (nonatomic,copy)void(^pingjiaBtnClickBlock)(void);
@property (nonatomic,copy)void(^loockTopBlock)(void);
@property (nonatomic,copy)void(^inputChatBlock)(void);
@end
