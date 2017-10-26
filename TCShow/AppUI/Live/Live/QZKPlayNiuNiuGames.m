//
//  QZKPlayNiuNiuGames.m
//  TCShow
//
//  Created by  m, on 2017/9/20.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKPlayNiuNiuGames.h"


#define KSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define KSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define KSCreenSelfWidth self.frame.size.width
#define KSCreenSelfHeight self.frame.size.height


@implementation QZKPlayNiuNiuGames

- (instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        self = [super initWithFrame:frame];
        [self creatUI];
            self.timerNmb = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startSendState) userInfo:nil repeats:YES];
        self.secondTimer = 1;
        self.timerNumber = 45;
        self.m = 0;
        self.n = 0;
    }
    return self;
}

- (void) creatUI{
    //庄家标识
    self.palyView = [[UIView alloc]initWithFrame:CGRectMake(10,5, 100, 150)];
    self.palyView.backgroundColor = [UIColor clearColor];
    self.palyView.layer.cornerRadius = 10.0f;
    self.palyView.layer.borderWidth = 2.0f;
    self.palyView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.palyView.layer.masksToBounds = YES;
    UILabel *mineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.palyView.frame.size.width, 20)];
    mineLab.backgroundColor = [UIColor clearColor];
    mineLab.text = @"庄家";
    mineLab.textAlignment = NSTextAlignmentCenter;
    mineLab.textColor = [UIColor whiteColor];
    [self.palyView addSubview:mineLab];
    
    //显示牌
    self.oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(11, 45, 42, 59)];
    self.oneImage.layer.cornerRadius = 5.0f;
    self.oneImage.layer.masksToBounds = YES;
    self.oneImage.image = [UIImage imageNamed:@""];
    self.twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 45, 42, 59)];
    self.twoImage.layer.cornerRadius = 5.0f;
    self.twoImage.layer.masksToBounds = YES;
    self.twoImage.image = [UIImage imageNamed:@""];
    self.threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(29, 45, 42, 59)];
    self.threeImage.layer.cornerRadius = 5.0f;
    self.threeImage.layer.masksToBounds = YES;
    self.threeImage.image = [UIImage imageNamed:@""];
    self.fourImage = [[UIImageView alloc]initWithFrame:CGRectMake(38, 45, 42, 59)];
    self.fourImage.layer.cornerRadius = 5.0f;
    self.fourImage.layer.masksToBounds = YES;
    self.fourImage.image = [UIImage imageNamed:@""];
    self.fiveImage = [[UIImageView alloc]initWithFrame:CGRectMake(47, 45, 42, 59)];
    self.fiveImage.layer.cornerRadius = 5.0f;
    self.fiveImage.layer.masksToBounds = YES;
    self.fiveImage.image = [UIImage imageNamed:@""];
    
    
    [self.palyView addSubview:self.oneImage];
    [self.palyView addSubview:self.twoImage];
    [self.palyView addSubview:self.threeImage];
    [self.palyView addSubview:self.fourImage];
    [self.palyView addSubview:self.fiveImage];
    
    //显示点数的
    self.minepoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, self.palyView.size.width, 20)];
    self.minepoint.backgroundColor = [UIColor clearColor];
    [self.palyView addSubview:self.minepoint];
    
    
    [self addSubview:self.palyView];
    
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (KSCREEN_HEIGHT/2) + 40, KSCREEN_WIDTH, 1)];
    lineLab.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineLab];
    
    self.starLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (KSCREEN_HEIGHT/2) + 40 + 1, KSCREEN_WIDTH, 35)];
    self.starLab.text = @"倒计时";
    self.starLab.textAlignment = NSTextAlignmentCenter;
    self.starLab.backgroundColor = [UIColor clearColor];
    [self addSubview:self.starLab];
    
    UIButton *clickBut = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH - 55, (KSCREEN_HEIGHT/2) + 40 + 1, 35, 35)];
    clickBut.backgroundColor = [UIColor clearColor];
    [clickBut setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [clickBut addTarget:self action:@selector(clickButtonDidTouch:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:clickBut];
    
    self.pokerImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, (KSCREEN_HEIGHT/2) + 40 + 1, 40, 35)];
    self.pokerImage.backgroundColor = [UIColor clearColor];
    self.pokerImage.image = [UIImage imageNamed:@"pokerBack"];
    [self bringSubviewToFront:self.pokerImage];
    
    //一号桌
    self.userOneView = [[UIView alloc]initWithFrame:CGRectMake(5, KSCREEN_HEIGHT/2 + 40 + 36, (KSCREEN_WIDTH - 30)/3, 150)];
    self.userOneView.layer.cornerRadius = 10.0f;
    self.userOneView.layer.borderWidth = 1.0f;
    self.userOneView.layer.masksToBounds = YES;
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:self.userOneView];
    
    //显示牌
    self.userOneImageOne = [[UIImageView alloc]initWithFrame:CGRectMake(11, self.userOneView.frame.size.height - 79, 42, 59)];
    self.userOneImageOne.layer.cornerRadius = 5.0f;
    self.userOneImageOne.layer.masksToBounds = YES;
    self.userOneImageOne.image = [UIImage imageNamed:@""];
    self.userOneImageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(26, self.userOneView.frame.size.height - 79, 42, 59)];
    self.userOneImageTwo.layer.cornerRadius = 5.0f;
    self.userOneImageTwo.layer.masksToBounds = YES;
    self.userOneImageTwo.image = [UIImage imageNamed:@""];
    self.userOneImageThree = [[UIImageView alloc]initWithFrame:CGRectMake(41, self.userOneView.frame.size.height - 79, 42, 59)];
    self.userOneImageThree.layer.cornerRadius = 5.0f;
    self.userOneImageThree.layer.masksToBounds = YES;
    self.userOneImageThree.image = [UIImage imageNamed:@""];
    self.userOneImageFour = [[UIImageView alloc]initWithFrame:CGRectMake(56, self.userOneView.frame.size.height - 79, 42, 59)];
    self.userOneImageFour.layer.cornerRadius = 5.0f;
    self.userOneImageFour.layer.masksToBounds = YES;
    self.userOneImageFour.image = [UIImage imageNamed:@""];
    self.userOneImageFive = [[UIImageView alloc]initWithFrame:CGRectMake(71, self.userOneView.frame.size.height - 79, 42, 59)];
    self.userOneImageFive.layer.cornerRadius = 5.0f;
    self.userOneImageFive.layer.masksToBounds = YES;
    self.userOneImageFive.image = [UIImage imageNamed:@""];
    
    
    [self.userOneView addSubview:self.userOneImageOne];
    [self.userOneView addSubview:self.userOneImageTwo];
    [self.userOneView addSubview:self.userOneImageThree];
    [self.userOneView addSubview:self.userOneImageFour];
    [self.userOneView addSubview:self.userOneImageFive];
    
    self.userOneLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userOneView.frame.size.width - 40, 20)];
    self.userOneLab.text = @"0/0";
    self.userOneLab.textColor = [UIColor yellowColor];
    self.userOneLab.textAlignment = NSTextAlignmentCenter;
    self.userOneLab.backgroundColor = [UIColor blackColor];
    self.userOneLab.layer.cornerRadius = 10.0f;
    self.userOneLab.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.userOneLab.layer.borderWidth = 1.0f;
    self.userOneLab.layer.masksToBounds = YES;
    [self.userOneView addSubview:self.userOneLab];
    
    self.btuOne = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 80, 80)];
    [self.btuOne setTitle:@"押注" forState:UIControlStateNormal];
    self.btuOne.titleLabel.font = [UIFont systemFontOfSize:13];
    self.btuOne.backgroundColor = [UIColor clearColor];
    [self.btuOne setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btuOne setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    [self.btuOne addTarget:self action:@selector(btuOneDidTouch:) forControlEvents:UIControlEventTouchDown];
    [self.userOneView addSubview:self.btuOne];
    
    self.userOneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userOneTapDid)];
    self.userOneTap.numberOfTapsRequired = 1;
    self.userOneTap.numberOfTouchesRequired = 1;
    [self.userOneView addGestureRecognizer:self.userOneTap];

    
    //二号桌
    self.userTwoView = [[UIView alloc]initWithFrame:CGRectMake((KSCREEN_WIDTH - 30)/3 + 15, KSCREEN_HEIGHT/2 + 40 + 36, (KSCREEN_WIDTH - 30)/3, 150)];
    self.userTwoView.layer.cornerRadius = 10.0f;
    self.userTwoView.layer.borderWidth = 1.0f;
    self.userTwoView.layer.masksToBounds = YES;
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:self.userTwoView];
    
    //显示牌
    self.userTwoImageOne = [[UIImageView alloc]initWithFrame:CGRectMake(11, self.userTwoView.frame.size.height - 79, 42, 59)];
    self.userTwoImageOne.layer.cornerRadius = 5.0f;
    self.userTwoImageOne.layer.masksToBounds = YES;
    self.userTwoImageOne.image = [UIImage imageNamed:@""];
    self.userTwoImageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(26, self.userTwoView.frame.size.height - 79, 42, 59)];
    self.userTwoImageTwo.layer.cornerRadius = 5.0f;
    self.userTwoImageTwo.layer.masksToBounds = YES;
    self.userTwoImageTwo.image = [UIImage imageNamed:@""];
    self.userTwoImageThree = [[UIImageView alloc]initWithFrame:CGRectMake(41, self.userTwoView.frame.size.height - 79, 42, 59)];
    self.userTwoImageThree.layer.cornerRadius = 5.0f;
    self.userTwoImageThree.layer.masksToBounds = YES;
    self.userTwoImageThree.image = [UIImage imageNamed:@""];
    self.userTwoImageFour = [[UIImageView alloc]initWithFrame:CGRectMake(56, self.userTwoView.frame.size.height - 79, 42, 59)];
    self.userTwoImageFour.layer.cornerRadius = 5.0f;
    self.userTwoImageFour.layer.masksToBounds = YES;
    self.userTwoImageFour.image = [UIImage imageNamed:@""];
    self.userTwoImageFive = [[UIImageView alloc]initWithFrame:CGRectMake(71, self.userTwoView.frame.size.height - 79, 42, 59)];
    self.userTwoImageFive.layer.cornerRadius = 5.0f;
    self.userTwoImageFive.layer.masksToBounds = YES;
    self.userTwoImageFive.image = [UIImage imageNamed:@""];
    
    
    [self.userTwoView addSubview:self.userTwoImageOne];
    [self.userTwoView addSubview:self.userTwoImageTwo];
    [self.userTwoView addSubview:self.userTwoImageThree];
    [self.userTwoView addSubview:self.userTwoImageFour];
    [self.userTwoView addSubview:self.userTwoImageFive];
    
    self.userTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userOneView.frame.size.width - 40, 20)];
    self.userTwoLab.text = @"0/0";
    self.userTwoLab.textColor = [UIColor blueColor];
    self.userTwoLab.textAlignment = NSTextAlignmentCenter;
    self.userTwoLab.backgroundColor = [UIColor whiteColor];
    self.userTwoLab.layer.cornerRadius = 10.0f;
    self.userTwoLab.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userTwoLab.layer.borderWidth = 1.0f;
    self.userTwoLab.layer.masksToBounds = YES;
    [self.userTwoView addSubview:self.userTwoLab];
    
    self.btuTwo = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 80, 80)];
    [self.btuTwo setTitle:@"押注" forState:UIControlStateNormal];
    self.btuTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    self.btuTwo.backgroundColor = [UIColor clearColor];
    [self.btuTwo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btuTwo setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    [self.btuTwo addTarget:self action:@selector(btuTwoDidTouch:) forControlEvents:UIControlEventTouchDown];
    [self.userTwoView addSubview:self.btuTwo];
    
    self.userTwoTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTwoTapDid)];
    self.userTwoTap.numberOfTapsRequired = 1;
    self.userTwoTap.numberOfTouchesRequired = 1;
    [self.userTwoView addGestureRecognizer:self.userTwoTap];
    
    //三号桌
    self.userThreeView = [[UIView alloc]initWithFrame:CGRectMake(((KSCREEN_WIDTH - 30)/3)*2 + 25, KSCREEN_HEIGHT/2 + 40 + 36, (KSCREEN_WIDTH - 30)/3, 150)];
    self.userThreeView.layer.cornerRadius = 10.0f;
    self.userThreeView.layer.borderWidth = 1.0f;
    self.userThreeView.layer.masksToBounds = YES;
    self.userThreeView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:self.userThreeView];
    
    //显示牌
    self.userThreeImageOne = [[UIImageView alloc]initWithFrame:CGRectMake(11, self.userThreeView.frame.size.height - 79, 42, 59)];
    self.userThreeImageOne.layer.cornerRadius = 5.0f;
    self.userThreeImageOne.layer.masksToBounds = YES;
    self.userThreeImageOne.image = [UIImage imageNamed:@""];
    self.userThreeImageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(26, self.userThreeView.frame.size.height - 79, 42, 59)];
    self.userThreeImageTwo.layer.cornerRadius = 5.0f;
    self.userThreeImageTwo.layer.masksToBounds = YES;
    self.userThreeImageTwo.image = [UIImage imageNamed:@""];
    self.userThreeImageThree = [[UIImageView alloc]initWithFrame:CGRectMake(41, self.userThreeView.frame.size.height - 79, 42, 59)];
    self.userThreeImageThree.layer.cornerRadius = 5.0f;
    self.userThreeImageThree.layer.masksToBounds = YES;
    self.userThreeImageThree.image = [UIImage imageNamed:@""];
    self.userThreeImageFour = [[UIImageView alloc]initWithFrame:CGRectMake(56, self.userThreeView.frame.size.height - 79, 42, 59)];
    self.userThreeImageFour.layer.cornerRadius = 5.0f;
    self.userThreeImageFour.layer.masksToBounds = YES;
    self.userThreeImageFour.image = [UIImage imageNamed:@""];
    self.userThreeImageFive = [[UIImageView alloc]initWithFrame:CGRectMake(71, self.userThreeView.frame.size.height - 79, 42, 59)];
    self.userThreeImageFive.layer.cornerRadius = 5.0f;
    self.userThreeImageFive.layer.masksToBounds = YES;
    self.userThreeImageFive.image = [UIImage imageNamed:@""];
    
    [self.userThreeView addSubview:self.userThreeImageOne];
    [self.userThreeView addSubview:self.userThreeImageTwo];
    [self.userThreeView addSubview:self.userThreeImageThree];
    [self.userThreeView addSubview:self.userThreeImageFour];
    [self.userThreeView addSubview:self.userThreeImageFive];
    
    self.userThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.userOneView.frame.size.width - 40, 20)];
    self.userThreeLab.text = @"0/0";
    self.userThreeLab.textColor = [UIColor redColor];
    self.userThreeLab.textAlignment = NSTextAlignmentCenter;
    self.userThreeLab.backgroundColor = [UIColor whiteColor];
    self.userThreeLab.layer.cornerRadius = 10.0f;
    self.userThreeLab.layer.borderColor = [[UIColor redColor] CGColor];
    self.userThreeLab.layer.borderWidth = 1.0f;
    self.userThreeLab.layer.masksToBounds = YES;
    [self.userThreeView addSubview:self.userThreeLab];
    
    self.btuThree = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 80, 80)];
    [self.btuThree setTitle:@"押注" forState:UIControlStateNormal];
    self.btuThree.titleLabel.font = [UIFont systemFontOfSize:13];
    self.btuThree.backgroundColor = [UIColor clearColor];
    [self.btuThree setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btuThree setBackgroundImage:[UIImage imageNamed:@"stake"] forState:UIControlStateNormal];
    [self.btuThree addTarget:self action:@selector(btuThreeDidTouch:) forControlEvents:UIControlEventTouchDown];
    [self.userThreeView addSubview:self.btuThree];

    self.userThreeTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userThreeTapDid)];
    self.userThreeTap.numberOfTapsRequired = 1;
    self.userThreeTap.numberOfTouchesRequired = 1;
    [self.userThreeView addGestureRecognizer:self.userThreeTap];
    
    UILabel *background = [[UILabel alloc]initWithFrame:CGRectMake(0, (KSCREEN_HEIGHT/2) + 40 , KSCREEN_WIDTH, (KSCREEN_HEIGHT/2) - 40)];
    background.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:background];
    [self insertSubview:background atIndex:0];
    
    //显示积分的lable
    self.chipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, KSCreenSelfHeight - 134, KSCreenSelfWidth/2 - 94, 44)];
    self.chipLable.text = @"积分:12345";
    self.chipLable.textColor = [UIColor whiteColor];
    self.chipLable.backgroundColor = [UIColor clearColor];
    self.chipLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipLable];
    
    //充值按钮
    self.chipBut = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenSelfWidth/2 - 94,KSCreenSelfHeight - 132, 94, 38)];
    [self.chipBut setTitle:@"充值>" forState:UIControlStateNormal];
    [self.chipBut addTarget:self action:@selector(chipButDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.chipBut];
    
    //10积分下注按钮
    self.chipOne = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenSelfWidth/2, KSCreenSelfHeight - 132, 38, 38)];
    [self.chipOne setTitle:@"10" forState:UIControlStateNormal];
    self.chipOne.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipOne setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipOne.tag = 10;
    self.chipOne.alpha = 1;
    [self.chipOne setBackgroundImage:[UIImage imageNamed:@"chip10"] forState:UIControlStateNormal];
    [self.chipOne addTarget:self action:@selector(chipOneDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.chipOne];
    
    
    //25积分下注按钮
    self.chipTwo = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenSelfWidth/8 + KSCreenSelfWidth/2, KSCreenSelfHeight - 132, 38, 38)];
    [self.chipTwo setBackgroundImage:[UIImage imageNamed:@"chip25"] forState:UIControlStateNormal];
    [self.chipTwo setTitle:@"50" forState:UIControlStateNormal];
    self.chipTwo.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipTwo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipTwo.tag = 50;
    self.chipTwo.alpha = 0.5f;
    [self.chipTwo addTarget:self action:@selector(chipTwoDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.chipTwo];
    
    //50积分下注按钮
    self.chipThreen = [[UIButton alloc]initWithFrame:CGRectMake(KSCreenSelfWidth/4 + KSCreenSelfWidth/2, KSCreenSelfHeight - 132, 38, 38)];
    [self.chipThreen setBackgroundImage:[UIImage imageNamed:@"chip50"] forState:UIControlStateNormal];
    [self.chipThreen setTitle:@"100" forState:UIControlStateNormal];
    self.chipThreen.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipThreen setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipThreen.tag = 100;
    self.chipThreen.alpha = 0.5f;
    [self.chipThreen addTarget:self action:@selector(chipThreenDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.chipThreen];
    
    //100积分下注按钮
    self.chipFour = [[UIButton alloc]initWithFrame:CGRectMake((KSCreenSelfWidth/8)*3 + KSCreenSelfWidth/2, KSCreenSelfHeight - 132, 38, 38)];
    [self.chipFour setBackgroundImage:[UIImage imageNamed:@"chip100"] forState:UIControlStateNormal];
    [self.chipFour setTitle:@"500" forState:UIControlStateNormal];
    self.chipFour.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.chipFour setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chipFour.tag = 500;
    self.chipFour.alpha = 0.5f;
    [self.chipFour addTarget:self action:@selector(chipFourDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.chipFour];
    
    self.onepoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.userOneView.frame.size.height - 60, self.userOneView.size.width, 20)];
    self.onepoint.backgroundColor = [UIColor clearColor];
    [self.userOneView addSubview:self.onepoint];
    
    self.twopoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.userTwoView.frame.size.height - 60, self.userTwoView.size.width, 20)];
    self.twopoint.backgroundColor = [UIColor clearColor];
    [self.userTwoView addSubview:self.twopoint];
    
    self.threepoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.userThreeView.frame.size.height - 60, self.userThreeView.size.width, 20)];
    self.threepoint.backgroundColor = [UIColor clearColor];
    [self.userThreeView addSubview:self.threepoint];

    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
    }];
    
}

- (void) chipButDidTouchDown:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(pushToViewcontroller:)])
    {
        QZKExchangeViewController *qzk = [[QZKExchangeViewController alloc]init];
        [_delegate pushToViewcontroller:qzk];
    }

}

- (void) chipOneDidTouchDown:(UIButton *)sender
{
    self.chipTwo.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

- (void) chipTwoDidTouchDown:(UIButton *)sender
{
    self.chipOne.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

- (void) chipThreenDidTouchDown:(UIButton *)sender
{
    self.chipTwo.alpha = 0.5f;
    self.chipOne.alpha = 0.5f;
    self.chipFour.alpha = 0.5f;
}

- (void) chipFourDidTouchDown:(UIButton *)sender
{
    self.chipTwo.alpha = 0.5f;
    self.chipThreen.alpha = 0.5f;
    self.chipOne.alpha = 0.5f;
}

- (void) changeViewLabelState:(UIButton *)sender
{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    
    NSString *room_id = [NSString stringWithFormat:@"%@",self.room_id];
    
    NSInteger manay = [[[[[self.chipLable.text componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.userThreeView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor yellowColor] CGColor]) {
        
        
        NSInteger num = [[[self.userOneLab.text componentsSeparatedByString:@"/"] firstObject] integerValue];
        NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        if (num > manay/5 & sender.tag > manay/5) {
            
            [[HUDHelper sharedInstance] tipMessage:@"余额不足"];
        }else
        {
            [[Business sharedInstance] requesetDiceRoom:room_id bet_money:bet_money user_id:[SARUserInfo userId] table_number:@"1" succ:^(NSString *msg, id data) {
                
                self.userOneLab.text = [NSString stringWithFormat:@"%d/0",num + sender.tag];
                
            } fail:^(NSString *error) {
                
                
            }];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
            image.tag = sender.tag;
            image.frame = sender.frame;
            [self addSubview:image];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                NSInteger rectmake = arc4random()%10;
                image.frame = CGRectMake(self.userOneView.frame.size.width/2 - rectmake, self.userOneView.frame.size.height/2 - rectmake, 20, 20);
                [self.userOneView addSubview:image];
                
            }];

        }
        
        
    }
    else if (self.userThreeView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor blueColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor whiteColor] CGColor])
    {
        
        NSInteger num = [[[self.userTwoLab.text componentsSeparatedByString:@"/"] firstObject] integerValue];
        NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        if (num > manay/5 & sender.tag > manay/5) {
            
            [[HUDHelper sharedInstance] tipMessage:@"余额不足"];
        }else
        {
        
        [[Business sharedInstance] requesetDiceRoom:room_id bet_money:bet_money user_id:[SARUserInfo userId] table_number:@"2" succ:^(NSString *msg, id data) {
            
            self.userTwoLab.text = [NSString stringWithFormat:@"%ld/0",num + sender.tag];
            
        } fail:^(NSString *error) {
            
            
        }];
        
        
        UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
        image.tag = sender.tag;
        image.frame = CGRectMake(sender.frame.origin.x - (KSCREEN_WIDTH - 30)/3 - 38, sender.frame.origin.y - 38, sender.frame.size.width, sender.frame.size.height);
        [self addSubview:image];
        
        [UIView animateWithDuration:0.2 animations:^{
            NSInteger rectmake = arc4random()%10;
            image.frame = CGRectMake(self.userTwoView.frame.size.width/2 - rectmake, self.userTwoView.frame.size.height/2 - rectmake, 20, 20);
            [self.userTwoView addSubview:image];
        }];
        }
        
        
    }
    else if (self.userThreeView.layer.borderColor == [[UIColor redColor] CGColor] && self.userTwoView.layer.borderColor == [[UIColor whiteColor] CGColor] && self.userOneView.layer.borderColor == [[UIColor whiteColor] CGColor])
    {
        
        NSInteger num = [[[self.userThreeLab.text componentsSeparatedByString:@"/"] firstObject] integerValue];
        
        NSString *bet_money =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        if (num > manay/5 & sender.tag > manay/5) {
            
            [[HUDHelper sharedInstance] tipMessage:@"余额不足"];
        }else
        {
        
        [[Business sharedInstance] requesetDiceRoom:room_id bet_money:bet_money user_id:[SARUserInfo userId] table_number:@"3" succ:^(NSString *msg, id data) {
            
            self.userThreeLab.text = [NSString stringWithFormat:@"%ld/0", num + sender.tag];
            
        } fail:^(NSString *error) {
            
            
        }];
        
        UIImageView *image = [[UIImageView alloc]initWithImage:sender.currentBackgroundImage];
        image.tag = sender.tag;
        image.frame = CGRectMake(sender.frame.origin.x - ((KSCREEN_WIDTH - 30)/3)*2 - 38 , sender.frame.origin.y - 38, sender.frame.size.width, sender.frame.size.height);
        [self addSubview:image];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            NSInteger rectmake = arc4random()%10;
            image.frame = CGRectMake(self.userThreeView.frame.size.width/2 - rectmake, self.userThreeView.frame.size.height/2 - rectmake, 20, 20);
            [self.userThreeView addSubview:image];
            
        }];
        }
        
    }
    
    
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
        
    } fail:^(NSString *error) {
        
        
    }];
    
    [[Business sharedInstance] requestNumberManay:room_id succ:^(NSString *msg, id data) {
        
        NSArray *arr = data;
        
        for (int i = 0; i < arr.count; i++) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = arr[i];
            
            if ([dic[@"table_number"] integerValue] == 1) {
                
                NSString *str = [[weakSelf.userOneLab.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userOneLab.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }
            else if ([dic[@"table_number"] integerValue] == 2) {
                
                NSString *str = [[weakSelf.userTwoLab.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userTwoLab.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }
            else if ([dic[@"table_number"] integerValue] == 3) {
                
                NSString *str = [[weakSelf.userThreeLab.text componentsSeparatedByString:@"/"] firstObject];
                weakSelf.userThreeLab.text = [NSString stringWithFormat:@"%@/%@",str,dic[@"bet_money_sum"]];
            }
        }

        
    } fail:^(NSString *error) {
        
        
    }];
     
}


- (void) sendNamePlayMuices:(NSString *)name{

    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
}


- (void) userOneTapDid{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
    if (self.chipOne.alpha == 1) {
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void) userTwoTapDid{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
    if (self.chipOne.alpha == 1) {
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void) userThreeTapDid{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor redColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
    if (self.chipOne.alpha == 1) {
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipOne];
    }else if (self.chipTwo.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipTwo];
    }else if (self.chipThreen.alpha == 1){
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipThreen];
    }else{
        [self sendNamePlayMuices:@"加注.mp3"];
        [self changeViewLabelState:self.chipFour];
    }
}

- (void) btuThreeDidTouch:(UIButton *)sender{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor redColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
}

- (void) btuOneDidTouch:(UIButton *)sender{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
}


- (void) btuTwoDidTouch:(UIButton *)sender{
    [[Business sharedInstance] requestUserIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        self.chipLable.text = [NSString stringWithFormat:@"积分:%@",data];
    } fail:^(NSString *error) {
        
    }];
    self.userOneView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userTwoView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userThreeView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btuOne.hidden = YES;
    self.btuTwo.hidden = YES;
    self.btuThree.hidden = YES;
}


- (void)clickButtonDidTouch:(UIButton *)sender{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GAMESVIEWHIDE" object:self]];
}

- (void)changeViewNumber{
    if ([self.gamesState isEqualToString:@"下注"]) {
        self.starLab.text = [NSString stringWithFormat:@"下注时间%ld秒",(long)self.changeGameState];
        if (self.changeGameState < 3) {
            self.chipOne.enabled = NO;
            self.chipTwo.enabled = NO;
            self.chipThreen.enabled = NO;
            self.chipFour.enabled = NO;
        }else{
            //打开下注按钮的交互
            self.chipOne.enabled = YES;
            self.chipTwo.enabled = YES;
            self.chipThreen.enabled = YES;
            self.chipFour.enabled = YES;
            if (self.butShow == 1) {
                self.btuOne.hidden = NO;
                self.btuTwo.hidden = NO;
                self.btuThree.hidden = NO;
                self.butShow = 0;
            }}
        if (self.changeGameState == 0) {
            self.gamesState = @"发牌";
        }
    }else if ([self.gamesState isEqualToString:@"发牌"]){
        self.starLab.text = @"开始";
        [self requestGamesNumber:self.m];
        [self sendNamePlayMuices:@"发牌.mp3"];
        for (id tmpView in [self.userOneView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }}}
        for (id tmpView in [self.userTwoView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }}}
        for (id tmpView in [self.userThreeView subviews]) {
            if ([tmpView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)tmpView;
                if (imageView.tag == 10) {
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 50){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 100){
                    [imageView removeFromSuperview];
                }else if (imageView.tag == 500){
                    [imageView removeFromSuperview];
                }}}
        //关闭下注按钮的交互
        self.chipOne.enabled = NO;
        self.chipTwo.enabled = NO;
        self.chipThreen.enabled = NO;
        self.chipFour.enabled = NO;
        self.btuOne.hidden = YES;
        self.btuTwo.hidden = YES;
        self.btuThree.hidden = YES;
        if (self.m == 10) {
            self.m = 0;
            for (id tmpView in [self subviews]) {
                if ([tmpView isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)tmpView;
                    if (imageView.tag == 101) {
                        [imageView removeFromSuperview];
                    }}}
            for (id tmpView in [self.userOneView subviews]) {
                if ([tmpView isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)tmpView;
                    if (imageView.tag == 101) {
                        [imageView removeFromSuperview];
                    }}}
            for (id tmpView in [self.userTwoView subviews]) {
                if ([tmpView isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)tmpView;
                    if (imageView.tag == 101) {
                        [imageView removeFromSuperview];
                    }}}
            for (id tmpView in [self.userThreeView subviews]) {
                if ([tmpView isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)tmpView;
                    if (imageView.tag == 101) {
                        [imageView removeFromSuperview];
                    }}}
                self.gamesState = @"结束";
        }else{
            self.m++;
        }
    }else if ([self.gamesState isEqualToString:@"结束"]){
        self.starLab.text = @"游戏结束";
        if (self.m == 5) {
            self.m = 0;
            [self requestGamesNumber:5];
            self.gamesState = @"休息";
        }else{
            self.m++;
        }
    }else if ([self.gamesState isEqualToString:@"休息"]){
        //关闭下注按钮的交互
        self.chipOne.enabled = NO;
        self.chipTwo.enabled = NO;
        self.chipThreen.enabled = NO;
        self.chipFour.enabled = NO;
        self.userOneLab.text = @"0/0";
        self.userTwoLab.text = @"0/0";
        self.userThreeLab.text = @"0/0";
        self.oneImage.image = [UIImage imageNamed:@""];
        self.twoImage.image = [UIImage imageNamed:@""];
        self.threeImage.image = [UIImage imageNamed:@""];
        self.fourImage.image = [UIImage imageNamed:@""];
        self.fiveImage.image = [UIImage imageNamed:@""];
        self.userOneImageOne.image = [UIImage imageNamed:@""];
        self.userOneImageTwo.image = [UIImage imageNamed:@""];
        self.userOneImageThree.image = [UIImage imageNamed:@""];
        self.userOneImageFour.image = [UIImage imageNamed:@""];
        self.userOneImageFive.image = [UIImage imageNamed:@""];
        self.userTwoImageOne.image = [UIImage imageNamed:@""];
        self.userTwoImageTwo.image = [UIImage imageNamed:@""];
        self.userTwoImageThree.image = [UIImage imageNamed:@""];
        self.userTwoImageFour.image = [UIImage imageNamed:@""];
        self.userTwoImageFive.image = [UIImage imageNamed:@""];
        self.userThreeImageOne.image = [UIImage imageNamed:@""];
        self.userThreeImageTwo.image = [UIImage imageNamed:@""];
        self.userThreeImageThree.image = [UIImage imageNamed:@""];
        self.userThreeImageFour.image = [UIImage imageNamed:@""];
        self.userThreeImageFive.image = [UIImage imageNamed:@""];
        self.onepoint.image = [UIImage imageNamed:@""];
        self.twopoint.image = [UIImage imageNamed:@""];
        self.threepoint.image = [UIImage imageNamed:@""];
        self.minepoint.image = [UIImage imageNamed:@""];
        self.butShow = 1;
        [self userIntoRoomRequestGamesState];
        self.starLab.text = @"休息时间";
    }
    self.changeGameState--;
}

/**
 开始向服务器发送游戏状态
 */
- (void)startSendState{
    
    
    if (self.userOrAv == NO) {
        
        if (self.secondTimer == 1) {
            [self userIntoRoomRequestGamesState];
            self.secondTimer++;
        }else if (self.secondTimer == 2){
            [self changeViewNumber];
            self.secondTimer = 1;
        }else{
            self.secondTimer = 2;
        }
    }else{
        
        if (self.secondTimer == 2) {
            if (self.timerNumber == 44) {
                
                [self userIntoRoomRequestGamesState];
            }
            if (self.timerNumber == 11) {
                [[Business sharedInstance] requestUserDiceData:self.room_id succ:^(NSString *msg, id data) {
                } fail:^(NSString *error) {
                }];
            }
            [self sendStateToServer];
            [self changeViewNumber];
            self.secondTimer = 1;
        }else{
            [self sendStateToServer];
            if (self.timerNumber == 0) {
                [self clearTopGamesInfo];
                self.timerNumber = 35;
            }else{
                self.timerNumber --;
            }
            self.secondTimer = 2;
        }
    }
}


/**
 定时器向服务器发送请求，添加游戏状态
 */
- (void)sendStateToServer{
    //oom_id（房间号）、bet_count_down（下注倒计时）、rest_count_down（休息倒计时）、game_state（状态：0：休息5s、1：下注30s、2：动画状态10s、3：结束状态5s）
    NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
    if (self.timerNumber > 15) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 15];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"1" forKey:@"game_state"];
        [[Business sharedInstance] addGamesState:roomid bet_count_down:bet_count_down rest_count_down:@"5" game_state:@"1" succ:^(NSString *msg, id data) {
        } fail:^(NSString *error) {
        }];
    }else if( self.timerNumber > 10 && self.timerNumber <= 15){
        if (self.timerNumber == 15) {
            [[Business sharedInstance] requestUserDiceData:roomid succ:^(NSString *msg, id data) {
            } fail:^(NSString *error) {
            }];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 10];
        NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"2" forKey:@"game_state"];
        [[Business sharedInstance] addGamesState:roomid bet_count_down:bet_count_down rest_count_down:@"5" game_state:@"2" succ:^(NSString *msg, id data) {
        } fail:^(NSString *error) {
        }];
    }else if(self.timerNumber > 5 && self.timerNumber <= 10){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber - 5];
        NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"3" forKey:@"game_state"];
        [[Business sharedInstance] addGamesState:roomid bet_count_down:bet_count_down rest_count_down:@"5" game_state:@"3" succ:^(NSString *msg, id data) {
        } fail:^(NSString *error) {
        }];
    }else if(self.timerNumber <= 5){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *bet_count_down = [NSString stringWithFormat:@"%ld",(long)self.timerNumber];
        NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
        [dic setValue:roomid forKey:@"room_id"];
        [dic setValue:bet_count_down forKey:@"bet_count_down"];
        [dic setValue:@"5" forKey:@"rest_count_down"];
        [dic setValue:@"0" forKey:@"game_state"];
        [[Business sharedInstance] addGamesState:roomid bet_count_down:bet_count_down rest_count_down:@"5" game_state:@"0" succ:^(NSString *msg, id data) {
        } fail:^(NSString *error) {
        }];
    }
}

- (void) clearTopGamesInfo{
    NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
    [[Business sharedInstance] requestNextDataDeletace:roomid succ:^(NSString *msg, id data) {
    } fail:^(NSString *error) {
    }];
}

/**
 用户进入房间开始向服务器请求游戏状态
 */
- (void) userIntoRoomRequestGamesState{
    NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
    __weak typeof(self) weakSelf = self;
    [[Business sharedInstance] requestGamesData:roomid succ:^(NSString *msg, id data) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:data[@"data"], nil];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *tmpdic = arr[i];
            if ([tmpdic[@"game_state"] integerValue] == 1) {
                weakSelf.gamesState = @"下注";
                weakSelf.changeGameState = [tmpdic[@"bet_count_down"] integerValue];
            }else if ([tmpdic[@"game_state"] integerValue] == 2){
                weakSelf.gamesState = @"发牌";
                weakSelf.changeGameState = 5;
            }else if ([tmpdic[@"game_state"] integerValue] == 3){
                weakSelf.gamesState = @"结束";
                weakSelf.changeGameState = 5;
            }else if([tmpdic[@"game_state"] integerValue] == 0){
                weakSelf.gamesState = @"休息";
                weakSelf.changeGameState = 5;
            }
        }
    } fail:^(NSString *error) {
    }];
}


- (void) requestGamesNumber:(NSInteger )state{
    NSString *roomid = [NSString stringWithFormat:@"%@",self.room_id];
    __weak typeof(self) weakSelf = self;
    [[Business sharedInstance] requestListData:roomid succ:^(NSString *msg, id data) {
        NSArray *arr = data[@"data"];
        for (int i = 0; i < arr.count; i++){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = arr[i];
            if ([dic[@"table_number"] isEqualToString:@"0"]) {
                    NSArray *tmpArr = [dic[@"point"] componentsSeparatedByString:@";"];
                    if (state == 0) {
                        //加载第一张图片
                        NSArray *onepointArr = [tmpArr[0] componentsSeparatedByString:@","];
                        UIImageView *aoneimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        aoneimage.tag = 101;
                        aoneimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                        [weakSelf bringSubviewToFront:aoneimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            aoneimage.frame = CGRectMake(weakSelf.oneImage.frame.origin.x + 10, weakSelf.oneImage.frame.origin.y + 5, 42, 59);
                        }];
                        weakSelf.oneImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                    }else if (state == 1){
                        //加载第二张图片
                        NSArray *twopointArr = [tmpArr[1] componentsSeparatedByString:@","];
                        UIImageView *atwoimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        atwoimage.tag = 101;
                        atwoimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                        [weakSelf addSubview:atwoimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            atwoimage.frame = CGRectMake(weakSelf.twoImage.frame.origin.x + 10, weakSelf.twoImage.frame.origin.y + 5, 42, 59);
                        }];
                        weakSelf.twoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                    }else if (state == 2){
                        //加载第三张图片
                        NSArray *threepointArr = [tmpArr[2] componentsSeparatedByString:@","];
                        UIImageView *athreeimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        athreeimage.tag = 101;
                        athreeimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                        [weakSelf addSubview:athreeimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            athreeimage.frame = CGRectMake(weakSelf.threeImage.frame.origin.x + 10, weakSelf.threeImage.frame.origin.y + 5, 42, 59);
                        }];
                        weakSelf.threeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                    }else if (state == 3){
                        //加载第四张图片
                        NSArray *fourpointArr = [tmpArr[3] componentsSeparatedByString:@","];
                        UIImageView *afourimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afourimage.tag = 101;
                        afourimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                        [weakSelf addSubview:afourimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afourimage.frame = CGRectMake(weakSelf.fourImage.frame.origin.x + 10, weakSelf.fourImage.frame.origin.y + 5, 42, 59);
                        }];
                        weakSelf.fourImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                    }else if (state == 4){
                        //加载第五张图片
                        UIImageView *afiveimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afiveimage.tag = 101;
                        afiveimage.image = [UIImage imageNamed:@"poker"];
                        [weakSelf addSubview:afiveimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afiveimage.frame = CGRectMake(weakSelf.fiveImage.frame.origin.x + 10, weakSelf.fiveImage.frame.origin.y + 5, 42, 59);
                        }];
                        weakSelf.fiveImage.image = [UIImage imageNamed:@"poker"];
                    }else{
                        NSArray *fivepointArr = [tmpArr[4] componentsSeparatedByString:@","];
                        weakSelf.fiveImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fivepointArr[1],fivepointArr[0]]];
                        weakSelf.minepoint.image = [UIImage imageNamed:[NSString stringWithFormat:@"niuniu%@",dic[@"point_sum"]]];
                    }
                }else if ([dic[@"table_number"] isEqualToString:@"1"]){
                    NSArray *tmpArr = [dic[@"point"] componentsSeparatedByString:@";"];
                    if (state == 0) {
                        //加载第一张图片
                        NSArray *onepointArr = [tmpArr[0] componentsSeparatedByString:@","];
                        UIImageView *aoneimage = [[UIImageView alloc]initWithFrame:CGRectMake(weakSelf.userOneView.frame.origin.x + 11, weakSelf.userOneView.frame.origin.y - 20, 45, 59)];
                        aoneimage.tag = 101;
                        aoneimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                        [weakSelf bringSubviewToFront:aoneimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            aoneimage.frame = CGRectMake(weakSelf.userOneView.frame.origin.x + 11, weakSelf.userOneView.frame.origin.y * weakSelf.userOneView.frame.size.height - 79, 42, 59);
                        }];
                        weakSelf.userOneImageOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                    }else if (state == 1){
                        //加载第二张图片
                        NSArray *twopointArr = [tmpArr[1] componentsSeparatedByString:@","];
                        UIImageView *atwoimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        atwoimage.tag = 101;
                        atwoimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                        [weakSelf addSubview:atwoimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            atwoimage.frame = CGRectMake(weakSelf.userOneImageTwo.frame.origin.x, weakSelf.userOneImageTwo.frame.origin.y, 42, 59);
                            [weakSelf.userOneView addSubview:atwoimage];
                        }];
                        weakSelf.userOneImageTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                    }else if (state == 2){
                        //加载第三张图片
                        NSArray *threepointArr = [tmpArr[2] componentsSeparatedByString:@","];
                        UIImageView *athreeimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        athreeimage.tag = 101;
                        athreeimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                        [weakSelf addSubview:athreeimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            athreeimage.frame = CGRectMake(weakSelf.userOneImageThree.frame.origin.x, weakSelf.userOneImageThree.frame.origin.y, 42, 59);
                            [weakSelf.userOneView addSubview:athreeimage];
                        }];
                        weakSelf.userOneImageThree.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                    }else if (state == 3){
                        //加载第四张图片
                        NSArray *fourpointArr = [tmpArr[3] componentsSeparatedByString:@","];
                        UIImageView *afourimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afourimage.tag = 101;
                        afourimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                        [weakSelf addSubview:afourimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afourimage.frame = CGRectMake(weakSelf.userOneImageFour.frame.origin.x, weakSelf.userOneImageFour.frame.origin.y, 42, 59);
                            [weakSelf.userOneView addSubview:afourimage];
                        }];
                        weakSelf.userOneImageFour.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                    }else if (state == 4){
                        //加载第五张图片
                        UIImageView *afiveimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afiveimage.tag = 101;
                        afiveimage.image = [UIImage imageNamed:@"poker"];
                        [weakSelf addSubview:afiveimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afiveimage.frame = CGRectMake(weakSelf.userOneImageFive.frame.origin.x, weakSelf.userOneImageFive.frame.origin.y, 42, 59);
                            [weakSelf.userOneView addSubview:afiveimage];
                        }];
                        weakSelf.userOneImageFive.image = [UIImage imageNamed:@"poker"];
                    }else{
                        NSArray *fivepointArr = [tmpArr[4] componentsSeparatedByString:@","];
                        weakSelf.userOneImageFive.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fivepointArr[1],fivepointArr[0]]];
                        weakSelf.onepoint.image = [UIImage imageNamed:[NSString stringWithFormat:@"niuniu%@",dic[@"point_sum"]]];
                    }
                }else if ([dic[@"table_number"] isEqualToString:@"2"]){
                    NSArray *tmpArr = [dic[@"point"] componentsSeparatedByString:@";"];
                    if (state == 0) {
                        //加载第一张图片
                        NSArray *onepointArr = [tmpArr[0] componentsSeparatedByString:@","];
                        UIImageView *aoneimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        aoneimage.tag = 101;
                        aoneimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                        [weakSelf bringSubviewToFront:aoneimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            aoneimage.frame = CGRectMake(weakSelf.userTwoImageOne.frame.origin.x, weakSelf.userTwoImageOne.frame.origin.y, 42, 59);
                            [weakSelf.userTwoView addSubview:aoneimage];
                        }];
                        weakSelf.userTwoImageOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                    }else if (state == 1){
                        //加载第二张图片
                        NSArray *twopointArr = [tmpArr[1] componentsSeparatedByString:@","];
                        UIImageView *atwoimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        atwoimage.tag = 101;
                        atwoimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                        [weakSelf addSubview:atwoimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            atwoimage.frame = CGRectMake(weakSelf.userTwoImageTwo.frame.origin.x, weakSelf.userTwoImageTwo.frame.origin.y, 42, 59);
                            [weakSelf.userTwoView addSubview:atwoimage];
                        }];
                        weakSelf.userTwoImageTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                    }else if (state == 2){
                        //加载第三张图片
                        NSArray *threepointArr = [tmpArr[2] componentsSeparatedByString:@","];
                        UIImageView *athreeimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        athreeimage.tag = 101;
                        athreeimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                        [weakSelf addSubview:athreeimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            athreeimage.frame = CGRectMake(weakSelf.userTwoImageThree.frame.origin.x, weakSelf.userTwoImageThree.frame.origin.y, 42, 59);
                            [weakSelf.userTwoView addSubview:athreeimage];
                        }];
                        weakSelf.userTwoImageThree.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                    }else if (state == 3){
                        //加载第四张图片
                        NSArray *fourpointArr = [tmpArr[3] componentsSeparatedByString:@","];
                        UIImageView *afourimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afourimage.tag = 101;
                        afourimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                        [weakSelf addSubview:afourimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afourimage.frame = CGRectMake(weakSelf.userTwoImageFour.frame.origin.x, weakSelf.userTwoImageFour.frame.origin.y, 42, 59);
                            [weakSelf.userTwoView addSubview:afourimage];
                        }];
                        weakSelf.userTwoImageFour.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                    }else if (state == 4){
                        //加载第五张图片
                        UIImageView *afiveimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afiveimage.tag = 101;
                        afiveimage.image = [UIImage imageNamed:@"poker"];
                        [weakSelf addSubview:afiveimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afiveimage.frame = CGRectMake(weakSelf.userTwoImageFive.frame.origin.x, weakSelf.userTwoImageFive.frame.origin.y, 42, 59);
                            [weakSelf.userTwoView addSubview:afiveimage];
                        }];
                        weakSelf.userTwoImageFive.image = [UIImage imageNamed:@"poker"];
                    }else{
                        NSArray *fivepointArr = [tmpArr[4] componentsSeparatedByString:@","];
                        weakSelf.userTwoImageFive.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fivepointArr[1],fivepointArr[0]]];
                        weakSelf.twopoint.image = [UIImage imageNamed:[NSString stringWithFormat:@"niuniu%@",dic[@"point_sum"]]];
                    }
                }else if ([dic[@"table_number"] isEqualToString:@"3"]){
                    NSArray *tmpArr = [dic[@"point"] componentsSeparatedByString:@";"];
                    if (state == 0) {
                        //加载第一张图片
                        NSArray *onepointArr = [tmpArr[0] componentsSeparatedByString:@","];
                        UIImageView *aoneimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        aoneimage.tag = 101;
                        aoneimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                        [weakSelf bringSubviewToFront:aoneimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            aoneimage.frame = CGRectMake(weakSelf.userThreeImageOne.frame.origin.x, weakSelf.userThreeImageOne.frame.origin.y, 42, 59);
                            [weakSelf.userThreeView addSubview:aoneimage];
                        }];
                        weakSelf.userThreeImageOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",onepointArr[1],onepointArr[0]]];
                    }else if (state == 1){
                        //加载第二张图片
                        NSArray *twopointArr = [tmpArr[1] componentsSeparatedByString:@","];
                        UIImageView *atwoimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        atwoimage.tag = 101;
                        atwoimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                        [weakSelf  addSubview:atwoimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            atwoimage.frame = CGRectMake(weakSelf.userThreeImageTwo.frame.origin.x, weakSelf.userThreeImageTwo.frame.origin.y, 42, 59);
                            [weakSelf.userThreeView addSubview:atwoimage];
                        }];
                        weakSelf.userThreeImageTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",twopointArr[1],twopointArr[0]]];
                    }else if (state == 2){
                        //加载第三张图片
                        NSArray *threepointArr = [tmpArr[2] componentsSeparatedByString:@","];
                        UIImageView *athreeimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        athreeimage.tag = 101;
                        athreeimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                        [weakSelf  addSubview:athreeimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            athreeimage.frame = CGRectMake(weakSelf.userThreeImageThree.frame.origin.x, weakSelf.userThreeImageThree.frame.origin.y, 42, 59);
                            [weakSelf.userThreeView addSubview:athreeimage];
                        }];
                        weakSelf.userThreeImageThree.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",threepointArr[1],threepointArr[0]]];
                    }else if (state == 3){
                        //加载第四张图片
                        NSArray *fourpointArr = [tmpArr[3] componentsSeparatedByString:@","];
                        UIImageView *afourimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afourimage.tag = 101;
                        afourimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                        [weakSelf  addSubview:afourimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afourimage.frame = CGRectMake(weakSelf.userThreeImageFour.frame.origin.x, weakSelf.userThreeImageFour.frame.origin.y, 42, 59);
                            [weakSelf.userThreeView addSubview:afourimage];
                        }];
                        weakSelf.userThreeImageFour.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fourpointArr[1],fourpointArr[0]]];
                    }else if (state == 4){
                        //加载第五张图片
                        UIImageView *afiveimage = [[UIImageView alloc]initWithFrame:weakSelf.pokerImage.frame];
                        afiveimage.tag = 101;
                        afiveimage.image = [UIImage imageNamed:@"poker"];
                        [weakSelf addSubview:afiveimage];
                        [UIView animateWithDuration:0.5 animations:^{
                            afiveimage.frame = CGRectMake(weakSelf.userThreeImageFive.frame.origin.x, weakSelf.userThreeImageFive.frame.origin.y, 42, 59);
                            [weakSelf.userThreeView addSubview:afiveimage];
                        }];
                        weakSelf.userThreeImageFive.image = [UIImage imageNamed:@"poker"];
                    }else{
                        NSArray *fivepointArr = [tmpArr[4] componentsSeparatedByString:@","];
                        weakSelf.userThreeImageFive.image = [UIImage imageNamed:[NSString stringWithFormat:@"poker%@-%@",fivepointArr[1],fivepointArr[0]]];
                        weakSelf.threepoint.image = [UIImage imageNamed:[NSString stringWithFormat:@"niuniu%@",dic[@"point_sum"]]];
                    }
                }
            }
    } fail:^(NSString *error) {
    }];
    if (self.secondTimer == 0) {
        self.secondTimer = 45;
    }else{
        self.secondTimer --;
    }
}
@end
