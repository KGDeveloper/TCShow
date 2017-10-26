//
//  XXFeedbackDetailViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXFeedbackDetailViewController.h"

@interface XXFeedbackDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *problem;
@property (weak, nonatomic) IBOutlet UILabel *problemContent;

@end

@implementation XXFeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    _problem.text = _dataDic[@"content"];
    _problemContent.text = _dataDic[@"reply_content"];
    
}


@end
