//
//  XXAppraiseTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXAppraiseTableViewController.h"
#import "XXAppraisegoodsTableViewCell.h"
#import "XXFeedbackTableViewCell.h"
#import "XXAppraiseOverallTableViewCell.h"
@interface XXAppraiseTableViewController ()<XXFeedbackTableViewCellDelegate,XXAppraisegoodsTableViewCellDelegate>
{
    NSArray *_goodsArray;
    NSString *_goodsFraction;// 商品分数
    NSString *_logisticsFraction;// 物流分数
    NSString *_serviceFraction;// 服务分数
    NSString *_courierFraction;// 快递员分数
    NSString *_contentString;
    NSMutableArray *_commitArray;

}
@end

@implementation XXAppraiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货评价";
    self.view.backgroundColor = RGB(241, 239, 250);
    _goodsArray = [NSArray arrayWithArray:_goodsDic[@"goods_list"]];
    
    _commitArray = [NSMutableArray array];
    _serviceFraction = @"";
    _courierFraction = @"";
    _contentString = @"";
    for (NSDictionary *obj in _goodsArray) {
        
    NSMutableDictionary *commitDic = [NSMutableDictionary dictionary];
        [commitDic setObject:obj[@"goods_id"] forKey:@"goods_id"];
        [commitDic setObject:@"" forKey:@"content"];
        
        [commitDic setObject:@"" forKey:@"goods_rank"];
        
        [_commitArray addObject:commitDic];
        
    }
   
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(0, kSCREEN_HEIGHT - 44 - 64 , kSCREEN_WIDTH, 44);
    commitBtn.backgroundColor = kNavBarThemeColor;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1 + _goodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == _goodsArray.count) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _goodsArray.count) {
        return 170;
    }else{
        if (indexPath.row == 0) {
            return 85;
        }else{
          return 90;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 10;
    }else{
        return 0.1;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _goodsArray.count) {
        XXAppraiseOverallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAppraiseOverallTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXAppraiseOverallTableViewCell" owner:self options:nil]lastObject];
        }
        for (UIButton *btn in cell.starBtn1) {
            [btn addTarget:self action:@selector(score1:) forControlEvents:UIControlEventTouchUpInside];
        }
        for (UIButton *btn in cell.starBtn2) {
            [btn addTarget:self action:@selector(score2:) forControlEvents:UIControlEventTouchUpInside];
        }
        for (UIButton *btn in cell.starBtn3) {
            [btn addTarget:self action:@selector(score3:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            XXAppraisegoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAppraisegoodsTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXAppraisegoodsTableViewCell" owner:self options:nil]lastObject];
            }
//            for (UIButton *btn in cell.starBtn) {
//                 [btn addTarget:self action:@selector(score:) forControlEvents:UIControlEventTouchUpInside];
//            }
           
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            XXFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXFeedbackTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXFeedbackTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.feedbackTextView.text = @"亲，多说说收到货后的感受，对其他小伙伴帮助很大呦！";
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }

}

- (void)returnTextViewString:(NSString *)text click:(UITableViewCell *)cell{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    _contentString = text;
    [_commitArray[index.section] setObject:text forKey:@"content"];

    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//- (void)score:(UIButton *)sender{
//    for (int i = 0; i < sender.tag; i++) {
//        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
//        
//        UIButton *btn = [self.tableView viewWithTag:i + 1];
//        btn.backgroundColor = [UIColor redColor];
////        [btn setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
//        
//    }
//    for (int i = (int)sender.tag; i < 5; i++) {
//        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
//        
//        UIButton *btn = [self.tableView viewWithTag:i + 1];
//        btn.backgroundColor = [UIColor greenColor];
////        [btn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
//        
//    }
//
//    
//    _goodsFraction = [NSString stringWithFormat:@"%ld",sender.tag];
//    
//
//   
//}

- (void)score1:(UIButton *)sender{
    for (int i = 5; i < sender.tag; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];

        [btn setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
    }
    
    for (int i = (int)sender.tag; i < 10; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];
        [btn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];

    }
    
    _logisticsFraction = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    UILabel *label = [self.tableView viewWithTag:50];
    if (sender.tag > 7) {
        label.text = @"满意";
    }else{
    label.text = @"不满意";
    }
    
}

- (void)score2:(UIButton *)sender{
    for (int i = 10; i < sender.tag; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];

        [btn setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
    }
    
    for (int i = (int)sender.tag; i < 15; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];
        [btn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];

    }
    
    _serviceFraction = [NSString stringWithFormat:@"%ld",(long)sender.tag];

    
    UILabel *label = [self.tableView viewWithTag:51];
    if (sender.tag > 12) {
        label.text = @"满意";
    }else{
        label.text = @"不满意";
    }

}

- (void)score3:(UIButton *)sender{
    for (int i = 15; i < sender.tag; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];

        [btn setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
       
        
    }
    
    for (int i = (int)sender.tag; i < 20; i++) {
        //        [sender setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
        UIButton *btn = [self.tableView viewWithTag:i + 1];
        [btn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];


    }
    
    _courierFraction = [NSString stringWithFormat:@"%ld",(long)sender.tag];

    UILabel *label = [self.tableView viewWithTag:52];
    if (sender.tag > 17) {
        label.text = @"满意";
    }else{
        label.text = @"不满意";
    }

}
// 提交
- (void)commit{

    NSDictionary *dic = _commitArray[0];
    NSString *goods_id = dic[@"goods_id"];
    NSString *contentStr = dic[@"content"];
    NSString *goods_rank = dic[@"goods_rank"];
    if ([contentStr isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入评价"];
        return;
    }
    if ([goods_rank isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择商品评分"];
        return;
    }
    if ([_serviceFraction isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择服务评分"];
        return;
    }
    if ([_logisticsFraction isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择物流评分"];
        return;
    }
    if (_logisticsFraction ==nil) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择物流评分"];
        return;
    }
    if ([_courierFraction isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择快递员评分"];
        return;
    }
    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_commitArray
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
    
    
    
    NSDictionary *para =  @{@"user_id":[SARUserInfo userId],@"order_id":_goodsDic[@"order_id"],@"service_rank":_serviceFraction,@"deliver_rank":_logisticsFraction,@"courier_rank":_courierFraction,@"goods_rank":goods_rank, @"goods_id":goods_id, @"content":contentStr};
    
    [RequestData requestWithUrl:ADD_COMMENT para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [[HUDHelper sharedInstance] tipMessage:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[HUDHelper sharedInstance] tipMessage:dic[@"message"]];
        }
        
    } fail:^(NSError *error) {
         [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
    }];


}

- (void)click:(UITableViewCell *)cell flag:(int)tag{

    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    for (int i = 0; i < tag; i++) {

        
        UIButton *btn = [cell.contentView viewWithTag:i + 1];

                [btn setImage:[UIImage imageNamed:@"Stars"] forState:UIControlStateNormal];
        
    }
    for (int i = (int)tag; i < 5; i++) {

        
        UIButton *btn = [cell.contentView viewWithTag:i + 1];

                [btn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
        
    }
    
    
    [_commitArray[index.section] setObject:[NSString stringWithFormat:@"%d",tag] forKey:@"goods_rank"];
    

}


@end
