//
//  MessageCell.m
//  直播Test
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


/**
 **
 **显示用户发表言论的cell
 **
 **/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        [self addSubview:self.bgView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.messageLabel];
        
        self.userHearImage = [[UIImageView alloc]init];
        self.userHearImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.userHearImage];
        
        self.gradeLabel = [[UILabel alloc]init];
        self.gradeLabel.text = @"10";
        [self addSubview:self.gradeLabel];
        
      
        }

    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.bgView.frame = CGRectMake(0, 2.5,self.model.cellwidth , self.model.cellheight-5);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    self.messageLabel.frame = CGRectMake(20, 2.5, self.frame.size.width - 10, self.model.cellheight - 5);
    self.userHearImage.frame = CGRectMake(5, 2.5, 15, self.model.cellheight - 5);
    self.gradeLabel.frame = CGRectMake(12, 2.5, 3, self.model.cellheight - 5);
}

@end
