//
//  AddFriendViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchResultViewController.h"
#import "XSearchFriendCell.h"
#import "SDContactModel.h"

@interface AddFriendPageItem : RequestPageParamItem

@property (nonatomic, copy) NSString *key;

@end

@interface AddFriendSearchResultViewController : SearchResultViewController<cellDelegate>
{
@protected
    UILabel     *_noResultTip;
    
    __weak UISearchController *_searchController;
    
    __weak UISearchDisplayController *_searchDisController;
}
@property(nonatomic,strong)NSMutableArray * conversationListArray;
@property(nonatomic,strong)NSMutableArray  * searchArray;
- (void)onSearchTextResult:(NSArray *)data;

- (void)onLoadMoreSearchTextResult:(NSArray *)data;
@end


@interface AddFriendViewController : TableSearchViewController


@end
