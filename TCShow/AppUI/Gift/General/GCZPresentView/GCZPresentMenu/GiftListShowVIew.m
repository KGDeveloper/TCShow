//
//  GiftListShowVIew.m
//  TCShow
//
//  Created by wxt on 2017/5/25.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GiftListShowVIew.h"
#import "RechargeViewController.h"
@interface GiftListShowVIew ()
{
    __weak IBOutlet UIScrollView *scroller;
    __weak IBOutlet UIButton *sendBtn;
    UIButton *lastSelectedBtn;
    __weak IBOutlet UILabel *iconLabel;

    
}
@property (nonatomic, strong) NSMutableArray *infoArr;

@end

@implementation GiftListShowVIew
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _infoArr = [NSMutableArray arrayWithArray:[AllGifts AllGifts]];
    [self configView];
    [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    sendBtn.enabled = YES;
    [self getMyLemoNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyLemoNum) name:@"sendGiftSucc" object:nil];
}

/**
 获取钻石
 */
- (void) getMyLemoNum {
    
    [[Business sharedInstance] getMyDiamondsWithParam:@{@"uid":[SARUserInfo userId]} succ:^(NSString *msg, id data) {
        
        [iconLabel setText:[NSString stringWithFormat:@"钻石：%@",data[@"diamonds_coins"]]];
        
    } fail:^(NSString *error) {
        [iconLabel setText:@"钻石：未获取"];
    }];
    
//    [[Business sharedInstance] getMyIconWithParam:@{@"uid":[SARUserInfo userId]} succ:^(NSString *msg, id data) {
//        [iconLabel setText:[NSString stringWithFormat:@"钻石：%@",data[@"charm"]]];
//    } fail:^(NSString *error) {
//        [iconLabel setText:@"钻石：未获取"];
//    }];
}
- (void)configView
{
    [scroller setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width * 2, 0)];
    [scroller setPagingEnabled:YES];
    CGFloat w = [[UIScreen mainScreen]bounds].size.width/4;
    for (int i = 0; i < 16; i ++) {
        Gift *dic = _infoArr[i];
        
        UIButton *btn = [self createBtn:dic.name imgName:dic.imageName tag:i+1];
        CGFloat x = (i%8)%4;
        CGFloat y = (i%8)/4 == 0? 0: w;
        NSInteger page = i/8;
        btn.frame = CGRectMake(x*w +page*[[UIScreen mainScreen]bounds].size.width, y, w, w);
        btn.tag = i+1;
        [scroller addSubview:btn];
    }
}
- (UIButton *)createBtn:(NSString *)title imgName:(NSString *)imgName tag:(NSUInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(55, -40, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 25, 0, 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"矩形-28"] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.borderColor = [[UIColor clearColor] CGColor];
    btn.layer.borderWidth = 1.0f;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)btnClick:(UIButton *)btn
{
    [sendBtn setBackgroundColor:[UIColor colorWithRed:0.32 green:0.78 blue:0.81 alpha:1.00]];
    sendBtn.enabled = YES;
    lastSelectedBtn.selected = NO;
    btn.selected = YES;
    lastSelectedBtn = btn;
}
- (IBAction)sendAction:(UIButton *)sender {
    Gift *dic =  _infoArr[lastSelectedBtn.tag-1];
    
    self.cBlock(_infoArr[lastSelectedBtn.tag-1], dic, 1);
    
}
- (IBAction)showRecharge:(UIButton *)sender {
    if (self.pyBlock) {
        self.pyBlock();
    }
}

+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;   
}


@end
