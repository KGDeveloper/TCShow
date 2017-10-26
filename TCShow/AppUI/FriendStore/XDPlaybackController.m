//
//  XDPlaybackController.m
//  咖秀直播
//
//  Created by tangtianshi on 16/4/6.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "XDPlaybackController.h"
#import "XDPlaybackCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "huifangModel.h"
#import "HomeCollectionCell.h"
#import "MJRefresh.h"
@interface XDPlaybackController (){
    MJRefreshNormalHeader *_header;
    UILabel * _noDataLabel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collecView;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@end

@implementation XDPlaybackController
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在直播";
    
    //确定是水平滚动，还是垂直滚动
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, 320, 200) collectionViewLayout:flowLayout];
    
//    self.collectionView.dataSource=self;
//    self.collectionView.delegate=self;
    [self.collecView setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
//    [self.collecView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    [self.collecView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (kSCREEN_HEIGHT-100)/2.0 - 20, kSCREEN_WIDTH, 40)];
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:23];
    _noDataLabel.text = @"暂无直播";
    _noDataLabel.hidden = YES;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.collecView addSubview:_noDataLabel];

    
  //  [self.view addSubview:self.collectionView];
    [self setUpRefresh];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collecView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.collecView.header beginRefreshing];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] friendLivingList:[SARUserInfo userId] type:@"more" succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            hud.hidden = YES;
            _dataSourceArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
        }else{
            hud.labelText = msg;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
        }
        if (_dataSourceArray.count == 0) {
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
        [self.collecView reloadData];
        [self.collecView.header endRefreshing];
    } fail:^(NSString *error) {
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [self.collecView.header endRefreshing];
        });
        if (_dataSourceArray.count == 0) {
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (collectionView.frame.size.width-3*15)/2;
    return  CGSizeMake(W, W*0.87);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"HOMECOLLECTCELL";
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
     TCShowLiveListItem * room = _dataSourceArray[indexPath.row];
    [cell configWith:room];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        return NO;
    }
    // 进入直播间
    TCShowLiveListItem *item = _dataSourceArray[indexPath.row];
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:[IMAPlatform sharedInstance].host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
    return YES;
}


@end
