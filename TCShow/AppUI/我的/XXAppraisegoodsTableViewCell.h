//
//  XXAppraisegoodsTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 17/1/12.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXAppraisegoodsTableViewCellDelegate  <NSObject>

- (void)click:(UITableViewCell *)cell flag:(int)tag;

@end

@interface XXAppraisegoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starBtn;

@property (assign, nonatomic) id<XXAppraisegoodsTableViewCellDelegate>delegate;

@end
