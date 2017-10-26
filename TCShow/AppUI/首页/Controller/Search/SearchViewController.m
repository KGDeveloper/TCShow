//
//  SearchViewController.m
//  SearchTest
//
//  Created by tangtianshi on 16/10/28.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SearchViewController.h"
#import "CXSearchSectionModel.h"
#import "CXSearchModel.h"
#import "CXSearchCollectionViewCell.h"
#import "SelectCollectionReusableView.h"
#import "SelectCollectionLayout.h"
#import "SearchResultController.h"
//#import "CXDBHandle.h"
#import "JSDropmenuView.h"

#define Screen320Scale SCREEN_WIDTH/320.0f
static NSString *const cxSearchCollectionViewCell = @"CXSearchCollectionViewCell";
static NSString *const headerViewIden = @"HeadViewIden";
@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SelectCollectionCellDelegate,UICollectionReusableViewButtonDelegate,UITextFieldDelegate,JSDropmenuViewDelegate>
/**
 *  存储网络请求的热搜，与本地缓存的历史搜索model数组
 */
@property (nonatomic, strong) NSMutableArray *sectionArray;
/**
 *  存搜索的数组 字典
 */
@property (nonatomic,strong) NSMutableArray *searchArray;
@property(nonatomic,strong)UICollectionView * cxSearchCollectionView;
@property(nonatomic,strong)UITextField * cxSearchTextField;
@property(nonatomic,strong)UIButton * typeButton;
@property(nonatomic,strong)NSArray *menuArray;
@end

@implementation SearchViewController

-(NSMutableArray *)sectionArray
{
    if (_sectionArray == nil) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

-(NSMutableArray *)searchArray
{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = RGBA(244, 243, 251, 1.0);
    [self prepareData];
    self.menuArray = @[@{@"imageName":@"search_goods",@"title":@"商品"},@{@"imageName":@"search_store",@"title":@"店铺"}];
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.size = CGSizeMake(48, 30);
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
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(0, 0, 45, 30);
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_typeButton setTitle:@"宝贝" forState:UIControlStateNormal];
    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    [_typeButton setImage:IMAGE(@"home_search_down") forState:UIControlStateNormal];
    [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_typeButton.imageView.width, 0, _typeButton.imageView.width)];
    [_typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, _typeButton.titleLabel.width, 0, -_typeButton.titleLabel.width)];
    [searchView addSubview:_typeButton];
    _cxSearchTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, 0, searchView.width - 45, 30)];
    _cxSearchTextField.delegate = self;
    _cxSearchTextField.placeholder = @"连衣裙 内衣";
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
    [self.cxSearchCollectionView setCollectionViewLayout:[[SelectCollectionLayout alloc] init] animated:YES];
    [self.cxSearchCollectionView registerClass:[SelectCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden];
    [self.cxSearchCollectionView registerNib:[UINib nibWithNibName:@"CXSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cxSearchCollectionViewCell];
    [self.view addSubview:self.cxSearchCollectionView];
    /***  可以做实时搜索*/
    //    [self.cxSearchTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}




#pragma mark ------取消按钮
-(void)cancelClick{
//    self.navigationController.navigationBar.barTintColor = kNavBarThemeColor;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareData
{
    /**
     *  测试数据 ，字段暂时 只用一个 titleString，后续可以根据需求 相应加入新的字段
     */
    [[Business sharedInstance] homeHotSearchSucc:^(NSString *msg, id data) {
        NSDictionary *testDict = @{@"section_id":@"1",@"section_title":@"热门搜索",@"section_content":data[@"data"]};
        NSMutableArray *testArray = [@[] mutableCopy];
        [testArray addObject:testDict];
        
        /***  去数据查看 是否有数据*/
        //历史数据记录
        NSDictionary *parmDict  = [SARUserInfo gainSearchHistory];
//        NSDictionary *dbDictionary =  [CXDBHandle statusesWithParams:parmDict];
        if ([parmDict count]>0) {
            [testArray addObject:parmDict];
            [self.searchArray addObjectsFromArray:parmDict[@"section_content"]];
        }
        for (NSDictionary *sectionDict in testArray) {
            CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:sectionDict];
            [self.sectionArray addObject:model];
        }
        [_cxSearchCollectionView reloadData];
    } fail:^(NSString *error) {
        
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cxSearchTextField becomeFirstResponder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[section];
    return sectionModel.section_contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cxSearchCollectionViewCell forIndexPath:indexPath];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    [cell.contentButton setTitle:contentModel.name forState:UIControlStateNormal];
    cell.selectDelegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]){
        SelectCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIden forIndexPath:indexPath];
        view.delectDelegate = self;
        CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
        [view setText:sectionModel.section_title];
        /***  此处完全 也可以自定义自己想要的模型对应放入*/
        if(indexPath.section == 0)
        {
            [view setImage:@"cxCool"];
            view.delectButton.hidden = YES;
        }else{
            [view setImage:@"cxSearch"];
            view.delectButton.hidden = NO;
        }
        reusableview = view;
    }
    return reusableview;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    if (sectionModel.section_contentArray.count > 0) {
        CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
        return [CXSearchCollectionViewCell getSizeWithText:contentModel.name];
    }
    return CGSizeMake(80, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

#pragma mark - SelectCollectionCellDelegate
- (void)selectButttonClick:(CXSearchCollectionViewCell *)cell;
{
    NSIndexPath* indexPath = [self.cxSearchCollectionView indexPathForCell:cell];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    _cxSearchTextField.text = contentModel.name;
    [_cxSearchTextField resignFirstResponder];
    if (![self.searchArray containsObject:[NSDictionary dictionaryWithObject:_cxSearchTextField.text forKey:@"name"]]) {
        [self reloadData:_cxSearchTextField.text];
        
        //            _cxSearchTextField.text = @"";
    }
//    
//    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您该去搜索 %@ 的相关内容了",contentModel.name] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了！", nil];
//    [al show];
}


#pragma mark - UICollectionReusableViewButtonDelegate
- (void)delectData:(SelectCollectionReusableView *)view;
{
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
        [self.searchArray removeAllObjects];
        [self.cxSearchCollectionView reloadData];
        [SARUserInfo removeSearchHistory];
//        [CXDBHandle saveStatuses:@{} andParam:@{@"category":@"1"}];
    }
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.cxSearchTextField resignFirstResponder];
}

#pragma mark --------textDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_cxSearchTextField.text.length>0) {
        if (![self.searchArray containsObject:[NSDictionary dictionaryWithObject:_cxSearchTextField.text forKey:@"name"]]) {
             [self reloadData:_cxSearchTextField.text];
        }
        [self searchForTitle:_cxSearchTextField.text];
        self.cxSearchTextField.text = @""; 
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_cxSearchTextField resignFirstResponder];
    return YES;
}


- (void)reloadData:(NSString *)textString
{
    [self.searchArray addObject:[NSDictionary dictionaryWithObject:textString forKey:@"name"]];
    
    NSDictionary *searchDict = @{@"section_id":@"2",@"section_title":@"历史记录",@"section_content":self.searchArray};
    [SARUserInfo saveSearchHistory:searchDict];
    
    /***由于数据量并不大 这样每次存入再删除没问题  存数据库*/
//    NSDictionary *parmDict  = @{@"category":@"1"};
//    [CXDBHandle saveStatuses:searchDict andParam:parmDict];
//    
    CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:searchDict];
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
    }
    [self.sectionArray addObject:model];
    [self.cxSearchCollectionView reloadData];
    
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


#pragma mark -----搜索类型
-(void)changeType{
    JSDropmenuView *dropmenuView = [[JSDropmenuView alloc] initWithFrame:CGRectMake(15, 50, 100, 100)];
    dropmenuView.delegate = self;
    dropmenuView.alpha = 0.9;
    [dropmenuView showViewInView:self.navigationController.view];
}


#pragma mark - JSDropmenuViewDelegate
- (NSArray *)dropmenuDataSource {
    return self.menuArray;
}

- (void)dropmenuView:(JSDropmenuView *)dropmenuView didSelectedRow:(NSInteger)index {
    if(index>=self.menuArray.count){
        return;
    }
    NSDictionary *itemDic = [self.menuArray objectAtIndex:index];
    [NSString stringWithFormat:@"选中 ----- %@",[itemDic objectForKey:@"title"]];
    NSString *btnTitle = [itemDic objectForKey:@"title"];
    [_typeButton setTitle:btnTitle forState:UIControlStateNormal];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_cxSearchTextField resignFirstResponder];
}


#pragma mark ----搜索数据
-(void)searchForTitle:(NSString *)title{
    SearchResultController * search = [[SearchResultController alloc]init];
    search.searchName = title;
    [self.navigationController pushViewController:search animated:YES];
}

@end
