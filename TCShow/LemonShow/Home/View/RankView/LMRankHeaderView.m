//
//  LMRankHeaderView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMRankHeaderView.h"

@implementation LMRankHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, (self.frame.size.height - 18.0f / 2), 18, 18)];
        
        [self addSubview:imageView];
        
        self.imageView = imageView;
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(25 +5.0f, (self.frame.size.height - 18.0f / 2), 100.0f, 18)];
        label.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        
        self.textLabel = label;
        
        UIButton *delectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 95 , (self.frame.size.height - 30.0f / 2), 80, 30)];
        [delectButton setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
        [delectButton setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [delectButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [delectButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [delectButton setTitle:@"换一批" forState:UIControlStateNormal];
        
        [delectButton addTarget:self action:@selector(delect) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:delectButton];
        
        _delectButton = delectButton;
    }
    return self;
}

- (void)delect
{
    if (self.btnClick) {
        self.btnClick();
    }
}


- (void) setText:(NSString*)text
{
    self.textLabel.text = text;
}

- (void) setImage:(NSString *)image;
{
    [self.imageView setImage:[UIImage imageNamed:image]];
}


@end
