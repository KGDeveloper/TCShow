//
//  XXAfterSaleManagementTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/21.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXAfterSaleManagementTableViewController.h"
#import "MangerListTableViewCell.h"
#import "MangerListModel.h"
#import "Macro.h"

#define KSCREEN_Width [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_Height [[UIScreen mainScreen] bounds].size.height


@interface XXAfterSaleManagementTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *listTabelVew;
    NSMutableArray *listArr;
    NSInteger myI ;
    NSString *returnID;
}

@end

@implementation XXAfterSaleManagementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"售后管理";
    self.view.backgroundColor = RGB(241, 239, 250);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listArr = [NSMutableArray array];
    myI = 0;
    
    if ([_giveStatus isEqualToString:@"商家"]) {
        
        [self creatUserData];
    }
    else
    {
        [self creatData];
    }
    
    
    [self createTableView];
}

- (void) creatData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
    [dic setValue:@"1" forKey:@"p"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:ORDER_RETURN_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tmp = responseObject[@"data"];
        
        
        for (int i = 0; i <tmp.count; i++) {
            
            NSMutableDictionary *myDic = [NSMutableDictionary dictionary];
            
            myDic = tmp[i];
            
            [listArr addObject:myDic];
            
            [listTabelVew reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

- (void) creatUserData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
    [dic setValue:@"1" forKey:@"p"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:MYORDER_SELL_UP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tmp = responseObject[@"data"];
        
        for (int i = 0; i <tmp.count; i++) {
            
            NSMutableDictionary *myDic = [NSMutableDictionary dictionary];
            
            myDic = tmp[i];
            
            [listArr addObject:myDic];
            
            [listTabelVew reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

#pragma mark - Table view data source
    
- (void)createTableView
{
    listTabelVew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_Width, KSCREEN_Height - 64) style:UITableViewStylePlain];
    listTabelVew.delegate = self;
    listTabelVew.dataSource = self;
    listTabelVew.rowHeight = 160.0f;
    UIView *footView = [[UIView alloc]init];
    listTabelVew.tableFooterView = footView;
    [self.view addSubview:listTabelVew];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return listArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MangerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MangerListTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MangerListTableViewCell" owner:self options:nil] lastObject];
        if (listArr.count > 0) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = listArr[myI];
            
            myI = myI + 1;
            
            MangerListModel *model = [[MangerListModel alloc]initWithDictionary:dic];
            cell.shopName.text = model.goods_name;
            NSString *imgStr = model.original_img;
            if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
                imgStr = IMG_APPEND_PREFIX(imgStr);
            }
            [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
            cell.logistics.text = [NSString stringWithFormat:@"订单编号：%@",model.order_sn];
            cell.count.text = [NSString stringWithFormat:@"共%@ 合计%@",model.goods_price,model.goods_num];
            cell.state.text = model.order_status_desc;
            
                [cell.myButton setTitle:model.status forState:UIControlStateNormal];
            
            cell.shopCount.text = [NSString stringWithFormat:@"X%@",model.goods_num];
            
            
            
            cell.strString = ^(NSString *sendStr) {
                
                returnID = model.order_id;
                
                [self AlertViewMessage:@"提示" buttonTitle:@"添加" buttonStitle:@"取消"];
            };
            
            
            
            
            cell.wuliuLabel.text = [NSString stringWithFormat:@"物流编号：%@ \n物流公司：%@",model.shipping_code,model.shipping_name];
            
            
        }
        
    }
    
    return cell;
}

- (void) AlertViewMessage:(NSString *)message buttonTitle:(NSString *)title buttonStitle:(NSString *)stitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入物流公司";
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入物流单号";
        
    }];
    
    UIAlertAction *but = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *wuli = [alert.textFields firstObject];
        UITextField *dindan = [alert.textFields lastObject];
        
        [self getWuliuAndDingdan:wuli.text dingdan:dindan.text];
        
    }];
    
    UIAlertAction *sbut = [UIAlertAction actionWithTitle:stitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:but];
    [alert addAction:sbut];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void) getWuliuAndDingdan:(NSString *)wuli dingdan:(NSString *)dingdan
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:returnID forKey:@"id"];
    [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
    [dic setValue:wuli forKey:@"shipping_name"];
    [dic setValue:dingdan forKey:@"shipping_code"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:ORDER_RETURN_WL_ADD parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
}


@end
