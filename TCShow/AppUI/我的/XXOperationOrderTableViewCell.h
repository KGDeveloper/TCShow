//
//  XXOperationOrderTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol XXOperationOrderTableViewCellDelegate <NSObject>

- (void)clickTableViewCell:(UITableViewCell *)cell flag:(NSInteger)tag;

- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title srderid:(NSString *)orderid;

@end
@interface XXOperationOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *B1;
@property (weak, nonatomic) IBOutlet UIButton *B2;

@property (assign,nonatomic) id<XXOperationOrderTableViewCellDelegate>delegate;

@end
