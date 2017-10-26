//  XXTaoTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXTaoTableViewController.h"
#import "XXTaoHeaderView.h"
#import "XXTaoTableViewCell.h"
#import "XXTao.h"
#import "GoodsDeailController.h"
#import "QZKRequestData.h"

@interface XXTaoTableViewController ()<GoodsManageCellDelegate,UIGestureRecognizerDelegate>{
    XXTaoHeaderView *_headerView;
    MJRefreshNormalHeader *_header;
    NSMutableArray *_id;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * goods_id;
@end

@implementation XXTaoTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRefresh];
    self.title = @"淘物";
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"XXTaoHeaderView" owner:self options:nil]lastObject];
    self.tableView.tableHeaderView = _headerView;
    self.navigationController.navigationBar.barTintColor = kNavBarThemeColor;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source
-(void)setUpRefresh{
    
//    [QZKRequestData postDataNetWorkingWitData:nil success:^(id netReturn) {
//        
//        if ([netReturn[@"data"] integerValue] == 0) {
    
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
            self.tableView.header = _header;
            _header.stateLabel.hidden = YES;
            _header.lastUpdatedTimeLabel.hidden = YES;
            [self.tableView.header beginRefreshing];
//        }
//        else
//        {
//            
//        }
//    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXTaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXTaoTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXTaoTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bmgView.layer.cornerRadius = 7.5;
    cell.bmgView.layer.borderWidth = 1;
    cell.bmgView.layer.borderColor = RGB(224, 224, 224).CGColor;
    cell.cart.layer.cornerRadius = 12.5;
    
    cell.delegate = self;

    
    if (self.dataArray.count > 0) {
        
        cell.tao = self.dataArray[indexPath.row];

    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 15)];
        return view;
        
    }
    return nil;
    
}

- (void)loadNewData{
    
    [[Business sharedInstance] newGoods:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        
                    if ([data[@"code"] integerValue] == 0) {
                        
                        [self addData];
                        
                        
                        _dataArray = [XXTao mj_objectArrayWithKeyValuesArray:data[@"data"]];
                        
                        
//                        [SARUserInfo saveContacts:data];
                        
                        [self.tableView reloadData];
                        [self.tableView.header endRefreshing];
                        
        
                    }else if([data[@"code"] integerValue] == -2){
        
                        [[HUDHelper sharedInstance] tipMessage:msg];
                    }

        [self.tableView.header endRefreshing];
        
                } fail:^(NSString *error) {
                    
                    [self.tableView.header endRefreshing];
                    
                }];
    

}

- (void)addData{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [SARUserInfo userId];
    
    [mgr POST:GOODS_STYLISH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSMutableArray *arrImage = [NSMutableArray array];
        NSMutableArray *arrName = [NSMutableArray array];
        NSMutableArray *arrPrice = [NSMutableArray array];
        

        self.goods_id = [NSMutableArray array];
        
        if (code == 0) {
            NSArray *arr = responseObject[@"data"];
            for (int i = 0; i < arr.count; i ++) {
                NSString *arrImg = responseObject[@"data"][i][@"original_img"];
                [arrImage addObject:arrImg];
                [arrName addObject:responseObject[@"data"][i][@"goods_name"]];
                [arrPrice addObject:responseObject[@"data"][i][@"shop_price"]];
                [self.goods_id addObject:responseObject[@"data"][i][@"goods_id"]];

            }
//            [arrImage addObject:@""];
//            [arrName addObject:@""];
//            [arrPrice addObject:@""];
            
            [_headerView.oneImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PREFIX,arrImage[0]]] placeholderImage:[UIImage imageNamed:@"iconPlaceholder"]];
            [_headerView.twoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PREFIX,arrImage[1]]] placeholderImage:[UIImage imageNamed:@"iconPlaceholder"]];
            [_headerView.threeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PREFIX,arrImage[2]]] placeholderImage:[UIImage imageNamed:@"iconPlaceholder"]];
            
            _headerView.oneName.text = arrName[0];
            _headerView.twoName.text = arrName[1];
            _headerView.threeName.text = arrName[2];
            _headerView.onePrice.text= [NSString stringWithFormat:@"¥%@",arrPrice[0]];
            _headerView.twoPrice.text= [NSString stringWithFormat:@"¥%@",arrPrice[1]];
            _headerView.threePrice.text= [NSString stringWithFormat:@"¥%@",arrPrice[2]];
            
            
          
            _headerView.threeImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeclick)];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            tapGesture.delegate = self;
            [_headerView.threeImage addGestureRecognizer:tapGesture];
            
            _headerView.twoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoclick)];
            tapGestur.numberOfTapsRequired = 1;
            tapGestur.numberOfTouchesRequired = 1;
            tapGestur.delegate = self;
            [_headerView.twoImage addGestureRecognizer:tapGestur];
            
            _headerView.oneImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneclick)];
            tapGestu.numberOfTapsRequired = 1;
            tapGestu.numberOfTouchesRequired = 1;
            tapGestu.delegate = self;
            [_headerView.oneImage addGestureRecognizer:tapGestu];
        
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
   
    }];
    

}



- (void)GoodsManageCell:(XXTaoTableViewCell *)cell didClickDelete:(NSIndexPath *)indexPat{

    XXTao *model = self.dataArray[indexPat.row];
    
     [[Business sharedInstance] goodsAddCartUid:[SARUserInfo userId] goods_id:model.goods_id goods_num:@"1" succ:^(NSString *msg, id data) {
        
        if ([data[@"code"] integerValue] == 0) {
            
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"添加购物车成功"];

        }
        
    } fail:^(NSString *error) {
        
    }];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXTao *model = self.dataArray[indexPath.row];

    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id  =   model.goods_id ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)oneclick{
    
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id = self.goods_id[0];
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)twoclick{
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id = self.goods_id[1];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)threeclick{
    GoodsDeailController *vc = [[GoodsDeailController alloc] init];
    vc.goods_id = self.goods_id[2];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
