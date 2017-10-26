//
//  MoneyRecordTableController.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MoneyRecordTableController.h"
#import "MoneyRecordTableCell.h"

@interface MoneyRecordTableController ()
{
    NSArray *_dataArray;
}
@end

@implementation MoneyRecordTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单明细";
    self.tableView.showsVerticalScrollIndicator = NO;
    _dataArray = [NSArray array];
    [self setUpRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonRecCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyRecordTableCell" owner:nil options:nil]firstObject];
    }
    cell.surplusMoney.text = _dataArray[indexPath.row][@"total_amount"];
    cell.Payment.text = _dataArray[indexPath.row][@"pay_name"];
    NSString *str = _dataArray[indexPath.row][@"pay_time"];//时间戳
    NSTimeInterval time = [str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
   
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    cell.dateTimeLabel.text = currentDateStr;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

// 下拉刷新
-(void)setUpRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    [self.tableView.header beginRefreshing];
    
}

- (void)createData{

    NSDictionary *para = @{@"uid":[SARUserInfo userId]};
    [RequestData requestWithUrl:BILL_DEATILS para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] doubleValue] == 0) {
            
            _dataArray = dic[@"data"];
            
            
            
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
        
        
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    }];
    
    
}



@end
