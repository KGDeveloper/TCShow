//
//  CollectionHeadView.m
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CollectionHeadView.h"
#import "SDCycleScrollView.h"
#import "TCHomeImageModel.h"
#import "LMHomeMainTopViewCell.h"
#import "MJExtension.h"
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface CollectionHeadView ()<SDCycleScrollViewDelegate>{
    NSMutableArray *imgData;// 轮播图图片
    UILabel *_noDataLabel;
}
@end

@implementation CollectionHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray array];
        [self concentrationGoods];
        [self createUI];
    }
    return self;
}


-(void)concentrationGoods{
    
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 140) delegate:self placeholderImage:IMAGE(@"003")];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:cycleScrollView];
    [[Business sharedInstance] homeCarouselSucc:^(NSString *msg, id data) {
        NSMutableArray *imgAry = [NSMutableArray array];
        imgData = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
        for (NSDictionary *dic in imgData) {
            NSString *imgurl = [dic objectForKey:@"img"];
            [imgAry addObject:IMG_APPEND_PREFIX(imgurl)];
        }
        cycleScrollView.imageURLStringsGroup = imgAry;
    } fail:^(NSString *error) {
        
    }];
    
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 15;// 垂直方向的间距
        layout.minimumLineSpacing = 15; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 174, SCREEN_WIDTH, 144) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
    }
    return _collectionView;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        [_collectionView reloadData];
        if (_dataArray.count == 0) {
            _noDataLabel.hidden = NO;
        }else {
            _noDataLabel.hidden = YES;
        }
    }
}

- (void)createUI {
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 155, 20, 20)];
    imageV.image = [UIImage imageNamed:@"lemon_dian"];
    [self addSubview:imageV];
    
    UILabel *mainLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 200, 30)];
    mainLab.textColor = [UIColor blackColor];
    mainLab.textAlignment = NSTextAlignmentLeft;
    mainLab.text = @"柠檬主推";
    mainLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:mainLab];
    
    [self.collectionView registerClass:[LMHomeMainTopViewCell class] forCellWithReuseIdentifier:@"LMHomeMainTopViewCell"];
    //    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    [self addSubview:self.collectionView];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 194, kSCREEN_WIDTH, 40)];
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:22];
    _noDataLabel.text = @"暂无主推";
    _noDataLabel.hidden = NO;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noDataLabel];
    
    UIView *grayV = [[UIView alloc] initWithFrame:CGRectMake(0, 315, SCREEN_WIDTH, 10)];
    grayV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:grayV];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 330, 20, 20)];
    imageV1.image = [UIImage imageNamed:@"lemon_dian"];
    [self addSubview:imageV1];
    
    UILabel *mainLab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 325, 200, 30)];
    mainLab1.textColor = [UIColor blackColor];
    mainLab1.textAlignment = NSTextAlignmentLeft;
    mainLab1.text = @"星秀主播";
    mainLab1.font = [UIFont systemFontOfSize:15];
    [self addSubview:mainLab1];
    
}

#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (SCREEN_WIDTH-4*15)/3;
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
    LMHomeMainTopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHomeMainTopViewCell" forIndexPath:indexPath];
    TCShowLiveListItem *item = _dataArray[indexPath.row];
    [cell refreshUI:item index:indexPath.row];
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
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
    //    id<TCShowLiveRoomAble> item = _dataArr[indexPath.row];
    //    IMAHost *host = [IMAPlatform sharedInstance].host;
    //    //    [host asyncProfile];
    //    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:host];
    //    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

#pragma mark -- 轮播图点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    SAMessageWebViewController *webView = [[SAMessageWebViewController alloc] init];
//    webView.title = [[imgData objectAtIndex:index] objectForKey:@"title"];
//    webView.webUrl = [[imgData objectAtIndex:index] objectForKey:@"url"];
//    webView.hidesBottomBarWhenPushed = YES;
//    [self pushTo:webView];
}
@end
