//
//  XXAppraiseOverallTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 17/1/12.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXAppraiseOverallTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starBtn1;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starBtn2;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starBtn3;
@property (weak, nonatomic) IBOutlet UILabel *btn1Score;
@property (weak, nonatomic) IBOutlet UILabel *btn2Score;
@property (weak, nonatomic) IBOutlet UILabel *btn3Score;


@end
