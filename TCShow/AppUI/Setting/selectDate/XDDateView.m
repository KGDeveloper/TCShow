//
//  XDDateView.m
//  Kinglike
//
//  Created by HLKJ on 15/11/8.
//  Copyright (c) 2015年 guowen. All rights reserved.
//

#import "XDDateView.h"
#import "Masonry.h"
@implementation XDDateView{
    UIView *_subView;
   
}

+ (instancetype)XDDateView{
    XDDateView * alert = [XDDateView new];
    
    UIWindow * window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:alert];
    alert.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(window.mas_width);
        make.height.equalTo(window.mas_height);
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
    }];
    [alert setSubview];
 
    return alert;
}

-(void)setSubview{

    _subView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 220)];
    _subView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    [self addSubview:_subView];
    _subView.layer.cornerRadius = 3.0;
    _subView.layer.masksToBounds = YES;

    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    [_subView addSubview:toolbar];
    UIButton *cancelBtn = [[UIButton alloc]init];
    [toolbar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 87, 64) forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar.mas_centerY);
        make.left.equalTo(toolbar.mas_left).offset(15);
        make.height.equalTo(@(30));
    }];
    [cancelBtn addTarget:self action:@selector(hidenAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [toolbar addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:RGB(255, 87, 64) forState:UIControlStateNormal];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar.mas_centerY);
        make.right.equalTo(toolbar.mas_right).offset(-15);
        make.height.equalTo(@(30));
    }];
    [confirmBtn addTarget:self action:@selector(boundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, 180)];
    [_subView addSubview:_datePicker];
    _datePicker.backgroundColor = RGB(219, 219, 219);
//    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_subView.mas_left);
//        make.right.equalTo(_subView.mas_right);
//        make.top.equalTo(toolbar.mas_bottom);
//        make.height.equalTo(@(200));
//    }];
    // 设置显示样式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    //设置最大最小显示时间
//    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceReferenceDate:3600 * 365 *24 * 10];
//    
     _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //显示默认的时间
    //    self.datePicker.countDownDuration = 60 * 60;
    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//    [_datePicker setDate:date animated:YES];
    
    [_datePicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
    [self datePickerClick:self.datePicker];
    [self showAlertView];
    
}

- (void)datePickerClick:(UIDatePicker *)datePicker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:datePicker.date];
    self.str = str;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
   
//               NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
//               NSLocale *local = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//               [inputFormatter setLocale:local] ;
//    
//               [inputFormatter setDateFormat:@"yyyyMMdd"];
//    
//               NSDate*inputDate = [inputFormatter dateFromString:str];
//    
//    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init] ;
//    
//    [outputFormatter setLocale:[NSLocale currentLocale]];
//    
//    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *strr= [outputFormatter stringFromDate:inputDate];
//               self.str =  strr;
     NSDictionary *dict3 =[[NSDictionary alloc] initWithObjectsAndKeys:str ,@"textOne",nil];
//    NSDictionary *dict4 =[[NSDictionary alloc] initWithObjectsAndKeys:str ,@"textTwo",nil];
//    if (_flag == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhi3" object:nil userInfo:dict3];
//    }
    
    
}
-(void)didSelect:(clickBtnActionBlock)clickBtnActionBlock{
    
    if (clickBtnActionBlock) {
        self.clickBtnActionBlock = clickBtnActionBlock;
    }
}
//取消按钮
-(void)btnClick:(UIButton *)sender{
//    if (self.clickBtnActionBlock) {
//        self.clickBtnActionBlock(NO);
//        [self hidenAlertView];
//    }else{
        [self hidenAlertView];
        
//    }
    
}


//确定按钮
-(void)boundBtnClick{
    if (self.clickBtnActionBlock) {
        self.clickBtnActionBlock(self.str);
        [self hidenAlertView];
    }else{
        [self hidenAlertView];
        if ([_finishDelegate respondsToSelector:@selector(selectDate:)]) {
            
            [_finishDelegate selectDate:self.str];
        }
    }
}

- (void)showAlertView {
    _subView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [UIView animateWithDuration:0.2 animations:^{
            _subView.frame = CGRectMake(0, kSCREEN_HEIGHT - 220, kSCREEN_WIDTH, 220);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
//        _subView.alpha = 1;
    } completion:^(BOOL finished) {
        _subView.alpha = 1;
    }];
}

- (void)hidenAlertView {
    __weak __typeof(self) wself = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        _subView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 220);
        wself.alpha = 0.6;
    } completion:^(BOOL finished) {
        wself.alpha = 0;
        [wself removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_subView.frame, point)) {
        [self hidenAlertView];
    }
    
}

@end
