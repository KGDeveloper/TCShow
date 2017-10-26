//
//  AddressTableViewCell.h
//  tangtianshi
//
//  Created by tangtianshi on 16/2/25.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import <UIKit/UIKit.h>
// 添加代理
@protocol AddressTableViewCellDelegate <NSObject>

- (void)btnClick:(UITableViewCell *)cell angFlag:(int)flag;

@end
@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *Default;
@property (weak, nonatomic) IBOutlet UIButton *setDef;
@property (weak, nonatomic) IBOutlet UIButton *editor;

@property (weak, nonatomic) IBOutlet UIButton *deleteAddress;

@property (assign, nonatomic) id<AddressTableViewCellDelegate>delegate;

@end
