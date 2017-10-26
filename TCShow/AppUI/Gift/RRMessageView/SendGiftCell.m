//
//  SendGiftCell.m
//  直播Test
//
//  Created by admin on 16/5/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SendGiftCell.h"

@implementation SendGiftCell


/**
 **
 **显示用户发表言论的cell
 **
 **/

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
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 15;
        [self addSubview:self.bgView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textColor = [UIColor redColor];
        [self addSubview:self.messageLabel];
        
        self.giftImageView = [[UIImageView alloc] init];
        self.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.giftImageView];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(0, 2.5,self.model.cellwidth + 45, self.model.cellheight - 5);
    self.messageLabel.frame = CGRectMake(5, 2.5, self.frame.size.width - 10, self.model.cellheight - 5);
    self.giftImageView.frame = CGRectMake(self.model.lastPoint.x, self.model.lastPoint.y, 30, 30);
}


@end
