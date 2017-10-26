//
//  MangerListTableViewCell.m
//  TCShow
//
//  Created by  m, on 2017/9/4.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "MangerListTableViewCell.h"

@implementation MangerListTableViewCell



- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

- (IBAction)cellButtonDidTouch:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"设置发货"]) {
        
        NSString *tmp = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        self.strString(tmp);
    }
    else if([sender.titleLabel.text isEqualToString:@"审核"])
    {
        
        [self sendApplay:sender.tag];
        
        sender.titleLabel.text = @"已同意";
        
    }
    
}

- (void) sendApplay:(NSInteger )str
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)str] forKey:@"id"];
    [dic setValue:[SARUserInfo userId] forKey:@"uid"];
    [dic setValue:@"1" forKey:@"status"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:MYORDER_SELL_UP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tmp = responseObject[@"message"];
        self.sendStatus(tmp);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
