//
//  LMStoreMoldEditCell.h
//  TCShow
//
//  Created by 王孟 on 2017/8/26.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMStoreMoldEditCell : UITableViewCell

@property (copy, nonatomic) void (^removeBtnClickBlock)();

@property (weak, nonatomic) IBOutlet UITextField *leiXingTF;


@end
