//
//  TCCharmTableViewCell.m
//  TCShow
//
//  Created by 王孟 on 2017/8/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCCharmTableViewCell.h"
#import "TCCharmModel.h"

@implementation TCCharmTableViewCell {
    UILabel *_nameLab;
    UILabel *_charmsLab;
    UILabel *_numsLab;
    UIImageView *_iconImageV;
    UIImageView *_firstImageV;
    UIImageView *_rankImageV;
    UIButton *_followBtn;
    TCCharmModel *_charmM;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLab];
    
    _charmsLab = [[UILabel alloc] init];
    _charmsLab.textColor = [UIColor lightGrayColor];
    _charmsLab.font = [UIFont systemFontOfSize:12];
    _charmsLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_charmsLab];
    
    _numsLab = [[UILabel alloc] init];
    _numsLab.font = [UIFont systemFontOfSize:12];
    _numsLab.textColor = [UIColor blackColor];
    _numsLab.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_numsLab];
    
    _iconImageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageV];
    
    _rankImageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_rankImageV];
    
    _firstImageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_firstImageV];
    
    _followBtn = [[UIButton alloc] init];
    [_followBtn setTitle:@"已关注" forState: UIControlStateNormal];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _followBtn.selected = YES;
    _followBtn.layer.cornerRadius = 4;
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.borderWidth = 1;
    _followBtn.layer.borderColor = LEMON_MAINCOLOR.CGColor;
    _followBtn.backgroundColor = LEMON_MAINCOLOR;
    [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followBtn];
}

- (void)followBtnClick:(id)sender {
    [[Business sharedInstance] concern:_charmM.uid uid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
        if ([msg isEqualToString:@"关注成功"]) {
            [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            _followBtn.backgroundColor = LEMON_MAINCOLOR;
            [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _followBtn.selected = YES;
        }
        [[HUDHelper sharedInstance] tipMessage:msg];
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"取消成功"]) {
            [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
            _followBtn.backgroundColor = [UIColor whiteColor];
            [_followBtn setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
            _followBtn.selected = NO;
        }
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
    
}

- (void)initUIWith:(TCCharmModel *)model index:(NSInteger)index {
    _charmM = model;
    _nameLab.text = model.nickname;
    if (model.charm == nil) {
        _charmsLab.text = [NSString stringWithFormat:@"魅力值: %@", model.lemon_coins_sum];
        _numsLab.text = [NSString stringWithFormat:@"NO.%@", model.mc];
        _followBtn.hidden = YES;
    }else {
        _charmsLab.text = [NSString stringWithFormat:@"魅力值: %@", model.charm];
        _numsLab.text = [NSString stringWithFormat:@"NO.%ld",(long)index + 1];
        _followBtn.hidden = NO;
        if (model.follow == 0) {
            [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
            _followBtn.backgroundColor = [UIColor whiteColor];
            [_followBtn setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
            _followBtn.selected = NO;
        }else {
            [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            _followBtn.backgroundColor = LEMON_MAINCOLOR;
            [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _followBtn.selected = YES;
        }
    }
    
    NSString *imgStr = model.headsmall;
    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
        imgStr = IMG_APPEND_PREFIX(imgStr);
    }
    [_iconImageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"mine_placeholder")];
    
    if (index == 0) {
        _nameLab.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 140, 100, 20);
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _charmsLab.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, 165, 200, 20);
        _charmsLab.textAlignment = NSTextAlignmentCenter;
        _iconImageV.frame = CGRectMake((SCREEN_WIDTH - 70) / 2, 60, 70, 70);
        _iconImageV.layer.cornerRadius = 35;
        _iconImageV.layer.masksToBounds = YES;
        _numsLab.hidden = YES;
        _rankImageV.image = [UIImage imageNamed:@"rank_1"];
        _rankImageV.frame = CGRectMake(10, 85, 30, 30);
        _firstImageV.hidden = NO;
        _firstImageV.image = [UIImage imageNamed:@"rank_top"];
        _firstImageV.frame = CGRectMake((SCREEN_WIDTH - 210) / 2 + 5, 30, 210, 130);
        _followBtn.frame = CGRectMake(SCREEN_WIDTH - 75, 90, 60, 20);
    }else {
        _nameLab.frame = CGRectMake(100, 5, 100, 20);
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _charmsLab.frame = CGRectMake(100, 25, 200, 20);
        _charmsLab.textAlignment = NSTextAlignmentLeft;
        _iconImageV.frame = CGRectMake(50, 5, 40, 40);
        _iconImageV.layer.cornerRadius = 20;
        _iconImageV.layer.masksToBounds = YES;
        _numsLab.hidden = NO;
        _numsLab.frame = CGRectMake(10, 15, 40, 20);
        _firstImageV.hidden = YES;
        _followBtn.frame = CGRectMake(SCREEN_WIDTH - 75, 12, 60, 20);
        if (index == 1) {
            _numsLab.hidden = YES;
            _rankImageV.image = [UIImage imageNamed:@"rank_2"];
            _rankImageV.frame = CGRectMake(10, 10, 30, 30);
        }
        if (index == 2) {
            _numsLab.hidden = YES;
            _rankImageV.image = [UIImage imageNamed:@"rank_3"];
            _rankImageV.frame = CGRectMake(10, 10, 30, 30);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
