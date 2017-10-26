//
//  XConcerViewController.m
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XConcerViewController.h"
#import "XConcernCell.h"
#import "Macro.h"
#import "MJBaseTableView.h"
@interface XConcerViewController ()
{
    MJConcernTableView *_concernTableview;
}
@end

@implementation XConcerViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_concernTableview startRefreshTimer];

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_concernTableview stopRefreshTimer];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    _concernTableview = [[MJConcernTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.view.frame.size.height-NAVIGATIONBAR_HEIGHT - STATUS_HEIGHT)];
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
    [self.view addSubview:_concernTableview];
    
    [_concernTableview beginRefreshing];
    
    
    // Do any additional setup after loading the view.
}

//
//#pragma mark -- tableview代理
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 5;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 105+CELL_IMAGE_HEIGHT;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    XConcernCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil) {
//        
//        cell = [[NSBundle mainBundle] loadNibNamed:@"XConcernCell" owner:self options:nil].lastObject;
//    }
//    
//    return cell;
//    
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
