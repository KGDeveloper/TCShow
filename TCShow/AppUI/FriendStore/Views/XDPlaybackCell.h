//
//  XDPlaybackCell.h
//  咖秀直播
//
//  Created by tangtianshi on 16/4/6.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "huifangModel.h"
@interface XDPlaybackCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *livingPic;
@property (weak, nonatomic) IBOutlet UILabel *livingName;
@property (weak, nonatomic) IBOutlet UIButton *auNumberBtn;
@property(nonatomic,strong)huifangModel *huifang;
@end
