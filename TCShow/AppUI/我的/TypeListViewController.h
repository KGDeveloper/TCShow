//
//  TypeListViewController.h
//  TCShow
//
//  Created by  m, on 2017/9/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TypeListViewController;

typedef void (^sendDetiarToController)(NSMutableArray * sendArr);


@interface TypeListViewController : UIViewController

@property (nonatomic,copy) sendDetiarToController sendArr;

@end
