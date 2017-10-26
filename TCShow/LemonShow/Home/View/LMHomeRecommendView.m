//
//  LMHomeRecommendView.m
//  TCShow
//
//  Created by 王孟 on 2017/8/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMHomeRecommendView.h"
#import "CollectionHeadView.h"
#import "LMRecommendCell.h"

@implementation LMHomeRecommendView {
    UILabel *_noDataLabel;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoFooter *_footer;
    CollectionHeadView *_headerView;
    NSInteger _pageIndex;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
         layout.minimumInteritemSpacing = 15;// 垂直方向的间距
         layout.minimumLineSpacing = 15; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
    }
    return _collectionView;
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.collectionView.header beginRefreshing];
    _footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionView.footer = _footer;
}

- (void)loadMoreData {
    _pageIndex++;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[Business sharedInstance] getLives:[NSString stringWithFormat:@"%ld", (long)_pageIndex] uid:[SARUserInfo userId] isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
        NSArray *dataA = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
        for (TCShowLiveListItem *item in dataA) {
            [_dataArray addObject:item];
        }
        hud.hidden = YES;
        if(_dataArray.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    } fail:^(NSString *errorList) {
        hud.labelText = errorList;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [self.collectionView.footer endRefreshing];
        });
        if(_dataArray.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
    }];

}

-(void)loadData{
//    _headerView.dataArray = @[@"", @""];
    _pageIndex = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[Business sharedInstance] getLives:[NSString stringWithFormat:@"%ld", (long)_pageIndex] uid:[SARUserInfo userId] isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
        _dataArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
        hud.hidden = YES;
        if(_dataArray.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } fail:^(NSString *errorList) {
        hud.labelText = errorList;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [self.collectionView.header endRefreshing];
        });
        if(_dataArray.count == 0){
            _noDataLabel.hidden = NO;
        }else{
            _noDataLabel.hidden = YES;
        }
    }];
    
    [[Business sharedInstance] getMainTopLives:nil uid:[SARUserInfo userId] isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
        _headerView.dataArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
        hud.hidden = YES;
    } fail:^(NSString *errorList) {
        hud.labelText = errorList;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = [NSMutableArray array];
        _pageIndex = 1;
        [self createUI];
        [self setUpRefresh];
    }
    return self;
}

- (void)createUI {
    
//    CollectionHeadView *headView = [[CollectionHeadView alloc] initWithFrame:self.frame];
//    [self addSubview:headView];
    
    [self.collectionView registerClass:[LMRecommendCell class] forCellWithReuseIdentifier:@"LMRecommendCell"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    [self addSubview:self.collectionView];
    [_collectionView registerClass:[CollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, kSCREEN_WIDTH, 40)];
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:23];
    _noDataLabel.text = @"暂无直播";
    _noDataLabel.hidden = NO;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noDataLabel];
    
}

#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (SCREEN_WIDTH-3*15)/2;
    return  CGSizeMake(W, W*1.1);
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
    LMRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMRecommendCell" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor redColor];
    TCShowLiveListItem *item = _dataArray[indexPath.row];
    cell.statesImgV.hidden = YES;
    [cell refreshUI:item];
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = (CollectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
//        [headerView.sectioniew sd_setImageWithURL:[NSURL URLWithString:self.sectionImagePath] placeholderImage:IMAGE(@"hot")];
//        headerView.titleLabel.text = self.sectionTitle;
        _headerView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakself = self;
        _headerView.itemClickBlock = ^(TCShowLiveListItem *item) {
            if (weakself.itemClickBlock) {
                weakself.itemClickBlock(item);
            }
        };
        reusableView = _headerView;
    }
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(SCREEN_WIDTH, 350);
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
    TCShowLiveListItem *item = _dataArray[indexPath.row];
    if (self.itemClickBlock) {
        self.itemClickBlock(item);
    }
    
    IMAHost *host = [IMAPlatform sharedInstance].host;
    //    [host asyncProfile];
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

@end
