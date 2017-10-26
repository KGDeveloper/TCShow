//
//  XXDetailAfterViewController.m
//  TCShow
//
//  Created by  m, on 2017/9/4.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "XXDetailAfterViewController.h"
#import "MangerListTableViewCell.h"
#import "MangerListModel.h"
#import "Macro.h"

#define KSCREEN_Width [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_Height [[UIScreen mainScreen] bounds].size.height

@interface XXDetailAfterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *finishBut;//完成订单
    UIButton *waitBut;//待发货
    UIButton *allBut;//所有订单
    UITableView *listTabelVew;
    NSMutableArray *listArr;//数据源
    UIView *wuLiuView;//发货管理
    NSString *wuliuId;
    NSString *code;
}

@end

@implementation XXDetailAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看订单";
    self.view.backgroundColor = RGB(241, 239, 250);
    
    [self UICreate];
    [self createTableView];
    
}



- (void)UICreate
{
    //代发货
    waitBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_Width/3, 50)];
    waitBut.backgroundColor = [UIColor grayColor];
    [waitBut setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [waitBut setTitle:@"待发货" forState:UIControlStateNormal];
    [waitBut addTarget:self action:@selector(waitButTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waitBut];
    
    //已发货
    finishBut = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_Width/3, 64, KSCREEN_Width/3, 50)];
    finishBut.backgroundColor = [UIColor grayColor];
    [finishBut setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [finishBut setTitle:@"已发货" forState:UIControlStateNormal];
    [finishBut addTarget:self action:@selector(finishButTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBut];
    
    //全部
    allBut = [[UIButton alloc]initWithFrame:CGRectMake((KSCREEN_Width/3)*2, 64, KSCREEN_Width/3, 50)];
    allBut.backgroundColor = [UIColor grayColor];
    [allBut setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [allBut setTitle:@"全部" forState:UIControlStateNormal];
    [allBut addTarget:self action:@selector(allButTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBut];
    
    if ([self.givename isEqualToString:@"售后"]) {
        
        [self allButTouch:allBut];
        finishBut.hidden = YES;
        waitBut.hidden = YES;
    }
    
    if (_sendTag == 0)
    {
        [self waitButTouch:waitBut];
        
        waitBut.titleLabel.textColor = [UIColor whiteColor];
        finishBut.titleLabel.textColor = [UIColor blackColor];
        allBut.titleLabel.textColor = [UIColor blackColor];
        
    }
    else if (_sendTag == 1)
    {
        [self finishButTouch:finishBut];
        
        finishBut.titleLabel.textColor = [UIColor whiteColor];
        waitBut.titleLabel.textColor = [UIColor blackColor];
        allBut.titleLabel.textColor = [UIColor blackColor];
        
    }else if (_sendTag == 2)
    {
        
        [self allButTouch:allBut];
        
        allBut.titleLabel.textColor = [UIColor whiteColor];
        finishBut.titleLabel.textColor = [UIColor blackColor];
        waitBut.titleLabel.textColor = [UIColor blackColor];
    }
    
}


- (void)finishButTouch:(UIButton *)sender{
    
    waitBut.titleLabel.textColor = [UIColor blackColor];
    finishBut.titleLabel.textColor = [UIColor whiteColor];
    allBut.titleLabel.textColor = [UIColor blackColor];
    
    
    listArr = [NSMutableArray array];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:[SARUserInfo userId] forKey:@"uid"];
    [dic setObject:@"FINISH" forKey:@"type"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:MYORDER_ORDER parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tmp = responseObject[@"data"];
        for (int i = 0; i < tmp.count; i++) {
            
            NSDictionary *dic = tmp[i];
            [listArr addObject:dic];
        }
        [listTabelVew reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

- (void)waitButTouch:(UIButton *)sender{
    

    waitBut.titleLabel.textColor = [UIColor whiteColor];
    finishBut.titleLabel.textColor = [UIColor blackColor];
    allBut.titleLabel.textColor = [UIColor blackColor];
    
    listArr = [NSMutableArray array];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:[SARUserInfo userId] forKey:@"uid"];
    [dic setObject:@"WAITSEND" forKey:@"type"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:MYORDER_ORDER parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tmp = responseObject[@"data"];
        for (int i = 0; i < tmp.count; i++) {
            
            NSDictionary *dic = tmp[i];
            [listArr addObject:dic];
        }
        [listTabelVew reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

- (void)allButTouch:(UIButton *)sender{
    
    waitBut.titleLabel.textColor = [UIColor blackColor];
    finishBut.titleLabel.textColor = [UIColor blackColor];
    allBut.titleLabel.textColor = [UIColor whiteColor];

    
    listArr = [NSMutableArray array];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:[SARUserInfo userId] forKey:@"uid"];
    [dic setObject:@"0" forKey:@"p"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:MYORDER_SELL_AFTER parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tmp = responseObject[@"data"];
        for (int i = 0; i < tmp.count; i++) {
            
            NSDictionary *dic = tmp[i];
            [listArr addObject:dic];
        }
        
        [listTabelVew reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
        
    }];
    
    
}

- (void)createTableView
{
    listTabelVew = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, KSCREEN_Width, KSCREEN_Height - 114) style:UITableViewStylePlain];
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
            
             dic= listArr[indexPath.row];
            
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
            cell.shopCount.text = [NSString stringWithFormat:@"X%@",model.goods_num];
            
            cell.wuliuLabel.text = [NSString stringWithFormat:@"物流编号：%@ \n物流公司：%@",model.shipping_code,model.shipping_name];
            
            
            cell.strString = ^(NSString *strString){
            
                [self cellButtonTouchUp:strString];
            
            };
            if ([model.status isEqualToString:@"审核通过"]){
                
                [cell.myButton setTitle:@"审核通过" forState:UIControlStateNormal];
                cell.myButton.tag = model.ID.intValue;
                
                cell.sendStatus = ^(NSString *sendStatus) {
                    
                    [listTabelVew reloadData];
                };
                    
               
            }
            else if ([model.order_status_desc isEqualToString:@"待发货"]){
                
                [cell.myButton setTitle:@"设置发货" forState:UIControlStateNormal];
                cell.myButton.tag = model.order_id.intValue;
                
            }
            else if ([model.status isEqualToString:@"审核"]){
                
                [cell.myButton setTitle:@"审核" forState:UIControlStateNormal];
                cell.myButton.tag = model.ID.intValue;
                
                cell.sendStatus = ^(NSString *sendStatus) {
                    
                    [listTabelVew reloadData];
                };
            }
        }
        
        
        
    }
    
    return cell;
}

- (void)cellButtonTouchUp:(NSString *)strString
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加物流信息" message: @"请输入物流信息"preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入物流公司";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入物流单号";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *wuliu = alert.textFields.firstObject;
        UITextField *gongsi = alert.textFields.lastObject;
        gongsi.keyboardType = UIKeyboardTypeDefault;
        wuliu.keyboardType = UIKeyboardTypePhonePad;
        
        if ([wuliu.text isEqualToString:@""] && [gongsi.text isEqualToString:@""]) {
            
            [[HUDHelper sharedInstance] tipMessage:@"请输入物流公司名称或物流单号"];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:[SARUserInfo userId] forKey:@"uid"];
        [dic setValue:strString forKey:@"order_id"];
        [dic setValue:wuliu.text forKey:@"shipping_code"];
        [dic setValue:gongsi.text forKey:@"shipping_name"];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        [manger POST:MYORDER_SHIPPING parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [listTabelVew reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
        
    }];
    
    UIAlertAction *canalAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    
    
    [alert addAction:okAction];
    [alert addAction:canalAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
