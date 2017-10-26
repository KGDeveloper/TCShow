//
//  XXFeedbackTableViewCell.m
//  TCShow
//
//  Created by tangtianshi on 17/1/8.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "XXFeedbackTableViewCell.h"

@implementation XXFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.feedbackTextView.text = @"请留下您宝贵的建议，感谢您的支持";
 
    // Initialization code
    self.feedbackTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
        
    self.feedbackTextView.text = @"";
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        
        self.feedbackTextView.text = @"请留下您宝贵的建议，感谢您的支持";
    }
    return YES;
}

//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate returnTextViewString:textView.text click:self];
}

@end
