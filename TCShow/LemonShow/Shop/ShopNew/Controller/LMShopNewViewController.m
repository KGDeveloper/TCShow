//
//  LMShopNewViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopNewViewController.h"
#import "LMShopNewViewCell.h"
#import "GoodsDeailController.h"
#import "LMShopModel.h"

@interface LMShopNewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LMShopNewViewController {
    UILabel *_noDataLabel;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoFooter *_footer;
    NSInteger _pageIndex;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 15;// 垂直方向的间距
        layout.minimumLineSpacing = 15; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [SARUserInfo userId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    
    [mgr POST:NEW_GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            NSArray *dataA = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:arr];
            for (LMShopModel *item in dataA) {
                [_dataArray addObject:item];
            }

            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
        [self.collectionView.footer endRefreshing];
        
    }];

//        [[Business sharedInstance] getNewLives:[NSString stringWithFormat:@"%ld", _pageIndex] uid:[SARUserInfo userId] isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
//            NSArray *dataA = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
//            for (TCShowLiveListItem *item in dataA) {
//                [_dataArray addObject:item];
//            }
//            hud.hidden = YES;
//
//            [self.collectionView reloadData];
//            [self.collectionView.footer endRefreshing];
//        } fail:^(NSString *errorList) {
//            hud.labelText = errorList;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                hud.hidden = YES;
//                [self.collectionView.footer endRefreshing];
//            });
//        }];
    
}

-(void)loadData{
    _pageIndex = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [SARUserInfo userId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    
    [mgr POST:NEW_GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            _dataArray = [LMShopModel mj_objectArrayWithKeyValuesArray:arr];
            
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [self.collectionView.header endRefreshing];
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    [self.collectionView registerClass:[LMShopNewViewCell class] forCellWithReuseIdentifier:@"LMShopNewViewCell"];
    //    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    [self.view addSubview:self.collectionView];
    [self setUpRefresh];
}

#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (SCREEN_WIDTH-3*15)/2;
    return  CGSizeMake(W, W+50);
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
    LMShopNewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMShopNewViewCell" forIndexPath:indexPath];
    LMShopModel *model = _dataArray[indexPath.row];
    [cell refreshUI:model];
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
    LMShopModel *model = _dataArray[indexPath.row];
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id  =   model.goods_id ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
