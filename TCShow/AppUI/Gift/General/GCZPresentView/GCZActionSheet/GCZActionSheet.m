//
//  IMB_ActionSheet.m
//  InvestChina
//
//  Created by 龚传赞 on 14-4-15.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import "GCZActionSheet.h"
#import <UIKit/UIKit.h>
//#import "IC_ShareCustomView.h"

@interface CMRotatableModalViewController : UIViewController
@property (retain) UIViewController *rootViewController;
@end

@implementation CMRotatableModalViewController
@synthesize rootViewController;
- (void)dealloc {
    self.rootViewController = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == self.rootViewController.interfaceOrientation) {
        return YES;
    } else {
        return NO;
    }
}
@end

@implementation GCZCustomView
- (void)releaseResource
{
}

@end

@interface GCZActionSheet ()
{
    UIWindow *_overlayWindow;
}

@property (nonatomic,retain) UIWindow *mainWindow;
@property (nonatomic, strong)GCZCustomView *shareView;
@property (nonatomic,retain) NSMutableArray *callbacks;

@property(nonatomic,strong) ClickBlock cBlock;
@property(nonatomic,strong) payBlock pay;


@end

@implementation GCZActionSheet
@synthesize mainWindow,shareView;

- (void)dealloc {
    //    self.overlayWindow = nil;
    //    self.mainWindow = nil;
    //    self.callbacks = nil;
}

- (id)initWithCustomView:(GCZCustomView *)view {
    self = [super init];
    if (self) {
        shareView = view;
        NSAssert(shareView, @"视图不能为空");
        
        CGFloat ration = view.frame.size.height/view.frame.size.width;
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        CGFloat h = w*ration; // view.bounds.size.height;//
        shareView.frame = CGRectMake(0, 0, w, h);
        
        __weak __typeof(self) weakSelf = self;
        shareView.cBlock = ^(id sender, Gift *g, NSUInteger num) {
//            if (tag >= 3) {
//                [weakSelf dismissWithClickedButtonIndex:tag animated:YES];
//            }
            if (weakSelf.cBlock) {
                weakSelf.cBlock(sender, g, num);
            }
        };
        shareView.pyBlock = ^(){
            if (weakSelf.pay) {
                weakSelf.pay();
            }
        };
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.windowLevel = UIWindowLevelStatusBar+0.1;
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.backgroundColor = [UIColor colorWithWhite:0. alpha:0.f];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDismissModel)];
        [_overlayWindow addGestureRecognizer:tapGestureRecognizer];
        _overlayWindow.hidden = YES;
        
    }
    return self;
}
-(void)pay:(payBlock)pay
{
    _pay = pay;
}


- (void)present:(ClickBlock)block {
    
    _cBlock = block;
    
    self.mainWindow = [UIApplication sharedApplication].keyWindow;
    CMRotatableModalViewController *viewController = [[CMRotatableModalViewController alloc] init];
    viewController.rootViewController = mainWindow.rootViewController;
    
    // Build action sheet view构建动作标示图
    UIView* actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width, shareView.frame.size.height)] ;
    actionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [viewController.view addSubview:actionSheet];
    
    // Add background
    self.shareView.frame = CGRectMake(0, 0, actionSheet.frame.size.width, actionSheet.frame.size.height );
    [actionSheet addSubview:self.shareView];
    
    // Present window and action sheet当前窗口和操作表
    _overlayWindow.rootViewController = viewController;
    //_overlayWindow.alpha = 0.0f;
    _overlayWindow.hidden = NO;
    [_overlayWindow makeKeyWindow];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
//        _overlayWindow.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        CGPoint center = actionSheet.center;
        center.y -= (actionSheet.frame.size.height);
        actionSheet.center = center;
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^{
            CGPoint center = actionSheet.center;
            //center.y += 10;
            actionSheet.center = center;
        } completion:^(BOOL finished) {
            // we retain self until with dismiss action sheet
        }];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated {
    
    // Hide window and action sheet
    UIView *actionSheet = _overlayWindow.rootViewController.view.subviews.lastObject;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //self.overlayWindow.alpha = 0;
        _overlayWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGPoint center = actionSheet.center;
        center.y += (actionSheet.frame.size.height+20);
        actionSheet.center = center;
    } completion:^(BOOL finished) {
        _overlayWindow.hidden = YES;
        [shareView releaseResource];
        _overlayWindow = nil;
        [mainWindow makeKeyWindow];
//        shareView = nil;
        // now we can release self
    }];
}

- (void)touchDismissModel {
    // Hide window and action sheet
    UIView *actionSheet = _overlayWindow.rootViewController.view.subviews.lastObject;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _overlayWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGPoint center = actionSheet.center;
        center.y += actionSheet.frame.size.height;
        actionSheet.center = center;
    } completion:^(BOOL finished) {
        _overlayWindow.hidden = YES;
        [shareView releaseResource];
        _overlayWindow = nil;
        [mainWindow makeKeyWindow];
        // now we can release self
    }];
}

//#pragma mark - 分享点击协议
//
//- (void)shareClickAtIndex:(NSInteger)tag
//{
//    [self dismissWithClickedButtonIndex:tag animated:YES];
//    if (shareView.cBlock) {
//        shareView.cBlock(nil, tag);
//    }
//}

//- (void)cancelClick
//{
//    [self touchDismissModel];
//}

#pragma mark - Override get mehtod
- (UIView *)mainView
{
    return shareView;
}

@end

