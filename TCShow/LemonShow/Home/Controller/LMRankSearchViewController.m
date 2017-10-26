//
//  LMRankSearchViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMRankSearchViewController.h"
#import "LMHomeLikeViewCell.h"

@interface LMRankSearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LMRankSearchViewController {
    UILabel *_noDataLabel;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 15;// 垂直方向的间距
        layout.minimumLineSpacing = 15; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    //    self.childViewControllerForStatusBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[LMHomeLikeViewCell class] forCellWithReuseIdentifier:@"LMHomeLikeViewCell"];
    //    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTCELL"];
    [self.view addSubview:self.collectionView];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, kSCREEN_WIDTH, 40)];
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:23];
    _noDataLabel.text = @"暂无直播";
    _noDataLabel.hidden = NO;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_noDataLabel];
    [self loadData];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    //    _headerView.dataArray = @[@"", @""];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:LIVE_SEARCH_HOSTLIST parameters:@{@"search":self.titleStr,@"uid":[SARUserInfo userId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *data = responseObject[@"data"];
            _dataArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data];
            if(_dataArray.count == 0){
                _noDataLabel.hidden = NO;
            }else{
                _noDataLabel.hidden = YES;
            }
            [self.collectionView reloadData];
            hud.hidden = YES;
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            hud.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
        hud.hidden = YES;
    }];
//    [[Business sharedInstance] getFollowLives:[NSString stringWithFormat:@"%ld", _pageIndex] uid:[SARUserInfo userId] isConcernLives:NO type:@"1" succ:^(NSString *msg, id dataList) {
//        _dataArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:dataList];
//        hud.hidden = YES;
//        if(_dataArray.count == 0){
//            _noDataLabel.hidden = NO;
//        }else{
//            _noDataLabel.hidden = YES;
//        }
//        [self.collectionView reloadData];
//        [self.collectionView.header endRefreshing];
//    } fail:^(NSString *errorList) {
//        hud.labelText = errorList;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            hud.hidden = YES;
//            [self.collectionView.header endRefreshing];
//        });
//        if(_dataArray.count == 0){
//            _noDataLabel.hidden = NO;
//        }else{
//            _noDataLabel.hidden = YES;
//        }
//    }];
}

#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = SCREEN_WIDTH - 30;
    return  CGSizeMake(W, W*1.14);
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
    LMHomeLikeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHomeLikeViewCell" forIndexPath:indexPath];
    //    cell.contentView.backgroundColor = [UIColor redColor];
    TCShowLiveListItem *item = _dataArray[indexPath.row];
    [cell refreshUI:item];
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
    id<TCShowLiveRoomAble> item = _dataArray[indexPath.row];
    
    // 进入直播间
    //    id<TCShowLiveRoomAble> item = _dataArr[indexPath.row];
    IMAHost *host = [IMAPlatform sharedInstance].host;
    //    [host asyncProfile];
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
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
