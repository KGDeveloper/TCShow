//
//  SelectAdressViewController.h
//  FineQuality
//
//  Created by tangtianshi on 16/9/19.
//  Copyright © 2016年 QCWL. All rights reserved.
//


/**
 选择收货地址

 @return <#return value description#>
 */
#import <UIKit/UIKit.h>

@protocol SelectAdressViewControllerDelegate <NSObject>

- (void)returnAdress:(NSDictionary *)adressDic;

@end

@interface SelectAdressViewController : UIViewController

@property (nonatomic,assign) id<SelectAdressViewControllerDelegate>delegate;

@end
