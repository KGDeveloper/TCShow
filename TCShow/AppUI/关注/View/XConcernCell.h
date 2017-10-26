//
//  XConcernCell.h
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConcernModel.h"
@interface XConcernCell : UITableViewCell{
@protected
    __weak id<TCShowLiveRoomAble> _liveItem;
}

@property (weak, nonatomic) IBOutlet UILabel *username;//用户名
@property (weak, nonatomic) IBOutlet UILabel *address;// 地址
@property (weak, nonatomic) IBOutlet UILabel *watchNum;//观看人数
@property (weak, nonatomic) IBOutlet UILabel *heartNum;//点赞人数
@property (weak, nonatomic) IBOutlet UILabel *giftNum;//礼物数量
@property (weak, nonatomic) IBOutlet UILabel *contntTitle;// 标题
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;// 头像
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;// 直播图片

@property (nonatomic, strong) NSDictionary *liveInfo;

@property(nonatomic,strong)ConcernModel *concernModel;
- (void)configWith:(id<TCShowLiveRoomAble>)item;
@end
