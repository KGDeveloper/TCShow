//
//  LMMineView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/14.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMMineView.h"

@implementation LMMineView {
    UIView *_backTopV;
    UIImageView *_iconImageV;
    UILabel *_nameLab;
    UILabel *_phoneLab;
    UILabel *_fansLab;//粉丝
    UILabel *_likeLab;//关注
    UILabel *_charmLab;//魅力值
    UILabel *_coinsLab;//柠檬币
    UILabel *levelLab;//等级
    UIScrollView *_backScrollV;
    UIImageView *LeveImage;//等级图标
    NSString *leveString;
    UILabel *jifenLab;
    UILabel *guanFangQQ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[SARUserInfo userPhone] forKey:@"phone"];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        [manger POST:LIVE_GRADE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSInteger code = [responseObject[@"code"] integerValue];
            
            if (code == 0) {
                
                 [self createUI];
                
                NSDictionary *dc = responseObject[@"data"];
                
                levelLab.text = [NSString stringWithFormat:@"LV%@",dc[@"grade"]];
                
               
                
            }
            
            
            //            NSString *url = [NSString stringWithFormat:@"%@%@",URL_ENTRY,dc[@"img"]];
            //            [LeveImage sd_setImageWithURL:[NSURL URLWithString:url]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
    }
    return self;
}



- (void)createUI {
    
    _backScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _backScrollV.contentSize = CGSizeMake(SCREEN_WIDTH, 630);
    _backScrollV.showsVerticalScrollIndicator = NO;
    _backScrollV.showsHorizontalScrollIndicator = NO;
    _backScrollV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backScrollV];
    
    _backTopV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    _backTopV.backgroundColor = LEMON_MAINCOLOR;
    [_backScrollV addSubview:_backTopV];
    
    _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, 30, 80, 80)];
    _iconImageV.image = [UIImage imageNamed:@"zanwu"];
    _iconImageV.layer.cornerRadius = 40;
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.userInteractionEnabled = YES;
    [_backScrollV addSubview:_iconImageV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_iconImageV addGestureRecognizer:tap];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, SCREEN_WIDTH - 30, 30)];
    _nameLab.text = @"三四五八";
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    [_backScrollV addSubview:_nameLab];
    
    _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, SCREEN_WIDTH - 30, 30)];
    _phoneLab.text = @"13513318438";
    _phoneLab.textColor = [UIColor grayColor];
    _phoneLab.font = [UIFont systemFontOfSize:14];
    _phoneLab.textAlignment = NSTextAlignmentCenter;
    [_backScrollV addSubview:_phoneLab];
    
    UIView *V1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH / 3, 70)];
    V1.backgroundColor = [UIColor whiteColor];
    [_backScrollV addSubview:V1];
    
    UIView *V2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 200, SCREEN_WIDTH / 3, 70)];
    V2.backgroundColor = [UIColor whiteColor];
    [_backScrollV addSubview:V2];
    
    UIView *V3 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, 200, SCREEN_WIDTH / 3, 70)];
    V3.backgroundColor = [UIColor whiteColor];
    [_backScrollV addSubview:V3];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [V1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    [V2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3:)];
    [V3 addGestureRecognizer:tap3];
    
    _fansLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 30)];
    _fansLab.textAlignment = NSTextAlignmentCenter;
    _fansLab.textColor = [UIColor lightGrayColor];
    _fansLab.font = [UIFont systemFontOfSize:14];
    _fansLab.text = @"0";
    [V1 addSubview:_fansLab];
    
    UILabel *diamondsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH / 3, 30)];
    diamondsLab.textAlignment = NSTextAlignmentCenter;
    diamondsLab.textColor = [UIColor grayColor];
    diamondsLab.font = [UIFont systemFontOfSize:14];
    diamondsLab.text = @"粉丝";
    [V1 addSubview:diamondsLab];
    
    _likeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 30)];
    _likeLab.textAlignment = NSTextAlignmentCenter;
    _likeLab.textColor = [UIColor lightGrayColor];
    _likeLab.font = [UIFont systemFontOfSize:14];
    _likeLab.text = @"0";
    [V2 addSubview:_likeLab];
    
    UILabel *lemonsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH / 3, 30)];
    lemonsLab.textAlignment = NSTextAlignmentCenter;
    lemonsLab.textColor = [UIColor grayColor];
    lemonsLab.font = [UIFont systemFontOfSize:14];
    lemonsLab.text = @"关注";
    [V2 addSubview:lemonsLab];
    
    _charmLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 30)];
    _charmLab.textAlignment = NSTextAlignmentCenter;
    _charmLab.textColor = [UIColor lightGrayColor];
    _charmLab.font = [UIFont systemFontOfSize:14];
    _charmLab.text = @"0";
    [V3 addSubview:_charmLab];
    
    UILabel *charmLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH / 3, 30)];
    charmLab.textAlignment = NSTextAlignmentCenter;
    charmLab.textColor = [UIColor grayColor];
    charmLab.font = [UIFont systemFontOfSize:14];
    charmLab.text = @"柠檬币";
    [V3 addSubview:charmLab];
    
    NSArray *imgArr = @[@"lemon_dengji", @"lemon_chongzhi", @"integral",@"lemon_dianpu", @"lemon_guanfang", @"lemon_jianyi"];
    NSArray *titleArr = @[@"我的等级", @"钻石充值",@"积分兑换", @"我的店铺", @"官方QQ", @"给点建议"];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, 10)];
    lineV.backgroundColor = RGB(217, 217, 217);
    [_backScrollV addSubview:lineV];
    
    [self addOrderView];
    
    
    for (int i = 0; i < titleArr.count; i++) {
        UIView *listV = [self createListWith:imgArr[i] title:titleArr[i]];
        listV.frame = CGRectMake(0, i * 44 + 380, SCREEN_WIDTH, 44);
        listV.tag = i + 4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4:)];
        [listV addGestureRecognizer:tap];
        [_backScrollV addSubview:listV];
        if (i < 4 && i > 0) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28, 12, 20, 20)];
            imgV.image = [UIImage imageNamed:@"lemon_youjiantou"];
            imgV.userInteractionEnabled = YES;
            [listV addSubview:imgV];
        }
        if (i == 4) {
            UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 12, 150, 20)];
            titLab.textAlignment = NSTextAlignmentRight;
            titLab.textColor = [UIColor lightGrayColor];
            titLab.font = [UIFont systemFontOfSize:12];
            titLab.text = @"2778998008";
            [listV addSubview:titLab];
        }
        if (i == 1) {
            _coinsLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 12, 160, 20)];
            _coinsLab.textAlignment = NSTextAlignmentRight;
            _coinsLab.textColor = [UIColor lightGrayColor];
            _coinsLab.font = [UIFont systemFontOfSize:14];
            _coinsLab.text = @"150钻石";
            [listV addSubview:_coinsLab];
        }
        if (i == 2) {
            jifenLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 12, 160, 20)];
            jifenLab.textAlignment = NSTextAlignmentRight;
            jifenLab.textColor = [UIColor lightGrayColor];
            jifenLab.font = [UIFont systemFontOfSize:14];
            jifenLab.text = @"150积分";
            [listV addSubview:jifenLab];
        }
        if (i == 0) {
            
            levelLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 12, 160, 20)];
            levelLab.textAlignment = NSTextAlignmentRight;
            levelLab.textColor = [UIColor lightGrayColor];
            levelLab.font = [UIFont systemFontOfSize:14];
//            levelLab.text = [NSString stringWithFormat:@"LV%@",leveString];
            
            
            
             [listV addSubview:levelLab];
            
            
//            LeveImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 175, 12, 160, 20)];
//            LeveImage.backgroundColor = [UIColor clearColor];
//            [listV addSubview:LeveImage];
           
        }
    }
    
}

- (void)addOrderView {
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 100)];
    orderView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, 99.5, SCREEN_WIDTH - 15, 0.5)];
    lineV.backgroundColor = RGB(217, 217, 217);
    [orderView addSubview:lineV];
    
    UIView *listV = [self createListWith:@"mine_order" title:@"我的订单"];
    listV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [orderView addSubview:listV];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28, 12, 20, 20)];
    imgV.image = [UIImage imageNamed:@"lemon_youjiantou"];
    imgV.userInteractionEnabled = YES;
    [listV addSubview:imgV];
    
    UIButton * allBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 12, 160, 20)];
    allBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [allBtn setTitle:@"查看全部订单" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    allBtn.tag = 0;
    [allBtn addTarget:self action:@selector(oderClick:) forControlEvents:UIControlEventTouchUpInside];
    [listV addSubview:allBtn];
    
    //mine_drawback
    NSArray *titArr = @[@"待付款", @"待收货", @"待评价", @"退款/售后"];
    NSArray *imageArr = @[@"待付款", @"待收货", @"待评价", @"mine_drawback"];
    
    for (int i = 0; i < titArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (SCREEN_WIDTH / 4), 47, SCREEN_WIDTH / 4, 50)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i + 1;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 25, 0)];
        [btn addTarget:self action:@selector(oderClick:) forControlEvents:UIControlEventTouchUpInside];
        [orderView addSubview:btn];
    }
    
    [_backScrollV addSubview:orderView];
}

- (void)oderClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.orderClickBlock) {
        switch (btn.tag) {
            case 0:
            {
                self.orderClickBlock(0);
            }
                break;
            case 1:
            {
                self.orderClickBlock(1);
            }
                break;
            case 2:
            {
                self.orderClickBlock(3);
            }
                break;
            case 3:
            {
                self.orderClickBlock(4);
            }
                break;
            case 4:
            {
                self.orderClickBlock(5);
            }
                break;
            case 5:
            {
                self.orderClickBlock(6);
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (UIView *)createListWith:(NSString *)imageStr title:(NSString *)title  {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    backV.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    imgV.image = [UIImage imageNamed:imageStr];
    imgV.userInteractionEnabled = YES;
    [backV addSubview:imgV];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 200, 20)];
    titLab.textAlignment = NSTextAlignmentLeft;
    titLab.textColor = [UIColor grayColor];
    titLab.font = [UIFont systemFontOfSize:14];
    titLab.text = title;
    [backV addSubview:titLab];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, SCREEN_WIDTH - 15, 0.5)];
    lineV.backgroundColor = RGB(217, 217, 217);
    [backV addSubview:lineV];
    
    return backV;
}

- (void)tap:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (void)tap1:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)tap2:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(2);
    }
}

- (void)tap3:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(3);
    }
}

- (void)tap4:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.clickBlock) {
        self.clickBlock(tap.view.tag);
    }
}

- (void)refreshView:(id)responseObject {
    
    [[Business sharedInstance] getMyIntegral:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
        jifenLab.text = [NSString stringWithFormat:@"%@积分",data[@"integral"]];
        
        NSString *imgStr = responseObject[@"data"][@"headsmall"];
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_iconImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"default_head"]];
        _nameLab.text = responseObject[@"data"][@"nickname"];
        _phoneLab.text = [NSString stringWithFormat:@"柠檬号:%@",responseObject[@"data"][@"uid"]];
        _fansLab.text = responseObject[@"data"][@"fans_num"];
        _likeLab.text = responseObject[@"data"][@"follow_num"];
        _charmLab.text = responseObject[@"data"][@"charm"];
        _coinsLab.text = [NSString stringWithFormat:@"%@钻石", responseObject[@"data"][@"diamonds_coins"]];
        
    } fail:^(NSString *error) {
        
        
    }];
    
    
    
    
    
}

@end
