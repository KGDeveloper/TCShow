//
//  GCZPresentMenu.m
//  PresentDemo
//
//  Created by gongcz on 16/5/27.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "GCZPresentMenu.h"

@interface GCZPresentMenu ()
{
    UIButton *lastSelectedBtn_;
    NSTimer *timer_;
}
@property (nonatomic, strong) NSMutableArray *infoArr;

@end

@implementation GCZPresentMenu

- (void)dealloc
{
//    if (timer_.isValid) {
//        [self resetZero];
//    }
    [self resetZero];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (void)awakeFromNib
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"gift" ofType:@"plist"];
    
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];

    _infoArr = [NSMutableArray arrayWithArray:data];
    
    [self configView];
    
    
    [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    _sendBtn.enabled = YES;
    _continueBtn.hidden = YES;
}

- (void)configView
{
    
    [self.scrollView setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width * 2, 0)];
    [self.scrollView setPagingEnabled:YES];
    CGFloat w = [[UIScreen mainScreen]bounds].size.width/2;

    for (int i = 0; i < 16; i ++) {
        NSDictionary *dic = _infoArr[i];
        UIButton *btn = [self createBtn:dic[@"p"] imgName:dic[@"i"] tag:i+1];
        CGFloat x = (i%8)%4;
        CGFloat y = (i%8)/4 == 0? 0: w;
        NSInteger page = i/8;
        btn.frame = CGRectMake(x*w +page*[[UIScreen mainScreen]bounds].size.width, y, w, w);
        btn.tag = i+1;
        [self.scrollView addSubview:btn];
        // 连发
        if (btn.tag < 4) {
            CGFloat lblW = 13;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(w-lblW-1.5, 1, lblW, lblW)];
            lbl.text = @"连";
            lbl.textColor = [UIColor lightGrayColor];
            lbl.font = [UIFont systemFontOfSize:9];
            lbl.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:lbl];
            
            lbl.layer.borderWidth = 1;
            lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
            lbl.layer.cornerRadius = 2.f;
            lbl.clipsToBounds = YES;
        }
        if (i==21) {
            
        }
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
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    
    if (!_continueBtn.hidden) {
        if (btn.tag != lastSelectedBtn_.tag) {
            [self resetZero];
        }
    }
    [_sendBtn setBackgroundColor:[UIColor colorWithRed:0.32 green:0.78 blue:0.81 alpha:1.00]];
    _sendBtn.enabled = YES;
    lastSelectedBtn_.selected = NO;
    btn.selected = YES;
    lastSelectedBtn_ = btn;
}

#pragma mark - Private method
static NSInteger seconds = 30;
- (void)updateTitle
{
    
    seconds--;
    _continueBtn.titleLabel.numberOfLines = 2;
    NSString *btnTitle = [NSString stringWithFormat:@"%ld",(long)seconds];
    [_continueBtn setTitle:btnTitle forState:UIControlStateNormal];
    if (seconds <= 0) {
        [self resetZero];
    }
}

static NSUInteger num = 0;
- (void)resetZero
{
    
    num = 0;
    _continueBtn.hidden = YES;
    [_continueBtn setTitle:@"30" forState:UIControlStateNormal];
    _sendBtn.hidden = NO;
    [timer_ invalidate];
}

#pragma mark - IBAction method

// 连发
//- (IBAction)continueClick:(id)sender {
//    _sendBtn.hidden = YES;
//    _continueBtn.hidden = NO;
//    if (!timer_.isValid) {
//        seconds = 30;
//        [self updateTitle];
//        timer_ = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
//    }
//    num ++;
//    self.cBlock(_infoArr[lastSelectedBtn_.tag-1], lastSelectedBtn_.tag-1, num);
//}
//
//
//- (IBAction)sendClick:(id)sender {
//    if (self.cBlock) {
//        if (!lastSelectedBtn_) {
//            
//        }else{
//            self.cBlock(_infoArr[lastSelectedBtn_.tag-1], lastSelectedBtn_.tag);
//            if (lastSelectedBtn_.tag < 4) {
//                [self continueClick:nil];
//            }else{
//                self.cBlock(_infoArr[lastSelectedBtn_.tag-1], lastSelectedBtn_.tag-1, 1);
//            }
//        }
//    }
//}

#pragma mark - Override get method
- (NSUInteger)selectedType
{
    return lastSelectedBtn_.tag-1;
}

- (void)releaseResource
{
    [self resetZero];
}

@end
