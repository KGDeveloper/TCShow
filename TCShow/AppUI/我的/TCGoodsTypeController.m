

//
//  TCGoodsTypeController.m
//  TCShow
//
//  Created by tangtianshi on 17/1/6.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCGoodsTypeController.h"
#import "TCGoodsTypeModel.h"
#import "AFHTTPRequestOperation.h"
#import "NewGoodsDetaileModel.h"
#import "LMShopClassViewCell.h"

@interface TCGoodsTypeController ()
@property(nonatomic,strong)NSMutableArray * typeArray;

@property(nonatomic,strong)NewGoodsDetaileModel *model;

@end

@implementation TCGoodsTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    _typeArray = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:SHOP_CLASS parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (code == 0) {
            
            NSArray * tmpArray = [responseObject valueForKey:@"data"];
            
            for (int i = 0; i < tmpArray.count; i++) {
                
                NSDictionary *dic = tmpArray[i];
                
//                _model = [[NewGoodsDetaileModel alloc]initWithDiction:dic];
                
                [_typeArray addObject:dic];
                
            }
            
            [self.tableView reloadData];
            
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请求出错，请检查网络！"];
        
    }];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}


-(void)backItemClick{
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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _typeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _typeArray[indexPath.row];
    
    cell.textLabel.text = dic[@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _typeArray[indexPath.row];
    [self.typeDelegate releaseGoodsUid:dic[@"id"] goodsName:dic[@"name"]];
     
    [self.navigationController popViewControllerAnimated:YES];
}

@end
