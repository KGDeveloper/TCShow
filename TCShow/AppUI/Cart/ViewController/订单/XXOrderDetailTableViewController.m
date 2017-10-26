//
//  XXOrderDetailTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 17/1/9.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "XXOrderDetailTableViewController.h"
#import "XXOrderDetail1TableViewCell.h"
#import "XXOrderDetail2TableViewCell.h"
#import "XXOrderDetail3TableViewCell.h"
#import "XXOrderDetail4TableViewCell.h"
#import "XXOrderGoodsTableViewCell.h"
#import "PaymentViewController.h"
#import "XXAppraiseTableViewController.h"
@interface XXOrderDetailTableViewController ()
{
    NSDictionary *_goodsDic;
    NSArray *_goodsArray;
}
@end

@implementation XXOrderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    _goodsDic = [NSDictionary dictionary];
    _goodsArray = [NSArray array];
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setUpRefresh];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kSCREEN_WIDTH - (90 + i * 85), kSCREEN_HEIGHT - 110, 80, 32);
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = i + 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1){
//        if (_goodsArray.count) {
           return 2 + _goodsArray.count;
//        }else{
//            return 0;
//        }
        
    }else{
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 12;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 93;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 45;
        }else if (indexPath.row == _goodsArray.count + 1){
        
            return 33;
        }else{
           return 100;
        }
    
    }else{
        if (indexPath.row == 2) {
            return 63;
        }else{
            return 45;
        }
    }


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 订单号
            XXOrderDetail1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail1TableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderDetail1TableViewCell" owner:self options:nil] lastObject];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",_goodsDic[@"order_sn"]];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.typeStr.text = _goodsDic[@"order_status_desc"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
          // 地址
            XXOrderDetail2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail2TableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderDetail2TableViewCell" owner:self options:nil] lastObject];
            }
            cell.name.text = _goodsDic[@"consignee"];
            cell.address.text = [NSString stringWithFormat:@"收货地址: %@",_goodsDic[@"address"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 店铺
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gg"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gg"];
            }
            
            cell.textLabel.text = _goodsDic[@"store_name"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == _goodsArray.count + 1){
            // 联系卖家
//            XXOrderDetail3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail3TableViewCell"];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderDetail3TableViewCell" owner:self options:nil] lastObject];
//            }
//            [cell.contactSeller addTarget:self action:@selector(contactSeller) forControlEvents:UIControlEventTouchUpInside];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail3TableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXOrderDetail3TableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            // 商品
            XXOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderGoodsTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderGoodsTableViewCell" owner:self options:nil]lastObject];
            }
            CGRect frame = cell.goodsName.frame;
            frame.size.width = kSCREEN_WIDTH - 15 - cell.price.width  - cell.goodsName.origin.x;
            cell.goodsName.frame = frame;
//            if (![_goodsArray[indexPath.row - 1][@"original_img"] isEqual:[NSNull null]]) {
//                 [cell.img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_goodsArray[indexPath.row - 1][@"original_img"])]];
//            }
            
            if (_goodsArray.count) {
                if (![_goodsArray[indexPath.row - 1][@"original_img"] isEqual:[NSNull null]]) {
                    NSString *imgStr = _goodsArray[indexPath.row - 1][@"original_img"];
                    if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                        imgStr = IMG_APPEND_PREFIX(imgStr);
                    }
                    [cell.img sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
                }
                
                cell.goodsName.text = _goodsArray[indexPath.row - 1][@"goods_name"];
                cell.price.text = _goodsArray[indexPath.row - 1][@"goods_price"];
                cell.goodsCount.text = [NSString stringWithFormat:@"x %@",_goodsArray[indexPath.row - 1][@"goods_num"]];

            }
           
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

           

        }
        
    }else{
        if (indexPath.row == 2) {
            // 合计
            XXOrderDetail4TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail4TableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderDetail4TableViewCell" owner:self options:nil] lastObject];
            }
            
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"合计: ¥%@",_goodsDic[@"order_amount"]]];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor blackColor]
             
                                  range:NSMakeRange(0, 3)];
            
            
            cell.totalPrice.attributedText = AttributedStr;

            
            
//            cell.totalPrice.text = [NSString stringWithFormat:@"合计: ¥%@",_goodsDic[@"order_amount"]];
            
            NSString *str=_goodsDic[@"add_time"];//时间戳
            NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            
            cell.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",currentDateStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else{
            
            XXOrderDetail1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderDetail1TableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXOrderDetail1TableViewCell" owner:self options:nil] lastObject];
            }
           

            
            
            
            
            if (indexPath.row == 0) {
                // 支付方式
                cell.textLabel.text = @"支付方式";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.typeStr.text = _goodsDic[@"pay_name"];
                cell.typeStr.textColor = [UIColor blackColor];
            }else{
            // 商品总额
                cell.textLabel.text = @"商品总额";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.typeStr.text = [NSString stringWithFormat:@"¥%@",_goodsDic[@"goods_price"]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
            
        }
    }
    
}


// 下拉刷新
-(void)setUpRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    [self.tableView.header beginRefreshing];
    
}

- (void)createData{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"order_id":_order_id};
    [RequestData requestWithUrl:GET_ORDER_DETAIL para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       
        if ([dic[@"code"] doubleValue] == 0 ) {
            
            _goodsDic = dic[@"data"];
            _goodsArray = _goodsDic[@"goods_list"];
            [self setBtnTitle];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}

// 评价等
- (void)order:(UIButton *)sender{
    
    if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待评价"]) {
        
//        [btn1 setTitle:@"再次购买" forState:UIControlStateNormal];
//        [btn2 setTitle:@"评价" forState:UIControlStateNormal];
//        [btn3 setTitle:@"删除订单" forState:UIControlStateNormal];
        
        if (sender.tag == 1) {
            
        }else if (sender.tag == 2){
            XXAppraiseTableViewController *appraise = [[XXAppraiseTableViewController alloc] init];
            appraise.goodsDic = _goodsDic;
            [self.navigationController pushViewController:appraise animated:YES];
        }else{
            [self cancelOrder];
        }
        
        
    }else if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待收货"]){
//        [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
//        btn2.hidden = YES;
//        btn3.hidden = YES;
        [self confirmReceipt];
    }else if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待支付"]){
//        [btn1 setTitle:@"支付" forState:UIControlStateNormal];
//        [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
//        btn3.hidden = YES;
        if (sender.tag == 1) {
            PaymentViewController *pay = [[PaymentViewController alloc] init];
            pay.payMoney = _goodsDic[@"order_amount"];
            [self.navigationController pushViewController:pay animated:YES];
        }else if (sender.tag == 2){
            [self cancelOrder];
        }

    }


}
// 联系卖家
- (void)contactSeller{

}

- (void)setBtnTitle{
    UIButton *btn1 = [self.view viewWithTag:1];
    UIButton *btn2 = [self.view viewWithTag:2];
    UIButton *btn3 = [self.view viewWithTag:3];
    [btn1 setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
    [btn2 setTitleColor:RGB(69, 69, 69) forState:UIControlStateNormal];
    [btn3 setTitleColor:RGB(69, 69, 69) forState:UIControlStateNormal];
    
    btn1.layer.borderWidth = 1;
    btn2.layer.borderWidth = 1;
    btn3.layer.borderWidth = 1;
    
    btn1.layer.borderColor = kNavBarThemeColor.CGColor;
    btn2.layer.borderColor = RGB(213, 212, 215).CGColor;
    btn3.layer.borderColor = RGB(213, 212, 215).CGColor;
    
    btn1.layer.cornerRadius = 2.5;
    btn2.layer.cornerRadius = 2.5;
    btn3.layer.cornerRadius = 2.5;
    
    if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待评价"]) {
        
        [btn1 setTitle:@"再次购买" forState:UIControlStateNormal];
        [btn2 setTitle:@"评价" forState:UIControlStateNormal];
        [btn3 setTitle:@"删除订单" forState:UIControlStateNormal];
        
    }else if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待收货"]){
     [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
        btn2.hidden = YES;
        btn3.hidden = YES;
    }else if ([_goodsDic[@"order_status_desc"] isEqualToString:@"待支付"]){
        [btn1 setTitle:@"支付" forState:UIControlStateNormal];
        [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
        btn3.hidden = YES;
    
    }else{
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
    }
    
    
   
    
    
    
    
}

// 取消订单
- (void)cancelOrder{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"order_id":_order_id};
    [RequestData requestWithUrl:CANCEL_ORDER para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [self.tableView.header beginRefreshing];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error){
        
    }];
    
    
}

// 收货确认
- (void)confirmReceipt{
    NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"order_id":_order_id};
    [RequestData requestWithUrl:ORDER_CONFIRM para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            [self.tableView.header beginRefreshing];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
    
}

@end
