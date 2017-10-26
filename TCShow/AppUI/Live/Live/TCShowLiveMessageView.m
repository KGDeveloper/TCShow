//
//  TCShowLiveMessageView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveMessageView.h"

@interface TCShowLiveMsgTableViewCell : UITableViewCell
{
    UIView                  *_msgBack;
    UILabel                 *_msgLabel;
    UIImageView            *levelImage;
    UILabel                 *levelLabel;
    
    __weak TCShowLiveMsg    *_msgItem;
}

- (void)config:(TCShowLiveMsg *)item;

- (void)configfirst:(NSString *)str;

@end

//===============这里是展示聊天信息的=====================


@implementation TCShowLiveMsgTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = kClearColor;
        
        _msgBack = [[UIView alloc] init];
        _msgBack.backgroundColor = kClearColor;
        [self.contentView addSubview:_msgBack];
        
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.backgroundColor = kClearColor;
        _msgLabel.numberOfLines = 0;
        _msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _msgLabel.userInteractionEnabled = YES;
        [_msgBack addSubview:_msgLabel];
        
        levelImage = [[UIImageView alloc]init];
        levelImage.backgroundColor = [UIColor clearColor];
        
        [_msgBack addSubview:levelImage];
        
        levelLabel = [[UILabel alloc]init];
        levelLabel.textColor = [UIColor whiteColor];
        levelLabel.font = [UIFont systemFontOfSize:10];
        levelLabel.backgroundColor = kClearColor;
        
        [_msgBack addSubview:levelLabel];
        
        _msgBack.layer.cornerRadius = 12;
        _msgBack.layer.masksToBounds = NO;
    }
    return self;
}


- (void)prepareForReuse
{
    _msgLabel.attributedText = nil;
}


//在这里显示聊天信息
- (void)config:(TCShowLiveMsg *)item
{
    _msgItem = item;
    _msgBack.backgroundColor = kClearColor;
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[item phone] forKey:@"phone"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:LIVE_GRADE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *tmpdic = responseObject[@"data"];
            if ([responseObject[@"message"] isEqualToString:@"fail"]) {
                
            }else{
                NSString *firstStr = [NSString stringWithFormat:@"%@",[item avimMsgRichText]];
                if ([[[firstStr componentsSeparatedByString:@"："] firstObject] isEqualToString:@"系统通知"]) {
                    _msgLabel.attributedText = [item avimMsgRichText];
                }else{
                    if ([item.phone isEqualToString:@"1332523251"]){
                        
                    }else{
                        _msgLabel.attributedText = [item avimMsgRichText];
                        levelLabel.text =tmpdic[@"grade"];
                        [levelImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(tmpdic[@"img"])]];
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
}

- (void)configfirst:(NSString *)str {
    _msgLabel.backgroundColor = kClearColor;
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    [attriString addAttribute:NSForegroundColorAttributeName value:kWhiteColor range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 138, 2, 1.0) range:NSMakeRange(4, str.length - 4)];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(5, str.length - 5)];
    _msgLabel.attributedText = attriString;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect frame = self.contentView.frame;
    frame.size.width *= 0.7;
    CGSize size = _msgItem.avimMsgShowSize;
    
    CGRect rect = frame;
    rect.size.height = frame.size.height - 6;
    rect.size.width = size.width + 4 * kDefaultMargin;
    rect.origin.x += kDefaultMargin;
    _msgBack.frame = rect;
    [_msgBack layoutParentVerticalCenter];
    
    
    rect = _msgBack.bounds;
    
    levelImage.frame = CGRectMake(0, 9, 28, 10);
    levelLabel.frame = CGRectMake(15, 9, 5, 10);
    _msgLabel.frame = CGRectInset(rect, kDefaultMargin, 0);
    
    
    
}

@end


//===========================================

@interface TCShowLiveMessageView ()
{
    BOOL _isScrolling;
}

@end

@implementation TCShowLiveMessageView


#define kMaxMsgCount 20

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
//        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
//        v.backgroundColor = [UIColor redColor];
//        _tableView.tableHeaderView = v;
        
        [self addSubview:_tableView];
        
        _liveMessages = [[NSMutableArray alloc] init];
//        [_liveMessages setArray:@[@"直播消息:我们提倡绿色直播,封面和直播内容含吸烟、低俗、引诱、暴露等都将会被封停账号,同时禁止直播聚众闹事、集会,网警24小时在线巡查哦!",@"直播消息:2131231"]];
    }
    return self;
}

#if kSupportIMMsgCache
#define kScrollLiveMessageTableView 0
#else
// 为1时，消息不能正常显示
#define kScrollLiveMessageTableView 0
#endif


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_tableView.contentSize.height > 210)
    {
        _tableView.frame = CGRectMake(0, self.bounds.size.height - 210, self.bounds.size.width, 210);
#if kScrollLiveMessageTableView
#else
        _tableView.contentOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height);
#endif
    }
    else
    {
        if (_tableView.frame.size.height == 0)
        {
            _tableView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0);
        }
        else
        {
            [_tableView alignParentBottom];
        }
    }
}

// 主要是上线消息
- (void)insertOnlineFrom:(id<IMUserAble>)user
{
    [self insertText:@"进来了" from:user isMsg:NO];
}
- (void)insertText:(NSString *)message from:(id<IMUserAble>)user
{
    _msgCount++;
    [self insertText:message from:user isMsg:YES];
}


#define kTableViewMaxHeigh 250




- (void)updateTableViewFrame:(CGFloat)heigt offsert:(CGFloat)scrolloff
{
#if kScrollLiveMessageTableView
    if (_liveMessages.count)
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_liveMessages.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
#else
    CGRect rect = _tableView.frame;
    rect.origin.y -= heigt;
    
    // 显示从(0,0.2, 0.7,1)的位置
    if (rect.size.height + heigt >= kTableViewMaxHeigh)
    {
        _tableView.frame = CGRectMake(0, self.bounds.size.height - kTableViewMaxHeigh, self.bounds.size.width, kTableViewMaxHeigh);
        
        CGPoint off = _tableView.contentOffset;
        off.y += scrolloff;
        _tableView.contentOffset = off;
    }
    else
    {
        rect.size.height += heigt;
        _tableView.frame = rect;
    }
#endif
}

- (void)insertMsg:(id<AVIMMsgAble>)item{
    
    _msgCount++;
    
    if (_isPureMode)
    {
        @synchronized(_liveMessages)
        {
            if (_liveMessages.count >= kMaxMsgCount)
            {
                [_liveMessages removeObjectAtIndex:0];
            }
            [_liveMessages addObject:item];
        }
    }
    else
    {
        @synchronized(_liveMessages)
        {
            CGFloat scrolloff = 0;
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                TCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
                scrolloff -= [TCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
                [_liveMessages removeObjectAtIndex:0];
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
            [_liveMessages addObject:item];
            
            [_tableView endUpdates];
            
            CGFloat heigt = [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
            scrolloff += heigt;
            
            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
    
}
- (void)insertText:(NSString *)message from:(id<IMUserAble>)user isMsg:(BOOL)isMsg{
    
    if (!message.length)
    {
        // 空消息不发送
        return;
    }
    
    TCShowLiveMsg *item = [[TCShowLiveMsg alloc] initWith:user message:message];
    item.isMsg = isMsg;
    
    
    if (_isPureMode)
    {
        @synchronized(_liveMessages)
        {
            if (_liveMessages.count >= kMaxMsgCount)
            {
                [_liveMessages removeObjectAtIndex:0];
            }
            
            [_liveMessages addObject:item];
        }

    }
    else
    {
        @synchronized(_liveMessages)
        {
            CGFloat scrolloff = 0;
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                TCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
                scrolloff -= [TCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
                [_liveMessages removeObjectAtIndex:0];
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
            [_liveMessages addObject:item];
            
            [_tableView endUpdates];
            
            CGFloat heigt = [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
            scrolloff += heigt;
            
            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
}

// 延迟显示
- (void)insertCachedMsg:(AVIMCache *)msgCache
{
    NSInteger msgCacheCount = [msgCache count];
    if (msgCacheCount == 0) {
        return;
    }
    _msgCount += msgCacheCount;
    if (_isPureMode){
        NSMutableArray *items = [NSMutableArray array];
        while (msgCache.count > 0){
            TCShowLiveMsg *item = [msgCache deCache];
            if (item){
                if ([item.phone isEqualToString:@"1332523251"]) {
                    NSString *firstStr = [NSString stringWithFormat:@"%@",[item avimMsgRichText]];
                    NSArray *tmpArr1 = [firstStr componentsSeparatedByString:@","];
                    NSArray *tmpArr2 = [(NSString *)[[tmpArr1[0] componentsSeparatedByString:@"礼物刷屏："] lastObject]
                                        componentsSeparatedByString:@":"];
                    NSArray *tmpArr3 = [(NSString *)tmpArr1[2] componentsSeparatedByString:@":"];
                    NSArray *tmpArr4 = [firstStr componentsSeparatedByString:@"["];
                    NSArray *tmpArr5 = [tmpArr4[1] componentsSeparatedByString:@"]"];
                    NSString *room_id = [[tmpArr3 lastObject] stringByReplacingOccurrencesOfString:@"""" withString:@""];
                    if ([tmpArr2[1] integerValue] == 1) {
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERMANAYUSED" object:nil userInfo:@{@"message":[item avimMsgRichText]}]];
                    }else if ([tmpArr2[1] integerValue] == 2){
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERSENDGIFT" object:nil userInfo:@{@"message":[item avimMsgRichText],@"room_id":room_id,@"data":tmpArr5[0]}]];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERCHANGERMANAY" object:nil userInfo:@{@"message":[item avimMsgRichText]}]];
                    }
                }else{
                    [items addObject:item];
                }
            }
        }
        @synchronized(_liveMessages){
            if (_liveMessages.count + items.count > kMaxMsgCount){
                NSInteger count = _liveMessages.count + items.count - kMaxMsgCount;
                NSInteger i = 0;
                while (count > 0 && _liveMessages.count){
                    [_liveMessages removeObjectAtIndex:0];
                    i++;
                    count--;
                }
            }
            for (NSInteger i = 0; i < items.count; i++){
                [_liveMessages addObject:items[i]];
            }
        }
    }else{
        CGFloat heigt = 0;
        NSMutableArray *items = [NSMutableArray array];
        while (msgCache.count > 0){
            TCShowLiveMsg *item = [msgCache deCache];
            if (item){
                if ([item.phone isEqualToString:@"1332523251"]) {
                    NSString *firstStr = [NSString stringWithFormat:@"%@",[item avimMsgRichText]];
                    NSArray *tmpArr1 = [firstStr componentsSeparatedByString:@","];
                    NSArray *tmpArr2 = [(NSString *)[[tmpArr1[0] componentsSeparatedByString:@"礼物刷屏："] lastObject]
                                        componentsSeparatedByString:@":"];
                    NSArray *tmpArr3 = [(NSString *)tmpArr1[2] componentsSeparatedByString:@":"];
                    NSArray *tmpArr4 = [firstStr componentsSeparatedByString:@"["];
                    NSArray *tmpArr5 = [tmpArr4[1] componentsSeparatedByString:@"]"];
                    NSString *room_id = [[tmpArr3 lastObject] stringByReplacingOccurrencesOfString:@"""" withString:@""];
                    if ([tmpArr2[1] integerValue] == 1) {
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERMANAYUSED" object:nil userInfo:@{@"message":[item avimMsgRichText]}]];
                    }else if ([tmpArr2[1] integerValue] == 2){
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERSENDGIFT" object:nil userInfo:@{@"message":[item avimMsgRichText],@"room_id":room_id,@"data":tmpArr5[0]}]];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"USERCHANGERMANAY" object:nil userInfo:@{@"message":[item avimMsgRichText]}]];
                    }
                }else{
                    [items addObject:item];
                    heigt += [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
                }
            }
        }
        @synchronized(_liveMessages){
            CGFloat scrolloff = 0;
            if (_liveMessages.count + items.count > kMaxMsgCount){
                NSMutableArray *idxs = [NSMutableArray array];
                NSInteger count = _liveMessages.count + items.count - kMaxMsgCount;
                NSInteger i = 0;
                while (count > 0 && _liveMessages.count){
                    TCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
                    scrolloff -= [TCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
                    [_liveMessages removeObjectAtIndex:0];
                    [idxs addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    i++;
                    count--;
                }
                if (idxs.count){
                    [_tableView beginUpdates];
                    [_tableView deleteRowsAtIndexPaths:idxs withRowAnimation:UITableViewRowAnimationTop];
                    [_tableView endUpdates];
                }
            }
            [_tableView beginUpdates];
            NSInteger count = _liveMessages.count;
            NSMutableArray *idxs = [NSMutableArray array];
            for (NSInteger i = 0; i < items.count; i++){
                [_liveMessages addObject:items[i]];
                NSIndexPath *index = [NSIndexPath indexPathForRow:i+count inSection:0];
                [idxs addObject:index];
            }
            [_tableView insertRowsAtIndexPaths:idxs withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView endUpdates];
            scrolloff += heigt;
            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liveMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCShowLiveMsg *item = [_liveMessages objectAtIndex:indexPath.row];
  return [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCShowLiveMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShowLiveMsgTableViewCell"];
    if (!cell)
    {
        cell = [[TCShowLiveMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCShowLiveMsgTableViewCell"];
    }
    
    TCShowLiveMsg *item = [_liveMessages objectAtIndex:indexPath.row];
    [cell config:item];
    return cell;
}

- (void)changeToMode:(BOOL)pure
{
    _isPureMode = pure;
    if (!_isPureMode)
    {
        [_tableView reloadData];
    }
}

@end

