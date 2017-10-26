//
//  BusinessTableViewCell.h
//  FineQuality
//
//  Created by tangtianshi on 16/6/1.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
