//
//  XSearchFriendCell.m
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XSearchFriendCell.h"

@implementation XSearchFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headImg = [[UIImageView alloc] init];
        self.headImg.layer.masksToBounds = YES;
        self.headImg.layer.cornerRadius = 22.5;
        
        self.nameL = [[UILabel alloc] init];
        
        self.contentTitleL = [[UILabel alloc] init];
        self.contentTitleL.text = @"个性签名未填写";
        self.contentTitleL.font = [UIFont systemFontOfSize:15];
        self.contentTitleL.textColor = [UIColor grayColor];
        
        
        self.addBtn = [[UIButton alloc] init];
        [self.addBtn setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"添加成功"] forState:UIControlStateSelected];
        [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.headImg];
        [self addSubview:self.nameL];
        [self addSubview:self.contentTitleL];
        [self addSubview:self.addBtn];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.headImg.frame = CGRectMake(12, 7.5, 45, 45);
    self.nameL.frame = CGRectMake(self.headImg.frame.origin.x + self.headImg.frame.size.width + 7.5, 12, self.frame.size.width - 130, 18);
    self.contentTitleL.frame = CGRectMake(self.nameL.frame.origin.x,self.nameL.frame.size.height + self.nameL.frame.origin.y + 6, self.nameL.frame.size.width, 15);
    self.addBtn.frame = CGRectMake(self.frame.size.width - 45, 15, 30, 30);
}

#pragma mark -- 按钮的点击事件
-(void)addBtnClick{
    if (_delegate && [self.delegate respondsToSelector:@selector(addConcernDelegate:)]) {
        [self.delegate addConcernDelegate:self.indexpath];
    }
}

@end
