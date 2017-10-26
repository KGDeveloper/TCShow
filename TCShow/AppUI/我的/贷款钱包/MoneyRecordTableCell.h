//
//  MoneyRecordTableCell.h
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyRecordTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *surplusMoney;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *Payment;  // 支付方式

@end
