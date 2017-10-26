//
//  PayTableViewCell.h
//  ShoppingCart
//
//  Created by tangtianshi on 16/11/1.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *paySelectImage;
@property (strong, nonatomic) IBOutlet UIImageView *payImage;
@property (strong, nonatomic) IBOutlet UILabel *payName;

@end
