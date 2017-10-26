//
//  BrowsHistoryTableController.m
//  TCShow
//
//  Created by tangtianshi on 16/11/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXBrowsHistoryTableController.h"
#import "XXBrowsHistoryTableCell.h"
#import "XXTao.h"
#import "GoodsDeailController.h"
@interface XXBrowsHistoryTableController ()
{
    NSArray *_dataArray;
    NSMutableArray *_dataArrays;
    NSMutableDictionary *_dic;

}
@end

@implementation XXBrowsHistoryTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    _dataArray = [NSArray array];
    self.view.backgroundColor = RGB(241, 239, 250);
    
    if ([_titleStr isEqualToString:@"浏览足记"]) {
        
        UIBarButtonItem * clearButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonClick)];
        self.navigationItem.rightBarButtonItem = clearButtonItem;
        

    }
    
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    [self setUpRefresh];
}


#pragma mark --------清空按钮点击
-(void)clearButtonClick{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArray.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXBrowsHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXBrowsHistoryTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXBrowsHistoryTableCell" owner:self options:nil]lastObject];
    }
    /*img;
     *content;
     *price;
     *stock;  // 库存*/
    [cell.img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_dataArray[indexPath.section][@"original_img"])]];
    cell.content.text = _dataArray[indexPath.section][@"goods_name"];
    cell.price.text = [NSString stringWithFormat:@"¥ %@",_dataArray[indexPath.section][@"shop_price"]];
    cell.stock.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"store_count"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (void)createData{
    
    /**GET_GOODS_COLLECT
     GET_FOOTMARK */
    NSString *url;
    
     if ([_titleStr isEqualToString:@"浏览足记"]) {
         url = GET_FOOTMARK;
     }else{
         url = GET_GOODS_COLLECT;
     }
    
    [RequestData requestWithUrl:url para:@{@"uid":[SARUserInfo userId]} Complete:^(NSData *data) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        _dic = dic;
        
        if ([dic[@"code"] doubleValue] == 0) {
            
            _dataArray = dic[@"data"];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }else if ([dic[@"code"] doubleValue] == -2){
        // 还没有浏览或收藏过
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }else{
        // error
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    }];
    


}

-(void)setUpRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    [self.tableView.header beginRefreshing];
    
}

// 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_titleStr isEqualToString:@"收藏"]) {

        return YES;
    
    }
    
    return NO;
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView setEditing:NO animated:YES];
    
    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"goods_id":_dataArray[indexPath.section][@"goods_id"]};
    [RequestData requestWithUrl:GOODS_FAVORITE_UNFAVORITE para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 1) {
            
            // 刷新当前的section
            [self.tableView.header beginRefreshing];
            [self.tableView reloadData];
            
            
        }else{
        // error
        }
    } fail:^(NSError *error){
        
    }];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    
    vc.goods_id = _dataArray[indexPath.section][@"goods_id"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



@end
