//
//  TCShowLiveInputView.m
//  TCShow
//
//  Created by AlexiChen on 15/11/16.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "TCShowLiveInputView.h"

@implementation TCShowLiveInputView
//============================这里是发送聊天信息的====================================
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)text{
    return _textField.text;
}

- (void)setText:(NSString *)text{
    _textField.text = text;
}

- (void)setPlacehoholder:(NSString *)placeholder{
    if (!placeholder || placeholder.length == 0){
        _textField.placeholder = nil;
        return;
    }
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:kWhiteColor}];
}

- (void)addOwnViews{
//    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    self.backgroundColor = [UIColor clearColor];
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"和大家说点什么呢？";
    _textField.textColor = kBlackColor;
    _textField.font = kAppMiddleTextFont;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    [_textField cornerViewWithRadius:5];
    _textField.backgroundColor = [kWhiteColor colorWithAlphaComponent:1.0];
    [self addSubview:_textField];
    
    

    _confirmButton = [[MenuButton alloc] init];
    [_confirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
    _confirmButton.backgroundColor = RGBA(251, 86, 89, 1.0);
    [_confirmButton cornerViewWithRadius:5];
//    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"btn_sendbg"] forState:UIControlStateNormal];
    [self addSubview:_confirmButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isInputViewActive = NO;
    [textField resignFirstResponder];
    [_confirmButton onClick:self];
    textField.text = nil;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isInputViewActive = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isInputViewActive = YES;
}

- (void)textFieldDidBeginEditing
{
    _isInputViewActive = YES;
}


- (void)setLimitLength:(NSInteger)limitLength
{
    if (limitLength > 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    }
    _limitLength = limitLength;
}

// 监听字符变化，并处理
- (void)onTextFiledEditChanged:(NSNotification *)obj
{
    if (_limitLength > 0)
    {
        UITextField *textField = _textField;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > _limitLength)
            {
                [textField shake];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limitLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:_limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limitLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (void)relayoutFrameOfSubViews
{
    [_confirmButton sizeWith:CGSizeMake(44, 30)];
    [_confirmButton layoutParentVerticalCenter];
    [_confirmButton alignParentRightWithMargin:kDefaultMargin];
    
    [_textField sameWith:_confirmButton];
    [_textField layoutToLeftOf:_confirmButton margin:kDefaultMargin];
    [_textField scaleToParentLeftWithMargin:kDefaultMargin];
}

- (void)addSendAction:(MenuAction)sendAction
{
    [_confirmButton setClickAction:sendAction];
    [_confirmButton addTarget:self action:@selector(onClickSend) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickSend
{
    _textField.text = nil;
}

- (BOOL)isInputViewActive
{
    return _isInputViewActive;
//    return _textField.isFirstResponder;
}

- (BOOL)resignFirstResponder
{
    _isInputViewActive = NO;
//    [super resignFirstResponder];
    return [_textField resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
//    [super becomeFirstResponder];
    _isInputViewActive = YES;
    return [_textField becomeFirstResponder];
}

@end
