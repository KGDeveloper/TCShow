//
//  TCShowUserDetailsView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCShowUserDetailsView.h"

@implementation TCShowUserDetailsView

- (instancetype)initWithUser:(TCShowLiveList *)user {
    if (self = [super initWithFrame:CGRectZero]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    self.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    }];
}

@end
