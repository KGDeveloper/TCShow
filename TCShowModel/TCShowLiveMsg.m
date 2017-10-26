//
//  TCShowLiveMsg.m
//  TCShow
//
//  Created by AlexiChen on 16/4/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveMsg.h"

@implementation TCShowLiveMsg

- (instancetype)init
{
    if (self = [super init])
    {
        _nameColor = kRandomFlatColor;
    }
    return self;
}

- (instancetype)initWith:(id<IMUserAble>)user message:(NSString *)message
{
    if (self = [self init])
    {
        _sender = user;
        _msgText = message;
        _phone = [_sender imUserId];
    }
    return self;
}

// 普通文样样式
- (NSString *)avimMsgText
{
    return [NSString stringWithFormat:@"      %@：%@", [_sender imUserName], _msgText];;
}

// 在界面中显示富文本样式
- (NSAttributedString *)avimMsgRichText
{
    if (!_avimMsgRichText)
    {
        NSString *userName = [self.sender imUserName];
        NSString *info = [self avimMsgText];
        UIFont *font = [UIFont systemFontOfSize:13];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:info];
        [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, userName.length)];
        [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 138, 2, 1.0) range:NSMakeRange(0, userName.length+1)];
        [attriString addAttribute:NSForegroundColorAttributeName value:kWhiteColor range:NSMakeRange(userName.length+1, info.length - userName.length-1)];
        [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(userName.length+1, info.length - userName.length-1)];
        if (self.imageName) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = [UIImage imageNamed:self.imageName];
            attach.bounds = CGRectMake(0, 0, 15, 10);
            NSAttributedString *AattachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attriString  appendAttributedString:AattachString];
        }
        _avimMsgRichText = attriString;
    }
    
    return _avimMsgRichText;
}

// 在界面中显示的大小

// 在渲染前，先计算渲染的内容
- (void)prepareForRender
{
    // do nothing
    [TCShowLiveMsg defaultShowHeightOf:self inSize:CGSizeMake(kMainScreenWidth * 0.7, HUGE_VALF)];
}

+ (UIFont *)defaultFont
{
    return kAppMiddleTextFont;
}

+ (CGSize)defaultShowSizeOf:(TCShowLiveMsg *)item inSize:(CGSize)size
{
    
    if (item.avimMsgShowSize.width != 0)
    {
        return item.avimMsgShowSize;
    }
    
    size.width -= 4*kDefaultMargin;
    CGSize contentSize = [item.avimMsgRichText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    item.avimMsgShowSize = contentSize;
    return contentSize;
}

+ (CGFloat)defaultShowHeightOf:(TCShowLiveMsg *)item inSize:(CGSize)size
{
    CGSize contentSize = [TCShowLiveMsg defaultShowSizeOf:item inSize:size];
    return 3 + (contentSize.height < 24 ? 24 : contentSize.height + 8) + 3;
}

@end
