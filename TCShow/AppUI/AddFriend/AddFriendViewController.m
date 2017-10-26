    //
//  AddFriendViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SDContactModel.h"
#import "MJExtension.h"
@implementation AddFriendPageItem

@end


@implementation AddFriendSearchResultViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _searchArray = [NSMutableArray arrayWithCapacity:0];
    _conversationListArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary * dic = [SARUserInfo gainContacts];
    NSMutableArray * phoneArray = [NSMutableArray arrayWithCapacity:0];
    phoneArray = [SDContactModel mj_objectArrayWithKeyValuesArray:dic[@"data"] context:nil];
    for (SDContactModel * model in phoneArray) {
        [_conversationListArray addObject:model.phone];
    }
}

- (void)addHeaderView
{
    
}

- (void)configOwnViews
{
    _pageItem = [[AddFriendPageItem alloc] init];
    _datas = [NSMutableArray array];
}

- (void)showNoDataView
{
    [_noResultTip sizeWith:CGSizeMake(_noDataView.bounds.size.width, 60)];
    [_noResultTip alignParentTopWithMargin:40 + 64];
}

- (void)addNoDataView
{
    _noDataView = [[UIView alloc] init];
    _noDataView.backgroundColor = kLightGrayColor;
    [self.view addSubview:_noDataView];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = kLightGrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = @"没有搜索到对应用户,请检查输入是否正确";//@"根据用户ID或手机号搜索要添加的好友";
    [self.view addSubview:label];
    [_noDataView addSubview:label];
    _noResultTip = label;
    
}


- (void)onSearchTextResult:(NSArray *)data
{
    [_datas removeAllObjects];
    [self onLoadMoreSearchTextResult:data];
}

- (void)onLoadMoreSearchTextResult:(NSArray *)data
{
    [_datas addObjectsFromArray:data];
    self.canLoadMore = _pageItem.canLoadMore;
    [self reloadData];
    
    if (_searchDisController)
    {
        [_searchDisController.searchResultsTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    __weak AddFriendSearchResultViewController *ws = self;
    
    [[Business sharedInstance] searchAddFriend:[SARUserInfo userId] name:searchBar.text succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            array = [SDContactModel mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws onSearchTextResult:array];
            });
            
        }else{
            
        }
    } fail:^(NSString *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            [ws allLoadingCompleted];
        });

    }];
//    NSString *string = [[TLSHelper getInstance] getSDKVersion];
//    
//    
//    
//    AddFriendPageItem *item = (AddFriendPageItem *)_pageItem;
//    if (![item.key isEqualToString:searchBar.text])
//    {
//        item.key = searchBar.text;
//        _pageItem.pageIndex = 0;
//        
//        __weak AddFriendSearchResultViewController *ws = self;
//        [[IMAPlatform sharedInstance] asyncSearchUserBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *ul) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [ws onSearchTextResult:ul];
//            });
//        } fail:^(int code, NSString *err) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
//                [ws allLoadingCompleted];
//            });
//        }];
//    }
    
}

- (void)onLoadMore
{
    __weak AddFriendSearchResultViewController *ws = self;
//    [[IMAPlatform sharedInstance] asyncSearchUserBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *ul) {
//        [ws onLoadMoreSearchTextResult:ul];
//    } fail:^(int code, NSString *err) {
//        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
//        [ws allLoadingCompleted];
//    }];
    [[Business sharedInstance] searchAddFriend:[SARUserInfo userId] name:_searchController.searchBar.text succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            array = [SDContactModel mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
            [ws onLoadMoreSearchTextResult:array];
        }else{
            
        }
    } fail:^(NSString *error) {
        [ws allLoadingCompleted];
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchController = searchController;
    if (searchController.searchResultsController.view.hidden)
    {
        searchController.searchResultsController.view.hidden = NO;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchDisController = controller;
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUser"];
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchUser"];
//        cell.imageView.layer.cornerRadius = 16;
//        
//    }
//    
//    id<IMAUserShowAble> user = _datas[indexPath.row];
//    
//    [cell.imageView sd_setImageWithURL:[user showIconUrl] placeholderImage:kDefaultUserIcon];
//    cell.textLabel.text = [user showTitle];
    XSearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[XSearchFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.indexpath = indexPath;
    cell.delegate = self;
    SDContactModel *model = [_datas objectAtIndex:indexPath.row];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(model.headsmall)] placeholderImage:IMAGE(@"search_friend_head")];
    cell.nameL.text = model.nickname;
    if (model.personalized.length>0) {
        cell.contentTitleL.text = model.personalized;
    }
    if ([_conversationListArray containsObject:model.phone]) {
            cell.addBtn.selected = YES;
    }else{
        cell.addBtn.selected = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDContactModel * model = _datas[indexPath.row];
    XSearchFriendCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    [[Business sharedInstance] addFriend:[SARUserInfo userId] friend_phone:model.phone succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            [[HUDHelper sharedInstance] tipMessage:msg];
            cell.addBtn.selected = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[HUDHelper sharedInstance] tipMessage:msg];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 添加关注 cell代理
-(void)addConcernDelegate:(NSIndexPath *)indexPath{
    SDContactModel * model = _datas[indexPath.row];
    XSearchFriendCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    [[Business sharedInstance] addFriend:[SARUserInfo userId] friend_phone:model.phone succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            [[HUDHelper sharedInstance] tipMessage:msg];
            cell.addBtn.selected = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[HUDHelper sharedInstance] tipMessage:msg];
        }
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}




@end


@implementation AddFriendViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加好友";
}

- (void)addHeaderView
{

}
- (void)addFooterView
{
    
}
- (Class)searchResultControllerClass
{
    return [AddFriendSearchResultViewController class];
}

- (void)addSearchController
{
    [super addSearchController];
    
    if (_searchController)
    {
        _searchController.searchBar.placeholder = @"请输入账号/昵称";
    }
    if (_searchDisController)
    {
        _searchDisController.searchBar.placeholder = @"请输入账号/昵称";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchController.searchBar resignFirstResponder];
}



@end
