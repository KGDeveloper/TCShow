//
//  ConfirmOrderViewController.m
//  FineQuality
//
//  Created by tangtianshi on 16/6/2.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "Confirm_adressCell.h"
#import "BusinessTableViewCell.h"
#import "GoodsListTableViewCell.h"
#import "DistributionViewController.h"
//#import "ConfirmNumsTableViewCell.h"
#import "ConfirmDistributionTableViewCell.h"
#import "ConfirmLeaveTableViewCell.h"
#import "ConfirmCombinedTableViewCell.h"
#import "NoAddressTableViewCell.h"
#import "SelectAdressViewController.h"
#import "NewAddressViewController.h"
#import "ShoppingModel.h"
#import "MJRefresh.h"
#import "PaymentViewController.h"
#import "XXOrderGoodsTableViewCell.h"
@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,DistributionViewControllerDelegate,SelectAdressViewControllerDelegate>
{
    UITableView *_tableView;
    UIView *_view;
    UILabel *_title;
    NSString *_distributionString;
    NSString *_insuranceString;
    NSDictionary *_addressDic;
    NSDictionary *_priceDic;
    UILabel *_price;    // 总价label
    NSString *_leaveString;
    
    NSArray *goodsArray;

}
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认订单";
    _distributionString = @"未选择";
    _insuranceString = @"未选择";
    _dataDic = [NSDictionary dictionary];
    
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 20, 15);
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
//    backImageView.image = [UIImage imageNamed:@"返回"];
//    [back addSubview:backImageView];
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 120, 0, 120, 50)];
    [confirm setTitle:@"提交订单" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = kNavBarThemeColor;
    [bottomView addSubview:confirm];
    [confirm addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 210, 0, 80, 50)];
    
    _price.textColor = kNavBarThemeColor;
    _price.font = [UIFont systemFontOfSize:17];
    _price.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_price];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 270, 0, 60, 50)];
    lable.textColor = [UIColor blackColor];
    lable.text = @"合计：";
    lable.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:lable];
    
//    [self obtainDefaultAddress];
    [self createUI];
    
}
- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //设置分割线的风格
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tableview没有数据的时候不显示线
    _tableView.tableFooterView = [[UIView alloc] init];
    
   [self setUpRefresh];


}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + _cartArray.count;   // 每家店是一个分组  + 地址是第一个分组

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (_isCart) {
        goodsArray = [NSArray arrayWithArray:_cartArray[section - 1][@"data"]];
        
            return 2 + goodsArray.count;
        }else{
            return 7; // 直接购买
        }
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
    return 15;
    }

}
// 一个商品就是7个cell  + i
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_isCart) {
    
    if (indexPath.section != 0) {
        goodsArray = [NSArray arrayWithArray:_cartArray[indexPath.section - 1][@"data"]];
    }
    
        if (indexPath.section == 0) {
            return 110; //  地址
        }else if (indexPath.row == 0){
            return 45; // 店名
            
        }else if (indexPath.row > goodsArray.count){  // 判断商品数量  假设1件
            
            
            return 45;  // 最后一部分
            
        }else{
            return 100;  //   商品部 分
            
        }
//    }else{
//    
//        if (indexPath.section == 0) {
//            return 125; //  地址
//        }else if (indexPath.row == 0){
//            return 45; // 店名
//            
//        }else if (indexPath.row > 1){  // 判断商品数量  假设1件
//            
//            
//            return 45;  // 最后一部分
//            
//        }else{
//            return 100;  //   商品部 分
//            
//        }
//    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*"DistributionViewController.h"
     "ConfirmNumsTableViewCell.h"
     "ConfirmDistributionTableViewCell.h"
     "ConfirmLeaveTableViewCell.h"
     "ConfirmCombinedTableViewCell.h"*/
    if (indexPath.section != 0) {
       goodsArray = [NSArray arrayWithArray:_cartArray[indexPath.section - 1][@"data"]];
    }
    
    
    
//    if (_isCart) {
        // 存在购物车
        if (indexPath.section == 0) {  // 地址
            if(![_addressDic isEqual:[NSNull null]]){
                Confirm_adressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Confirm_adressCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"Confirm_adressCell" owner:self options:nil]lastObject];
                }
                cell.consignee.text = _addressDic[@"consignee"];
                cell.phone.text = _addressDic[@"mobile"];
                cell.address.text = _addressDic[@"address"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else{
                
                NoAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAddressTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"NoAddressTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }
            
        }else if (indexPath.row == 0){  // 店名
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = [[Business sharedInstance] is_NullStringChange:_cartArray[indexPath.section - 1][@"stores_name"]];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
//            else if (indexPath.row == 1 + goodsArray.count) {  // 配送
//            ConfirmDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmDistributionTableViewCell"];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmDistributionTableViewCell" owner:self options:nil]lastObject];
//            }
//            cell.returnText.text = _distributionString;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//            
//        }
//        else if (indexPath.row == goodsArray.count + 2) {  // 运费险
//            
//            ConfirmDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmDistributionTableViewCell"];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmDistributionTableViewCell" owner:self options:nil]lastObject];
//            }
//            cell.distributionText.text = @"优惠";
//            cell.returnText.text = _insuranceString;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//
//            
//        }
            else if (indexPath.row == goodsArray.count + 1) {  // 留言
            ConfirmLeaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmLeaveTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmLeaveTableViewCell" owner:self options:nil]lastObject];
            }
            _leaveString =  cell.leave.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            }
//        else if (indexPath.row == goodsArray.count + 4){
//                // 总计
//                ConfirmCombinedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmCombinedTableViewCell"];
//                if (!cell) {
//                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmCombinedTableViewCell" owner:self options:nil]lastObject];
//                }
//                cell.number.text = [NSString stringWithFormat:@"共%ld件商品",(unsigned long)goodsArray.count];
//                cell.totalPrice.text = [NSString stringWithFormat:@"x %@",_cartArray[indexPath.section - 1][@"data"][0][@"goods_price"]];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//
//            }
            else {
                
                
               // 商品
                XXOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderGoodsTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"XXOrderGoodsTableViewCell" owner:self options:nil]lastObject];
                }
                /*img;
                 *goodsName;
                 *classification; // 分类
                 *price;
                 *goodsCount;*/
                NSString *imgStr = goodsArray[indexPath.row - 1][@"original_img"];
                if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                    imgStr = IMG_APPEND_PREFIX(imgStr);
                }
                [cell.img sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
                cell.classification.hidden = YES;
                cell.goodsName.text = goodsArray[indexPath.row - 1][@"goods_name"];
                cell.goodsCount.text = [NSString stringWithFormat:@"x %@",goodsArray[indexPath.row - 1][@"goods_num"]];
                cell.price.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
//    }
//else{
// 直接购买
    /*
        if (indexPath.section == 0) {  // 地址
            if (_addressDic) {
                Confirm_adressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Confirm_adressCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"Confirm_adressCell" owner:self options:nil]lastObject];
                }
                
                cell.consignee.text = _addressDic[@"consignee"];
                cell.phone.text = _addressDic[@"mobile"];
                cell.address.text = _addressDic[@"address"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else{
                
                NoAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAddressTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"NoAddressTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }

        }else if (indexPath.row == 0){  // 店名
            BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if(indexPath.row == 1){ // 商品
            NSArray *goodsArray = [NSArray arrayWithArray:cartListDic[@"data"]];
            
            // 商品
            XXOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXOrderGoodsTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"XXOrderGoodsTableViewCell" owner:self options:nil]lastObject];
            }
            /*img;
             *goodsName;
             *classification; // 分类
             *price;
             *goodsCount;
            
            [cell.img sd_setImageWithURL:[NSURL URLWithString:goodsArray[indexPath.row - 1][@"original_img"]]];
            cell.classification.hidden = YES;
            cell.goodsName.text = goodsArray[indexPath.row - 1][@"goods_name"];
            cell.goodsCount.text = goodsArray[indexPath.row - 1][@"goods_num"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 2) {  // 数量
            ConfirmNumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmNumsTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmNumsTableViewCell" owner:self options:nil]lastObject];
            }
            cell.number.text = [NSString stringWithFormat:@"%ld",(long)_nums];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
         }else if(indexPath.row == 5) {  // 留言
            ConfirmLeaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmLeaveTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmLeaveTableViewCell" owner:self options:nil]lastObject];
            }
            _leaveString =  cell.leave.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            }else if (indexPath.row == 6){  // 总计
                ConfirmCombinedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmCombinedTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmCombinedTableViewCell" owner:self options:nil]lastObject];
                }
                double total = (double)_nums * [_goodsDic[@"shop_price"] doubleValue];
                cell.totalPrice.text = [NSString stringWithFormat:@"¥%.2f",total];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

                
            }else if(indexPath.row == 3){
                // 配送
                ConfirmDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmDistributionTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmDistributionTableViewCell" owner:self options:nil]lastObject];
                }
                cell.returnText.text = _distributionString;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else {
                // 运费险
                ConfirmDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmDistributionTableViewCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmDistributionTableViewCell" owner:self options:nil]lastObject];
                }
                cell.returnText.text = _insuranceString;
                cell.distributionText.text = @"运费险";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
               }
        }
     */

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        goodsArray = [NSArray arrayWithArray:_cartArray[indexPath.section - 1][@"data"]];
    }
    
    if (indexPath.section == 0) {
        // 选择收货地址or新建地址
        if (_addressDic) {
            SelectAdressViewController *select = [[SelectAdressViewController alloc] init];
            select.delegate = self;
            [self.navigationController pushViewController:select animated:YES];

        }else{
            NewAddressViewController *new = [[NewAddressViewController alloc] init];
            [self.navigationController pushViewController:new animated:YES];
            
        }
        
    }
    DistributionViewController *distribution = [[DistributionViewController alloc] init];
    distribution.delegate = self;
    distribution.distributionSection = indexPath.section;
    self.definesPresentationContext= YES; //self is presenting view controller
    distribution.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    distribution.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    
  //  if (_isCart) {
    
//        if (indexPath.row == 1 + goodsArray.count) {
            
//        distribution.selectType = @"邮费";
//            [self presentViewController:distribution animated:YES completion:nil];
            
//        }else if (indexPath.row == goodsArray.count + 2){
//         distribution.selectType = @"优惠";
//           [self presentViewController:distribution animated:YES completion:nil];
        
//        }
 //   }else{
    /*
        if (indexPath.row == 3) {
           distribution.selectType = @"配送方式";
            [self presentViewController:distribution animated:YES completion:nil];
            
        }else if (indexPath.row == 4){
            
         distribution.selectType = @"运费险";
            [self presentViewController:distribution animated:YES completion:nil];
        }
    
    }
     */
}

- (void)back{
//    if (_isCart) {
         [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }

}

/**配送方式代理*/
- (void)returnType:(NSString *)type title:(NSString *)title section:(NSInteger)section{
    if (section != 0) {
        goodsArray = [NSArray arrayWithArray:_cartArray[section - 1][@"data"]];
    }
    NSInteger i;
    if ([type isEqualToString:@"邮费"]) {
        _distributionString = title;
      //  if (_isCart) {
            i = 1 + goodsArray.count;
      //  }else{
      //      i = 3;
      //  }
    
    }else {
        _insuranceString = title;
       // if (_isCart) {
            i = goodsArray.count + 2;
       // }else{
          //  i = 4;
        //}
    
    }
    
    // 刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:section];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}

/**number的代理*/
/*- (void)btn:(UITableViewCell *)cell tag:(NSInteger)flag{
    if (flag == 33) {
        // +
        _nums ++;
    }else if (flag == 34){
        // -
        if (_nums > 1) {
            _nums --;
        }else{
            _nums = 1;
        }
    
    }
 
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathP=[NSIndexPath indexPathForRow:6 inSection:1];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathP,nil] withRowAnimation:UITableViewRowAnimationNone];

}
 */

#pragma mark - 获取默认收货地址
- (void)obtainDefaultAddress{
//    NSDictionary *para = @{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
//    [RequestData requestWithUrl:JZObtainDefaultAddressURL para:para Complete:^(NSData *data) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//        if ([dic[@"status"] doubleValue] == -2) {
//            // 没有地址
//            _addressDic = nil;
//        }else if ([dic[@"status"] doubleValue] == -1){
//          // 请求错误
//        }else if ([dic[@"status"] doubleValue] == 1){
//            _addressDic = dic[@"result"][0];
//        }
//
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"addressList"]) {
        NSArray * array = [user objectForKey:@"addressList"];
        for (NSDictionary * dic in array) {
            if ([dic[@"is_default"] integerValue] == 1) {
                _addressDic = dic;
                return;
            }
        }
        _addressDic = array[0];
        return;
    }else{
        _addressDic = nil;
        return;
    }
//
//    } fail:^(NSError *error) {
//
//    }];

}

/**选择收货地址的代理*/
- (void)returnAdress:(NSDictionary *)adressDic{
   
    _addressDic = adressDic;

    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark -------------提交订单
- (void)commitOrder{
 //   if (_isCart) {

        NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"address_id":_addressDic[@"address_id"],@"ids":_ids,@"remark":@"submit_order",@"act":@"submit_order"};
        [RequestData requestWithUrl:COMMIT_ORDER para:para Complete:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] doubleValue] == 0) {
                // 提交成功
                PaymentViewController * pay = [[PaymentViewController alloc]init];
                pay.payMoney = _dataDic[@"totalPrice"];
                pay.order_sns = dic[@"data"][@"order_sns"];
                [self.navigationController pushViewController:pay animated:YES];
            }else{
             
            }
        } fail:^(NSError *error) {
            
        }];

   // }else{
    
//        NSDictionary *para = @{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"address_id":_addressDic[@"address_id"],@"goods_id":_goodsDic[@"goods_id"],@"goods_num":[NSString stringWithFormat:@"%ld",_nums],@"goods_spec":_spec,@"act":@"submit_order"};
//        [RequestData requestWithUrl:JZNotCartCommitOrderURL para:para Complete:^(NSData *data) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            if ([dic[@"status"] doubleValue] == 1) {
//                // 提交成功
//                
//
//                
//            }else{
//
//            }
//
//        } fail:^(NSError *error) {
//             
//        }];
    
  //  }
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tableView reloadData];
}

#pragma mark - 获取购物车数据

- (void)createCartData{
    NSDictionary *para;
    NSString *url;
    if (_isCart) {
        
        url = CLEARING_CART;
    para = @{@"user_id":[SARUserInfo userId],@"ids":_ids};
   
    }else{
    
    para = @{@"user_id":[SARUserInfo userId],@"goods_id":_goods_id,@"goods_num":_goods_num};
        url = GOODS_CLEARING_CART;
     
    }
    
    [RequestData requestWithUrl:url para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            
            _dataDic = dic[@"data"];
            _addressDic = _dataDic[@"addressList"];
            _cartArray = _dataDic[@"cartList"];
            _price.text = [NSString stringWithFormat:@"¥ %@",_dataDic[@"totalPrice"]];
            [_tableView.header endRefreshing];
            [_tableView reloadData];
            
        }
    } fail:^(NSError *error) {
        
    }];

}

-(void)setUpRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView.header beginRefreshing];
    
}

- (void)loadData{

    [self createCartData];

}

@end
