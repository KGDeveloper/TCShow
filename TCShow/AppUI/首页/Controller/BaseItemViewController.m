

//
//  BaseItemViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "BaseItemViewController.h"
#import "CollectionDataSource.h"
#import "CollectionHeadView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "TCHomeImageModel.h"
#import <PgyUpdate/PgyUpdateManager.h>

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface BaseItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CollectionDataSource * _collectionDataSource;
    MJRefreshNormalHeader *_header;
    UILabel * _noDataLabel;
}

@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation BaseItemViewController

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [_collectionView reloadData];
    [self setUpRefresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(typeIndex:) name:@"HOMETYPECHANGE" object:nil];
    

}

-(void)updateMethodwithUrl:(NSString *)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}



#pragma mark -----当前控制器的通知
- (void)typeIndex:(NSNotification*)noti{
    
    
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.collectionView.header beginRefreshing];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] getLives:nil uid:[SARUserInfo userId]  isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
        _dataArr = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
        hud.hidden = YES;
        if(_dataArr.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } fail:^(NSString *errorList) {
        hud.labelText = errorList;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [self.collectionView.header endRefreshing];
        });
        if(_dataArr.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
    }];
}


#pragma mark -------------createUI
-(void)createUI{
    _collectionDataSource = [[CollectionDataSource alloc]initWithItems:_dataArr cellIdentifier:@"HOMECOLLECTCELL" myCell:_homeCell configureCellBlock:^(id cell, id item) {
//        [cell configureForCloadDataollection:item];
    }];

    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
     flowLayout.headerReferenceSize = CGSizeMake(WIDTH, 194);
    _collectionView = [[MyCollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT - 163) collectionViewLayout:flowLayout];
    [_collectionView setAllowsMultipleSelection:YES];
    _collectionView.pagingEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (HEIGHT + 81)/2.0 - 20, kSCREEN_WIDTH, 40)];
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:23];
    _noDataLabel.text = @"暂无直播";
    _noDataLabel.hidden = YES;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    [_collectionView addSubview:_noDataLabel];
    
}

#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (collectionView.frame.size.width-3*15)/2;
    return  CGSizeMake(W, W*0.87);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


#pragma mark -------dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HOMECOLLECTCELL" forIndexPath:indexPath];

    id<TCShowLiveRoomAble> room = _dataArr[indexPath.row];
    
    [_homeCell configWith:room];
    return _homeCell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeadView *headerView = (CollectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
        [headerView.sectioniew sd_setImageWithURL:[NSURL URLWithString:self.sectionImagePath] placeholderImage:IMAGE(@"hot")];
        headerView.titleLabel.text = self.sectionTitle;
        headerView.backgroundColor = [UIColor whiteColor];
        reusableView = headerView;
    }
    return reusableView;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 进入直播间
    id<TCShowLiveRoomAble> item = _dataArr[indexPath.row];
    IMAHost *host = [IMAPlatform sharedInstance].host;
//    [host asyncProfile];
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
