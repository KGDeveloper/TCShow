//
//  TCLiveGoodsView.h
//  TCShow
//
//  Created by tangtianshi on 16/12/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCLiveGoodsTableCell.h"
#import "TCAddGoodsForCart.h"
#import "TCGoodsManageModel.h"

@interface TCLiveGoodsView : UIView<UITableViewDelegate,UITableViewDataSource,AddGoodsCartDelegate,AddCartViewDelegate>
{
@protected
    UIView   *_clearBg;
    UITableView * _goodsTableView;
    
    NSMutableArray * _dataArray;
}
@property (nonatomic, assign) BOOL isWhiteMode;
@property (nonatomic,copy) NSString * merchantUid;//商户uid
@end
