//
//  PrivacyController.m
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "PrivacyController.h"
#import "MBProgressHUD.h"
@interface PrivacyController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation PrivacyController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewTitle;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.frame.size.height - 64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    NSString *url;
    if ([self.viewTitle isEqualToString:@"隐私"]) {
        
        url = [INTRODUCTIONS_TEXT stringByAppendingString:@"type=1"];
    }else if([self.viewTitle isEqualToString:@"用户协议"]){
        url = [INTRODUCTIONS_TEXT stringByAppendingString:@"type=3"];
    }else{
        url = [INTRODUCTIONS_TEXT stringByAppendingString:@"type=2"];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_hud show:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud hide:YES];
}


@end
