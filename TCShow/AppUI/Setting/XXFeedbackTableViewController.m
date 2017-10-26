//
//  XXFeedbackTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXFeedbackTableViewController.h"
#import "XXFeedbackDetailViewController.h"
#import "XXFeedbackTableViewCell.h"
@interface XXFeedbackTableViewController ()<XXFeedbackTableViewCellDelegate>
{
    NSArray *_dataArr;
    NSString *_feedbackStr;
}
@end

@implementation XXFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给个建议";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    _dataArr = [NSArray array];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, kSCREEN_HEIGHT - 48 - 264, kSCREEN_WIDTH - 20, 40);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = LEMON_MAINCOLOR;
    btn.layer.cornerRadius = 5;
    [self.tableView addSubview:btn];
    
    [btn addTarget:self action:@selector(Feedback) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self createData];
    
//    41 39 50
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXFeedbackTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXFeedbackTableViewCell" owner:self options:nil]lastObject];
            
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.feedbackTextView.backgroundColor = [UIColor grayColor];
    cell.delegate = self;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 12;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"快速反馈";
//    }
    return nil;

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    XXFeedbackDetailViewController *detail = [[XXFeedbackDetailViewController alloc] init];
//    detail.dataDic = _dataArr[indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
//
//}

//- (void)createData{
//
//    [RequestData requestWithUrl:RETROACT_HOT Complete:^(NSData *data) {
//      
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] doubleValue] == 0) {
//            _dataArr = dic[@"data"];
//            [self.tableView reloadData];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
//
//
//
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
// 反馈
- (void)Feedback{
    
    if (!_feedbackStr) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入建议"];
        return;
    }

    NSDictionary *para =  @{@"user_id":[SARUserInfo userId],@"content":_feedbackStr};
    [RequestData requestWithUrl:USER_RETROACT para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [[HUDHelper sharedInstance] tipMessage:dic[@"message"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
}

- (void)returnTextViewString:(NSString *)text click:(UITableViewCell *)cell{
    _feedbackStr = text;
}



@end
