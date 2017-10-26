//
//  TCShowLiveTopView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveTopView.h"
#import "TCLiveUserList.h"
#import "MJExtension.h"
static NSString * isFollow;
static BOOL isOneself;
@implementation TCShowLiveTimeView{
    TCLiveUserList *_user;
}

- (instancetype)initWith:(TCShowLiveListItem *)room
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _room = room;
        isOneself = [self isHost];
        isFollow = [_room liveIsFollow];
        
//        [self addOwnViews];
        [self addOwnView];
        [self configOwnViews];
        self.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.3];
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(followState:) name:@"FOLLOWSTATE" object:nil];
    }
    return self;
}


- (BOOL)isHost
{
    return [[IMAPlatform sharedInstance].host isCurrentLiveHost:_room];
}

//实现收信的方法
- (void)followState:(NSNotification*)noti{
    if ([noti.userInfo[@"is_follows"] integerValue] == 0) {
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        isFollow = @"0";
        _room.is_follow = isFollow;
    }else if ([noti.userInfo[@"is_follows"] integerValue] == 1){
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        isFollow = @"1";
        _room.is_follow = isFollow;
    }
}


//后续修改
-(void)addOwnView{
    _liveHost = [[MenuButton alloc] init];
    _liveHost.layer.cornerRadius = 22;
    _liveHost.layer.masksToBounds = YES;
    [self addSubview:_liveHost];
    
    _liveStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_liveStateButton setImage:IMAGE(@"live_liveState") forState:UIControlStateNormal];
    [self addSubview:_liveStateButton];
    
    _attentionLabel = [UILabel label];
    _attentionLabel.text = @"在线: 0";
    _attentionLabel.textColor = kWhiteColor;
    _attentionLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_attentionLabel];
    
    _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionButton.backgroundColor = kNavBarThemeColor;
    [_attentionButton cornerViewWithRadius:10];
    [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionButton addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
    [_attentionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _attentionButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self addSubview:_attentionButton];
}


#pragma mark ---------是否关注
-(void)attentionClick{
    [[Business sharedInstance] concern:[_room liveHostId] uid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
        if ([msg isEqualToString:@"关注成功"]) {
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            isFollow = @"1";
            _room.is_follow = isFollow;
        }
        [[HUDHelper sharedInstance] tipMessage:msg];
//        if ([data[@"code"] integerValue] == 0) {
//            if ([isFollow integerValue] == 0) {
//                [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
//                isFollow = @"1";
//                _room.is_follow = isFollow;
//            }else if ([isFollow integerValue] == 1){
//                [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
//                isFollow = @"0";
//                _room.is_follow = isFollow;
//            }
//        }else{
//            [[HUDHelper sharedInstance] tipMessage:msg];
//        }
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"取消成功"]) {
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            isFollow = @"0";
            _room.is_follow = isFollow;
        }

        [[HUDHelper sharedInstance] tipMessage:error];
     }];
}


- (void)addOwnViews
{
    _liveHost = [[MenuButton alloc] init];
    _liveHost.layer.cornerRadius = 22;
    _liveHost.layer.masksToBounds = YES;
    [self addSubview:_liveHost];
    
    
    if ([self isHost])
    {
        _liveTime = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
        [_liveTime setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        [_liveTime setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self addSubview:_liveTime];
    }
    else
    {
        _liveTime = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightLeft];
        [_liveTime setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _liveTime.titleLabel.adjustsFontSizeToFitWidth = YES;
        _liveTime.titleLabel.textAlignment = NSTextAlignmentLeft;
        _liveTime.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_liveTime];
    }
    
    _liveAudience = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_liveAudience setImage:[UIImage imageNamed:@"visitor_white"] forState:UIControlStateNormal];
    _liveAudience.titleLabel.adjustsFontSizeToFitWidth = YES;
    _liveAudience.titleLabel.font = kAppSmallTextFont;
    [_liveAudience setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self addSubview:_liveAudience];
    
    _livePraise = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_livePraise setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
    _livePraise.titleLabel.adjustsFontSizeToFitWidth = YES;
    _livePraise.titleLabel.font = kAppSmallTextFont;
    [_livePraise setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self addSubview:_livePraise];
    
}

- (void)onClickHost
{
    
}

- (void)changeRoomInfo:(TCShowLiveListItem *)room
{
    _room = room;
    [self configOwnViews];
}
- (void)configOwnViews
{
    NSString *url = [[_room liveHost] imUserIconUrl];
    if (url.length>0) {
        NSString *imgStr = url;
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_liveHost sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(imgStr)] forState:UIControlStateNormal placeholderImage:kDefaultUserIcon];
    }
    
    
    if ([self isHost])
    {
        NSString *imgStr = [[SARUserInfo gainUserInfo] objectForKey:@"headsmall"];
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [_liveHost sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(imgStr)] forState:UIControlStateNormal placeholderImage:kDefaultUserIcon];
//        [_liveTime setTitle:@"00:00" forState:UIControlStateNormal];
        _attentionButton.hidden = YES;//自己直播界面关注按钮隐藏
        [[Business sharedInstance] getUserInfoByUid:[_room liveHostId] userid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
//            _attentionLabel.text = [NSString stringWithFormat:@"%@关注",data[@"follows"]];
        } fail:^(NSString *error) {
            
        }];
    }
    else
    {
        [_liveTime setTitle:[[_room liveHost] imUserName] forState:UIControlStateNormal];
        
    }
    //关注与取消关注
    if ([isFollow integerValue] == 1) {
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    [_liveAudience setTitle:[NSString stringWithFormat:@"%d", (int)[_room liveAudience]] forState:UIControlStateNormal];
    [_livePraise setTitle:[NSString stringWithFormat:@"%d", (int)[_room livePraise]] forState:UIControlStateNormal];
    if ([_room follow_num] != nil) {
//        _attentionLabel.text = [NSString stringWithFormat:@"%@关注",[_room follow_num]];
    }
}

- (void)relayoutFrameOfSubViews
{
    [_liveHost sizeWith:CGSizeMake(44, 44)];
    [_liveHost layoutParentVerticalCenter];
    [_liveHost alignParentLeftWithMargin:3];
    
    //直播中
    [_liveStateButton sizeWith:CGSizeMake(50, 20)];
    [_liveStateButton alignParentTopWithMargin:5];
    [_liveStateButton alignLeft:_liveHost margin:_liveHost.width + 5.0];
    
    //关注数量
    [_attentionLabel sizeWith:CGSizeMake(50, 20)];
    [_attentionLabel alignParentTopWithMargin:_liveStateButton.height + 5];
    [_attentionLabel alignLeft:_liveHost margin:_liveHost.width + 5.0];
    
    //是否已关注
    [_attentionButton sizeWith:CGSizeMake(50, 20)];
    [_attentionButton layoutParentVerticalCenter];
    [_attentionButton alignLeft:_liveStateButton margin:_liveStateButton.width + 10.0];
    
    [_liveTime sizeWith:CGSizeMake(20, 20)];
    [_liveTime alignTop:_liveHost];
    [_liveTime layoutToRightOf:_liveHost margin:3];
    [_liveTime scaleToParentRightWithMargin:10];
    
    [_liveAudience sizeWith:CGSizeMake(_liveTime.bounds.size.width/2, _liveTime.bounds.size.height)];
    [_liveAudience alignLeft:_liveTime];
    [_liveAudience alignBottom:_liveHost];
    
    [_livePraise sameWith:_liveAudience];
    [_livePraise layoutToRightOf:_liveAudience];
    
    
}

- (void)startLive
{
    [_liveTimer invalidate];
    _liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onLiveTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_liveTimer forMode:NSRunLoopCommonModes];
    
    
}

- (void)onLiveTimer
{
    if ([self isHost])
    {
        
        NSInteger dur = [_room liveDuration] + 1;
        [_room setLiveDuration:dur];
        
        NSString *durStr = nil;
        if (dur > 3600)
        {
            int h = (int)dur/3600;
            int m = (int)(dur - h *3600)/60;
            int s = (int)dur%60;
            durStr = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
        }
        else
        {
            int m = (int)dur/60;
            int s = (int)dur%60;
            durStr = [NSString stringWithFormat:@"%02d:%02d", m, s];
        }
        
        
        [_liveTime setTitle:durStr forState:UIControlStateNormal];
        [_delegate onTimViewTimeRefresh:self];
        
#if kSupportIMMsgCache
#else
        [self onRefrshPraiseAndAudience];
#endif
        
    }
}

#pragma mark --------------实时显示在线人数与点赞通知
- (void)onRefrshPraiseAndAudience{
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"LiveNumberChange" object:nil userInfo:@{@"state":@"1"}]];
    int number = (int)[_room liveAudience] + arc4random()% 25 + 35;
    [_liveAudience setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
    [_livePraise setTitle:[NSString stringWithFormat:@"%d", (int)[_room livePraise]] forState:UIControlStateNormal];
    [self loadDataSource];
}


- (void)pauseLive{
    if ([self isHost]){
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
}


- (void)resumeLive{
    [self startLive];
}


#pragma mark ----------有用户进入直播间
- (void)onImUsersEnterLive:(NSArray *)array{
    [_room setLiveAudience:[_room liveAudience] + array.count];
    [_liveAudience setTitle:[NSString stringWithFormat:@"%d", (int)[_room liveAudience]] forState:UIControlStateNormal];
    [self loadDataSource];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"LiveNumberChange" object:nil userInfo:@{@"state":@"1"}]];
}


#pragma mark ----------有用户离开直播间
- (void)onImUsersExitLive:(NSArray *)array{
    [_room setLiveAudience:[_room liveAudience] - array.count];
    [_liveAudience setTitle:[NSString stringWithFormat:@"%d", (int)[_room liveAudience]] forState:UIControlStateNormal];
    [self loadDataSource];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"LiveNumberChange" object:nil userInfo:@{@"state":@"1"}]];
}

#pragma mark -------请求直播间用户列表
-(void)loadDataSource{
    NSString *roomId = [NSString stringWithFormat:@"%d", [_room avRoomId]];
    __block NSInteger index = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[SARUserInfo userId] forKey:@"uid"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:USER_ROBOT parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [[Business sharedInstance] getUserListByRoom:roomId uid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            NSArray *arr = data[@"data"];
            index = arr.count;
            int number = (int)[_room liveAudience] + arc4random()%25 + 35 + (int)index;
            _attentionLabel.text = [NSString stringWithFormat:@"在线: %d", number];
        }
    } fail:^(NSString *error) {
    }];
}


@end

// timeview

@interface LiveUserViewCell : UICollectionViewCell
{
    UIImageView         *_userIcon;
}

@property (nonatomic, readonly) UIImageView *userIcon;

@end

@implementation LiveUserViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.image = kDefaultUserIcon;
        _userIcon.layer.cornerRadius = 15;
        _userIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:_userIcon];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    _userIcon.frame = CGRectInset(rect, (rect.size.width - 30)/2, (rect.size.height - 30)/2);
}


@end

// TCShowLiveTopView

@implementation TCShowLiveTopView


- (instancetype)initWith:(TCShowLiveListItem *)room
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _room = room;
        _spectatorDataSource = [NSMutableArray array];
//        NSString * str  = [_room ]
        [self addOwnViewsWith:room];
        [self configOwnViewsWith:room];
//        [self loadDataSource];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LiveNumberChange:) name:@"LiveNumberChange" object:nil];
    }
    return self;
}

#pragma mark --------用户进入直播与退出直播
- (void)LiveNumberChange:(NSNotification*)noti{
    if ([noti.userInfo[@"state"] integerValue] == 1) {
        [self loadDataSource];
    }
}


#pragma mark -------请求直播间用户列表
-(void)loadDataSource{
    NSString *roomId = [NSString stringWithFormat:@"%d", [_room avRoomId]];
//    __weak typeof(self) weakself = self;
    
    [[Business sharedInstance] getUserListByRoom:roomId uid:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
//            NSArray *dataArr = data[@"data"][@"lives"];
//            for (int i = 0; i< dataArr.count; i++) {
//                NSDictionary *dic = dataArr[i];
//               TCLiveUserList *user = [[TCLiveUserList alloc]init];
//                user.headsmall = dic[@"headsmall"];
//                user.uid = dic[@"uid"];
//                user.phone = dic[@"phone"];
//                user.nickname = dic[@"nickname"];
//                user.personalized = dic[@"personalized"];
//                [_spectatorDataSource addObject:user];
//            }
            _spectatorDataSource = [TCLiveUserList mj_objectArrayWithKeyValuesArray:data[@"data"][@"lives"] context:nil];
            [_userlist reloadData];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
}


- (void)onImUsersEnterLive:(NSArray *)array
{
    [_timeView onImUsersEnterLive:array];
}
- (void)onImUsersExitLive:(NSArray *)array
{
    [_timeView onImUsersExitLive:array];
}

- (void)onClickClose
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onTopViewCloseLive:)])
    {
        [_delegate onTopViewCloseLive:self];
    }
}

- (void)startLive
{
    [_timeView startLive];
#if kBetaVersion
//    _roomTip.text = [NSString stringWithFormat:@"AV:%d\nIM:%@", [_room liveAVRoomId], [_room liveIMChatRoomId]];
#endif
}
- (void)pauseLive
{
    
    [_timeView pauseLive];
}
- (void)resumeLive
{
    
    [_timeView resumeLive];
}

- (void)onRefrshPraiseAndAudience
{
    [_timeView onRefrshPraiseAndAudience];
}

- (void)onClickHost
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onTopViewClickHost:host:)])
    {
        [_delegate onTopViewClickHost:self host:_room];
    }
}

- (void)addOwnViewsWith:(id<TCShowLiveRoomAble>)room
{
    
    _timeView = [[TCShowLiveTimeView alloc] initWith:room];
    
    if (![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[room liveHost] imUserId]]) {
        __weak TCShowLiveTopView *ws = self;
        
        [_timeView.liveHost setClickAction:^(id<MenuAbleItem> menu) {
#pragma mark ------点击头像弹出主播信息
            [ws onClickHost];
        }];
    }
    
    [self addSubview:_timeView];
    
    _close = [[UIButton alloc] init];
    [_close setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_close addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_close];
    
#if kBetaVersion
    _roomTip = [[UILabel alloc] init];
    _roomTip.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.2];
    _roomTip.textColor = kWhiteColor;
    _roomTip.numberOfLines = 0;
    _roomTip.lineBreakMode = NSLineBreakByWordWrapping;
    _roomTip.adjustsFontSizeToFitWidth = YES;
    _roomTip.font = kAppSmallTextFont;
    [self addSubview:_roomTip];
#endif
    
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        _userlist = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _userlist.backgroundColor = [UIColor clearColor];
        [_userlist registerClass:[LiveUserViewCell class] forCellWithReuseIdentifier:@"LiveUserViewCell"];
        _userlist.delegate = self;
        _userlist.dataSource = self;
        _userlist.showsHorizontalScrollIndicator = NO;
        _userlist.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.3];
        _userlist.backgroundColor = [UIColor clearColor];
        [self addSubview:_userlist];
//    if ([[IMAPlatform sharedInstance].host isCurrentLiveHost:room])
//    {
//        _parView = [[TCShowAVParView alloc] init];
//        _parView.backgroundColor = [UIColor redColor];
//        _parView.delegate = self;
//        _parView.isHostPar = [[[room liveHost] imUserId] isEqualToString:[[IMAPlatform sharedInstance].host imUserId]];
//        [self addSubview:_parView];
//    
//        _parView.hidden = YES;
//    }
}



- (void)relayoutFrameOfSubViews
{
    
    CGRect rect = self.bounds;
    [_timeView sizeWith:CGSizeMake(rect.size.width-24, 50)];
    [_timeView alignParentTopWithMargin:15];
    [_timeView alignParentLeftWithMargin:12];
    [_timeView relayoutFrameOfSubViews];
    
    [_close sizeWith:CGSizeMake(30, 30)];
    [_close alignParentBottomWithMargin:15];
    [_close alignParentRightWithMargin:12];
    
//    rect.origin.y += 15 + 50;
//    rect.size.height -= 15 + 50;
//    rect = CGRectInset(rect, 0, kDefaultMargin);
//    _userlist.frame = rect;
    if (isOneself) {
        [_userlist sizeWith:CGSizeMake(kSCREEN_WIDTH - 144, 50)];
        
    }else{
        [_userlist sizeWith:CGSizeMake(kSCREEN_WIDTH - 194, 50)];
    }
    [_userlist alignParentTopWithMargin:15];
    [_userlist alignParentRightWithMargin:12];

    
#if kBetaVersion
    [_roomTip sameWith:_timeView];
    [_roomTip layoutToRightOf:_timeView margin:kDefaultMargin];
    [_roomTip scaleToLeftOf:_close margin:kDefaultMargin];
#endif
    
    [self relayoutPARView];
    
}

- (void)onAVParView:(TCShowAVParView *)par clickPar:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onTopView:clickPAR:)])
    {
        [_delegate onTopView:self clickPAR:button];
    }
}

- (void)onAVParView:(TCShowAVParView *)par clickPush:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onTopView:clickPush:)])
    {
        [_delegate onTopView:self clickPush:button];
    }
}

- (void)onAVParView:(TCShowAVParView *)par clickRec:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onTopView:clickREC:)])
    {
        [_delegate onTopView:self clickREC:button];
    }
}

- (void)onAVParView:(TCShowAVParView *)par clickSpeed:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onTopView:clickSpeed:)])
    {
        [_delegate onTopView:self clickSpeed:button];
    }
}

- (void)relayoutPARView
{
    if (_parView)
    {
        [_parView sizeWith:CGSizeMake(45, 25)];
        [_parView alignLeft:_timeView];
        [_parView layoutBelow:_timeView margin:kDefaultMargin];
        [_parView scaleToParentRightWithMargin:kDefaultMargin];
        [_parView relayoutFrameOfSubViews];
    }
}

- (void)configOwnViewsWith:(TCShowLiveListItem *)room
{
    
#if kBetaVersion
//    _roomTip.text = [NSString stringWithFormat:@"AV:%d\nIM:%@", [room liveAVRoomId], [room liveIMChatRoomId]];
#endif
}

- (void)onRefrshPARView:(TCAVLiveRoomEngine *)engine
{
    [_parView onRefrshPARView:engine];
}

- (void)changeRoomInfo:(TCShowLiveListItem *)room
{
    _room = room;
    [_timeView changeRoomInfo:room];
    [self configOwnViewsWith:room];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _spectatorDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveUserViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveUserViewCell" forIndexPath:indexPath];
    TCLiveUserList * listModel = _spectatorDataSource[indexPath.row];
    NSString *imgStr = listModel.headsmall;
//    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
//        imgStr = IMG_APPEND_PREFIX(imgStr);
//    }
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:imgStr ] placeholderImage:[UIImage imageNamed:@"defaultUser"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCLiveUserList *userModel = _spectatorDataSource[indexPath.row];
    if (self.userListClickBack) {
        self.userListClickBack(userModel);
    }
}

@end
