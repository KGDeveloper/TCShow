//
//  XXMyOrderTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXMyOrderTableViewController.h"
#import "HostProfileTableViewCell.h"
#import "XXOrderGoodsTableViewCell.h"
#import "XXPriceAndCountTableViewCell.h"
#import "XXOperationOrderTableViewCell.h"
#import "XXAppraiseTableViewController.h"
#import "XXOrderDetailTableViewController.h"
#import "PaymentViewController.h"
#import "XXMyorderSellUpViewController.h"

@interface XXMyOrderTableViewController ()<XXOperationOrderTableViewCellDelegate>
{
    
    
    NSMutableArray *_dataArr;
}
@end

@implementation XXMyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(241, 239, 250);
    _dataArr = [NSMutableArray array];
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self createData];
    [self setUpRefresh];
    
}
    
#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArr.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3 + [_dataArr[section][@"goods_list"] count];
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger _count;
    _count = [_dataArr[indexPath.section][@"goods_list"] count];
    NSArray *goodsListArr = [NSArray arrayWithArray:_dataArr[indexPath.section][@"goods_list"]];
    if (indexPath.row == 0) {
        HostProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HostProfileTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HostProfileTableViewCell" owner:self options:nil]lastObject];
        }
        if (![_dataArr[indexPath.section][@"store_name"] isEqual:[NSNull null]]) {
            cell.textLabel.text = _dataArr[indexPath.section][@"store_name"];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(69, 69, 69);
        cell.contentStr.textColor = kNavBarThemeColor;
        cell.contentStr.text = _dataArr[indexPath.section][@"order_status_desc"];
        cell.contentStr.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
    }else if (indexPath.row == (_count + 1)){
        XXPriceAndCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXPriceAndCountTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXPriceAndCountTableViewCell" owner:self options:nil]lastObject];
        }
        cell.price.text = [NSString stringWithFormat:@"共%d件  合计 ¥%@",(int)[_dataArr[indexPath.section][@"goods_list"] count],_dataArr[indexPath.section][@"order_amount"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.row == (_count + 2)){
        XXOperationOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOperationOrderTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOperationOrderTableViewCell" owner:self options:nil]lastObject];
        }
        NSString *type = _dataArr[indexPath.section][@"order_status_code"];
        NSString *B1Str;
        NSString *B2Str;
        if ([type isEqualToString:@"WAITPAY"]) {
            // WAITPAY => 待支付
            B1Str = @"取消订单";
            B2Str = @"付款";
        }else if ([type isEqualToString:@"WAITSEND"]){
        // WAITSEND => 待发货
            B1Str = @"";
            B2Str = @"提醒发货";
        }else if ([type isEqualToString:@"WAITRECEIVE"]){
            // WAITRECEIVE => 待收货
            B1Str = @"查看物流";
            B2Str = @"确认收货";
        }else if ([type isEqualToString:@"WAITCCOMMENT"]){
            // WAITCCOMMENT => 待评价
            B1Str = @"申请退货";
            B2Str = @"评价";
        }else if ([type isEqualToString:@"FINISH"]){
            // COMMENTED => 已完成
            B1Str = @"";
            B2Str = @"查看详情";
        }else if ([type isEqualToString:@"RETURNED"]){

            // RETURNED => 已退货
            B1Str = @"";
            B2Str = @"查看物流";
        }
        else
        {
            B1Str = @"已同意";
            B2Str = @"设置物流";
        }
        
        [cell.B1 setTitle:B1Str forState:UIControlStateNormal];
        [cell.B2 setTitle:B2Str forState:UIControlStateNormal];
        
         cell.B2.layer.borderWidth = 1;
         cell.B1.layer.borderWidth = 1;
        
         cell.B2.layer.borderColor = kNavBarThemeColor.CGColor;
         cell.B1.layer.borderColor = RGB(213, 212, 215).CGColor;
        
         cell.B2.layer.cornerRadius = 2.5;
         cell.B1.layer.cornerRadius = 2.5;
        
        cell.B2.tag = [_dataArr[indexPath.section][@"order_id"] integerValue];
        
        cell.delegate = self;
        if ([B1Str isEqualToString:@""]) {
            cell.B1.hidden = YES;
        }
        if ([B2Str isEqualToString:@""]) {
            cell.B2.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        XXOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderGoodsTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderGoodsTableViewCell" owner:self options:nil]lastObject];
        }
        CGRect frame = cell.goodsName.frame;
        frame.size.width = kSCREEN_WIDTH - 15 - cell.price.width  - cell.goodsName.origin.x;
        
        cell.goodsName.frame = frame;
        
        NSString *string = goodsListArr[indexPath.row - 1][@"original_img"];
        if ([string isEqual:[NSNull null]] || string==nil) {
            
            string =@"";
            
        }
        NSString *imgStr = string;
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        [cell.img sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];

        cell.goodsName.text = goodsListArr[indexPath.row - 1][@"goods_name"];
        cell.price.text = goodsListArr[indexPath.row - 1][@"goods_price"];
        cell.goodsCount.text = [NSString stringWithFormat:@"X %@",goodsListArr[indexPath.row - 1][@"goods_num"]];
        cell.classification.text = goodsListArr[indexPath.row - 1][@"goods_standard"];
        cell.classification.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
   
    
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger _count;
    _count = [_dataArr[indexPath.section][@"goods_list"] count];

    if (indexPath.row == 0) {
        return 45;
    }else if (indexPath.row == (_count + 1)){
        return 35;
    }else if (indexPath.row == (_count + 2)){
        return 55;
    }else{
        return 100;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)createData{
 
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[SARUserInfo userId] forKey:@"user_id"];
    if (_orderType) {
        [para setObject:_orderType forKey:@"type"];
    }
    
    
    [RequestData requestWithUrl:USER_ORDER_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        
        if ([dic[@"code"] doubleValue] == 0) {
//            [_dataArr removeAllObjects];
            _dataArr = dic[@"data"];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    [self.tableView.header endRefreshing];
    }];
    

}

#pragma XXOperationOrderTableViewCellDelegate


- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title srderid:(NSString *)orderid
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入物流公司";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入物流编号";
        
    }];
    
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *wuliu = [alert.textFields firstObject];
        UITextField *dindan = [alert.textFields lastObject];
        
        if ([wuliu.text isEqualToString:@""] && [dindan.text isEqualToString:@""]) {
            
            [self AlertViewMessage:@"请填写完整信息" buttonTitle:@"确定"];
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
        [dic setValue:orderid forKey:@"id"];
        [dic setValue:wuliu.text forKey:@"shipping_name"];
        [dic setValue:dindan.text forKey:@"shipping_code"];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        [manger POST:ORDER_RETURN_WL_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];
        
    }];
    
    [alert addAction:but];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:but];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void)clickTableViewCell:(UITableViewCell *)cell flag:(NSInteger)tag{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    NSString *type = _dataArr[index.section][@"order_status_code"];
    
    if ([type isEqualToString:@"WAITPAY"]) {
        // WAITPAY => 待支付
//        B1Str = @"取消订单";
//        B2Str = @"付款";
        
        
        if (tag == 10) {
            [self cancelOrder:index.section];
        }else{
            PaymentViewController * pay = [[PaymentViewController alloc]init];
            
            pay.payMoney = _dataArr[index.section][@"order_amount"];
            
            pay.order_sns = _dataArr[index.section][@"order_sn"];
            
            [self.navigationController pushViewController:pay animated:YES];
        }
    }else if ([type isEqualToString:@"WAITSEND"]){
        // WAITSEND => 待发货
        
        XXOperationOrderTableViewCell *cell;
        if ([cell isKindOfClass:[XXOperationOrderTableViewCell class]]) {
            
            [cell.B1 setUserInteractionEnabled:NO];
        }
        
//        B2Str = @"提醒发货";
        if (tag == 10) {
            
        }else if (tag == 11){
//待实现提醒发货
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒发货" message:@"已提醒卖家发货" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒发货" message:@"已提醒卖家发货" delegate: self cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alert show];
        }
    }else if ([type isEqualToString:@"WAITRECEIVE"]){
        // WAITRECEIVE => 待收货
//        B1Str = @"查看物流";
//        B2Str = @"确认收货";
        if (tag == 10) {
            NSString *shippingNameStr = _dataArr[index.section][@"shipping_name"];
            NSString *shippingCodeStr = _dataArr[index.section][@"shipping_code"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:shippingNameStr message:[NSString stringWithFormat:@"物流单号：%@，已复制粘贴板", shippingCodeStr] delegate: self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = shippingCodeStr;
            
        }else if (tag == 11){
            [self confirmReceipt:index.section];
        }
    }else if ([type isEqualToString:@"WAITCCOMMENT"]){
        // WAITCCOMMENT => 待评价
//        B1Str = @"删除订单";
//        B2Str = @"评价";
        if (tag == 10) {
            
            XXMyorderSellUpViewController *nv = [[XXMyorderSellUpViewController alloc]init];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退货提示" message:@"请填写退货原因" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
               textField.placeholder = @"请输入退货原因";
                
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UITextField *textFd = alert.textFields.firstObject;
                nv.reason = textFd.text;
                nv.uid =_dataArr[index.section][@"uid"];
                nv.type =_dataArr[index.section][@"type"];
                nv.goods_id =_dataArr[index.section][@"good_id"];
                nv.order_sn =_dataArr[index.section][@"order_sn"];
                nv.order_id =_dataArr[index.section][@"order_id"];
                nv.user_id =_dataArr[index.section][@"user_id"];
                nv.order_pay = _dataArr[index.section][@"order_amount"];
                nv.spec_key = [_dataArr[index.section][@"goods_list"] firstObject][@"good_standard_size"];
                
                [self.navigationController pushViewController:nv animated:YES];
                
            }];
            
            UIAlertAction *cancl = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:okAction];
            [alert addAction:cancl];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
        }else if (tag == 11){
            [self evaluate:_dataArr[index.section]];
        }
    }else if ([type isEqualToString:@"FINISH"]){
        // COMMENTED => 已完成
//        B1Str = @"删除订单";
//        B2Str = @"追加评论";
        if (tag == 10) {
            
        }else if (tag == 11){
//            [self evaluate:_dataArr[index.section]];
            XXOrderDetailTableViewController *detail = [[XXOrderDetailTableViewController alloc] init];
            detail.order_id = _dataArr[index.section][@"order_id"];
            
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else if ([type isEqualToString:@"RETURNED"]){

        // RETURNED => 已退货
//        B1Str = @"删除订单";
//        B2Str = @"查看物流";
        if (tag == 10) {
            
        }else if (tag == 11){
            
        }
    }


}

// 取消订单
- (void)cancelOrder:(NSInteger)section{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"order_id":_dataArr[section][@"order_id"]};
    [RequestData requestWithUrl:CANCEL_ORDER para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [self.tableView.header beginRefreshing];
            
        }
    } fail:^(NSError *error){
        
    }];
    

}

// 收货确认
- (void)confirmReceipt:(NSInteger)section{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"order_id":_dataArr[section][@"order_id"]};
    [RequestData requestWithUrl:ORDER_CONFIRM para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [[HUDHelper sharedInstance] tipMessage:@"确认成功"];
            [self.tableView.header beginRefreshing];
            [self.tableView reloadData];
        }else {
            [[HUDHelper sharedInstance] tipMessage:@"确认失败"];
        }
    } fail:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
    }];
    
}

// 下拉刷新
-(void)setUpRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    [self.tableView.header beginRefreshing];
    
}

// 评价
- (void)evaluate:(NSDictionary *)dic{
    XXAppraiseTableViewController *appraise = [[XXAppraiseTableViewController alloc] init];
    appraise.goodsDic = dic;
    [self.navigationController pushViewController:appraise animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
   
    XXOrderDetailTableViewController *detail = [[XXOrderDetailTableViewController alloc] init];
    detail.order_id = _dataArr[indexPath.section][@"order_id"];
    [self.navigationController pushViewController:detail animated:YES];
    


}




@end
