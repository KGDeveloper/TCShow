//
//  LMStoreOpenViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/26.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMStoreOpenViewController.h"

@interface LMStoreOpenViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LMStoreOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"开店须知";
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"UserOpenStoreProtocol" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
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
