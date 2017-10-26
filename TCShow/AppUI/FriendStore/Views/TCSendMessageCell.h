//
//  TCSendMessageCell.h
//  TCShow
//
//  Created by tangtianshi on 16/12/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCSendMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property(nonatomic,copy)void(^sendMessage)(void);

@end
