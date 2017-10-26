//
//  XDDateView.h
//  Kinglike
//
//  Created by HLKJ on 15/11/8.
//  Copyright (c) 2015年 guowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishSelectDate <NSObject>
-(void)selectDate:(NSString *)date;

@end

typedef void(^clickBtnActionBlock)(NSString *);
@interface XDDateView : UIView

@property (assign)id<finishSelectDate>finishDelegate;
@property(nonatomic,assign)int flag;
@property(nonatomic,copy)NSString *str;//日期
@property(nonatomic,strong)UIDatePicker *datePicker;
+ (instancetype)XDDateView;
@property (nonatomic,copy)void(^clickBtnActionBlock)(NSString *dateStr);

-(void)didSelect:(clickBtnActionBlock)clickBtnActionBlock;
@end
