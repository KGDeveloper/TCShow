//
//  XXNotifierProPlusTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXNotifierProPlusTableViewController.h"
#import "XXNotifierProPlusTableViewCell.h"
@interface XXNotifierProPlusTableViewController ()

@end

@implementation XXNotifierProPlusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知";
    self.view.backgroundColor = RGB(241, 239, 250);
    

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXNotifierProPlusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXNotifierProPlusTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXNotifierProPlusTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.img.layer.masksToBounds = YES;
    cell.img.layer.cornerRadius = 43 * 0.5;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}




@end
