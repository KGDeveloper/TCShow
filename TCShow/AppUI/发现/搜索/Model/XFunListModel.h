//
//  XFunListModel.h
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFunListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *attention_user_id;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *personalized;
@property (nonatomic,copy)NSNumber *is_attention;

@end
