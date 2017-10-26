//
//  MJBaseTableView.h
//  live
//
//  Created by AlexiChen on 15/10/12.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "UIView+IMB.h"
#import "MJExtension.h"
#import "ConcernModel.h"
typedef void(^CellClickBlock)(id obj,NSIndexPath *indexPath,UITableView *table);

@interface MJBaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
{
    MJRefreshNormalHeader       *_header;           //下拉刷新
    MJRefreshBackNormalFooter   *_footer;           //上拉加载
    NSMutableArray              *_datas;
    NSTimer                     *_refreshTimer;
    BOOL                        _isLoading;
    NSUInteger                  pageNo_;            // 页数
    NSUInteger page;// 分页
}

@property (nonatomic, strong) CellClickBlock cBlock;

- (void)handleCellClick:(CellClickBlock)block;

- (void)beginRefreshing;

- (void)refreshData;

- (void)loadData;

- (void)startRefreshTimer;
- (void)stopRefreshTimer;

- (void)showNoDataView:(NSString *)imgName title:(NSString *)title;
- (void)hideNoDataView;

@end

@interface MJBaseLiveTableView : MJBaseTableView

@end

@interface MJLiveTableView : MJBaseLiveTableView

@end

@interface MJTrailerTableView : MJBaseLiveTableView

@end


@interface MJVideoTableView : MJBaseTableView

@end

@interface MJConcernTableView : MJBaseLiveTableView

@end
