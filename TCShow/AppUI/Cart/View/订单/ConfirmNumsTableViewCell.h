//
//  ConfirmNumsTableViewCell.h
//  FineQuality
//
//  Created by tangtianshi on 16/9/14.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**购买数量*/
@protocol ConfirmNumsTableViewCellDelegate <NSObject>

- (void)btn:(UITableViewCell *_Nullable)cell tag:(NSInteger)flag;

@end
@interface ConfirmNumsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton * _Nullable reduce;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable increase;
@property (weak, nonatomic) IBOutlet UITextField * _Nullable number;
@property (assign, nonnull) id<ConfirmNumsTableViewCellDelegate>delegate;

@end
