//
//  LMRankViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMRankViewController.h"
#import "SearchResultController.h"
#import "LMRankHeaderView.h"
#import "LMRankViewCell.h"
#import "LMRankSearchViewController.h"

static NSString *const cxSearchCollectionViewCell = @"CXSearchCollectionViewCell";
static NSString *const headerViewIden = @"HeadViewIden";

@interface LMRankViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

/**
 *  存储网络请求的热搜，与本地缓存的历史搜索model数组
 */
@property (nonatomic, strong) NSMutableArray *hostArray;
/**
 *  存搜索的数组 字典
 */
@property (nonatomic,strong) NSMutableArray *searchArray;
@property(nonatomic,strong)UICollectionView * cxSearchCollectionView;
@property(nonatomic,strong)UITextField * cxSearchTextField;

@end

@implementation LMRankViewController {
    LMRankHeaderView *_headerView;
}

//- (NSMutableArray *)hostArray {
//    if (_hostArray == nil) {
//        _hostArray = [NSMutableArray array];
//    }
//    return _hostArray;
//}
//
//-(NSMutableArray *)searchArray
//{
//    if (_searchArray == nil) {
//        _searchArray = [NSMutableArray array];
//    }
//    return _searchArray;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.hostArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.size = CGSizeMake(48, 30);
    cancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:LEMON_MAINCOLOR forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 85, 30)];
    searchView.userInteractionEnabled = YES;
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView cornerViewWithRadius:5];
    
    _cxSearchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchView.width, 30)];
    _cxSearchTextField.delegate = self;
    _cxSearchTextField.placeholder = @"爱笑的萌萌";
    _cxSearchTextField.returnKeyType = UIReturnKeySearch;
    _cxSearchTextField.font = [UIFont systemFontOfSize:15];
    _cxSearchTextField.tintColor = LEMON_MAINCOLOR;
    [searchView addSubview:_cxSearchTextField];
    
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:searchView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cxSearchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    self.cxSearchCollectionView.showsHorizontalScrollIndicator = NO;
    self.cxSearchCollectionView.showsVerticalScrollIndicator = NO;
    self.cxSearchCollectionView.backgroundColor = [UIColor clearColor];
    [self.cxSearchCollectionView setAllowsMultipleSelection:YES];
    self.cxSearchCollectionView.delegate = self;
    self.cxSearchCollectionView.dataSource = self;
    [self.cxSearchCollectionView registerClass:[LMRankHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.cxSearchCollectionView registerClass:[LMRankViewCell class] forCellWithReuseIdentifier:@"LMRankViewCell"];
    [self.view addSubview:self.cxSearchCollectionView];

    [self prepareData];
    
}


- (void)prepareData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:LIVE_SEARCH_RECOMMEND parameters:@{@"uid":[SARUserInfo userId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *data = responseObject[@"data"];
            _hostArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data];
            [self.cxSearchCollectionView reloadData];
            hud.hidden = YES;
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            hud.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
        hud.hidden = YES;
    }];
    
    [manager GET:LIVE_SEARCH_HOTLIST parameters:@{@"uid":[SARUserInfo userId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *data = responseObject[@"data"];
            _searchArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data];
            [self.cxSearchCollectionView reloadData];
            hud.hidden = YES;
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
            hud.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
        hud.hidden = YES;
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _hostArray.count;
    }
    return _searchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    LMRankViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMRankViewCell" forIndexPath:indexPath];
    TCShowLiveListItem *item;
    if (indexPath.section == 0) {
        item = _hostArray[indexPath.row];
    }else {
        item = _searchArray[indexPath.row];
    }
    [cell refreshView:item index:indexPath.row section:indexPath.section];
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = (LMRankHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
        _headerView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            [_headerView setText:@"主播推荐"];
            [_headerView setImage:@"lemon_dian"];
            _headerView.delectButton.hidden = NO;
            __weak typeof(self) weakself = self;
            _headerView.btnClick = ^{
                [weakself prepareData];
            };
        }else {
            [_headerView setText:@"热搜榜单"];
            [_headerView setImage:@"lemon_dian"];
            _headerView.delectButton.hidden = YES;
        }
        reusableView = _headerView;
    }
    return reusableView;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TCShowLiveListItem *item = _hostArray[indexPath.row];
        return [self getSizeWithText:item.host.username];
    }else {
        CGFloat W = (SCREEN_WIDTH-3*15)/2;
        return  CGSizeMake(W, 40);
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(SCREEN_WIDTH, 44);
}

- (CGSize)getSizeWithText:(NSString*)text;
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+ 5, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    TCShowLiveListItem *item;
    if (indexPath.section == 0) {
        item = _hostArray[indexPath.row];
    }else {
        item = _searchArray[indexPath.row];
    }
    id<TCShowLiveRoomAble> itemA = item;
    IMAHost *host = [IMAPlatform sharedInstance].host;
    TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:itemA user:host];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

//#pragma mark - SelectCollectionCellDelegate
//- (void)selectButttonClick:(CXSearchCollectionViewCell *)cell;
//{
//    NSIndexPath* indexPath = [self.cxSearchCollectionView indexPathForCell:cell];
//    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
//    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
//    _cxSearchTextField.text = contentModel.name;
//    [_cxSearchTextField resignFirstResponder];
//    if (![self.searchArray containsObject:[NSDictionary dictionaryWithObject:_cxSearchTextField.text forKey:@"name"]]) {
//        [self reloadData:_cxSearchTextField.text];
//        
//        //            _cxSearchTextField.text = @"";
//    }
//    //
//    //    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您该去搜索 %@ 的相关内容了",contentModel.name] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了！", nil];
//    //    [al show];
//}


#pragma mark - UICollectionReusableViewButtonDelegate
//- (void)delectData:(SelectCollectionReusableView *)view;
//{
//    
//}

- (void)loadHotData {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cxSearchTextField becomeFirstResponder];
    self.tabBarController.tabBar.hidden = YES;
//    self.childViewControllerForStatusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_cxSearchTextField resignFirstResponder];
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.cxSearchTextField resignFirstResponder];
}

#pragma mark --------textDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_cxSearchTextField.text.length>0) {
        
        [self searchForTitle:_cxSearchTextField.text];
        self.cxSearchTextField.text = @"";
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_cxSearchTextField resignFirstResponder];
    return YES;
}



#pragma mark ----搜索数据
-(void)searchForTitle:(NSString *)title{
    LMRankSearchViewController * search = [[LMRankSearchViewController alloc]init];
    search.titleStr = title;
    [self.navigationController pushViewController:search animated:YES];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)cancelClick {
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
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
