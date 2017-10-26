//
//  TCGuideViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/7/28.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCGuideViewController.h"

@interface TCGuideViewController ()

@end

@implementation TCGuideViewController {
    UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    NSArray * imgArr = @[@"Guide_1", @"Guide_2", @"Guide_3"];
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgV.image = [UIImage imageNamed:imgArr[i]];
        imgV.userInteractionEnabled = YES;
        [_scrollView addSubview:imgV];
        if (i == 2) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 90) / 2, SCREEN_HEIGHT - 60, 90, 30)];
            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn];
        }
    }
    
    [self.view addSubview:_scrollView];
}

- (void)btnClick:(id)sender {
    self.inBtnClickBlock();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
