//
//  DistributionViewController.h
//  FineQuality
//
//  Created by tangtianshi on 16/9/9.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistributionViewControllerDelegate <NSObject>

- (void)returnType:(NSString *)type title:(NSString *)title section:(NSInteger)section;

@end

@interface DistributionViewController : UIViewController

@property(nonatomic,strong) NSString *selectType;

@property (assign, nonatomic) NSInteger distributionSection;

@property(nonatomic, assign) id<DistributionViewControllerDelegate>delegate;

@end
