//
//  XSearchFriendCell.h
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellDelegate <NSObject>

-(void)addConcernDelegate:(NSIndexPath *)indexPath;

@end

@interface XSearchFriendCell : UITableViewCell

@property (nonatomic,strong)id<cellDelegate>delegate;

@property (nonatomic,strong)NSIndexPath *indexpath;
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameL;
@property (nonatomic,strong)UILabel *contentTitleL;
@property (nonatomic,strong)UIButton *addBtn;

@end
