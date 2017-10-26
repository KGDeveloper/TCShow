//
//  HomeCollectionCell.h
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *personImage;



- (void)configWith:(TCShowLiveListItem *)item;
@end
