//
//  AgreementController.m
//  TCShow
//
//  Created by tangtianshi on 16/9/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AgreementController.h"

@interface AgreementController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation AgreementController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
//    self.title = @"直播用户协议";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已阅读" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(black)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"UserProtocol" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}

- (void)onClickDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//-(void)black{
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
