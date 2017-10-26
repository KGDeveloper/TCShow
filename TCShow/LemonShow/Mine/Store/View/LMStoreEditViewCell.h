//
//  LMStoreEditViewCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/22.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMStoreEditViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refreshViewWithImage:(NSString *)imageStr Title:(NSString *)title Detail:(NSString *)datStr;

@end
