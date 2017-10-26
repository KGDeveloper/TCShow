//
//  TCGoodsTypeController.h
//  TCShow
//
//  Created by tangtianshi on 17/1/6.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReleaseForTypeDelegate <NSObject>
-(void)releaseGoodsUid:(NSString *)goodsUid goodsName:(NSString *)goodsName;
@end
@interface TCGoodsTypeController : UITableViewController
@property(nonatomic,assign)id<ReleaseForTypeDelegate>typeDelegate;
@end
