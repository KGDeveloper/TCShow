//
//  LMShopClassViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/21.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMShopClassViewController.h"
#import "SDCycleScrollView.h"
#import "LMShopClassViewCell.h"
#import "LMShopCGoodsViewCell.h"
#import "LMShopModel.h"
#import "SearchViewController.h"
#import "GoodsDeailController.h"

@interface LMShopClassViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *classTableView;
@property (nonatomic, strong) UITableView *goodsTableView;
@property (nonatomic, strong) NSMutableArray *classDataArray;
@property (nonatomic, strong) NSMutableArray *goodsDataArray;


@end

@implementation LMShopClassViewController {
    NSMutableArray *imgData;// 轮播图图片
    NSInteger _pageIndex;
    NSString *_catID;
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"uid"] = [SARUserInfo userId];
//    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    
    
    
    [mgr POST:SHOP_CLASS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            _classDataArray = responseObject[@"data"];
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.classTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    _classDataArray = [NSMutableArray array];
    _goodsDataArray = [NSMutableArray array];
    _catID = @"1";
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 144) delegate:self placeholderImage:IMAGE(@"001")];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:cycleScrollView];
    [[Business sharedInstance] homeCarouselSucc:^(NSString *msg, id data) {
        NSMutableArray *imgAry = [NSMutableArray array];
        imgData = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
        for (NSDictionary *dic in imgData) {
            NSString *imgurl = [dic objectForKey:@"img"];
            [imgAry addObject:IMG_APPEND_PREFIX(imgurl)];
        }
        cycleScrollView.imageURLStringsGroup = imgAry;
    } fail:^(NSString *error) {
        
    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 152, SCREEN_WIDTH - 30, 40)];
    [btn setImage:IMAGE(@"search") forState:UIControlStateNormal];
    [btn setTitle:@"搜索商品" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -, 0, 0);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(btn.frame.size.width - btn.imageView.frame.size.width ), 0, 0);
    
    [self.view addSubview:btn];
    
    _classTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 80, SCREEN_HEIGHT - 264 - 49)];
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    _classTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_classTableView];
    
    _goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 200, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 264 - 49)];
    _goodsTableView.delegate = self;
    _goodsTableView.dataSource = self;
    _goodsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_goodsTableView];
    
    
    [self loadData];
    [self loadGoodsData];
}

- (void)searchBtnClick {
    SearchViewController * search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_classTableView]) {
        return _classDataArray.count;
    }else {
        return _goodsDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_classTableView]) {
        LMShopClassViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell"];
        if (!cell) {
            cell = [[LMShopClassViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classCell"];
        }
        NSString *string = _classDataArray[indexPath.row][@"name"];
        [cell refreshUI:string];
        return cell;
    }else {
        LMShopCGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cGoodsCell"];
        if (!cell) {
            cell = [[LMShopCGoodsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cGoodsCell"];
        }
        LMShopModel *model = _goodsDataArray[indexPath.row];
        [cell refreshUI:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_classTableView]) {
        return 44;
    }else {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_classTableView]) {
        _catID = _classDataArray[indexPath.row][@"id"];
        [self loadGoodsData];
    }else {
        LMShopModel *model = _goodsDataArray[indexPath.row];
        GoodsDeailController *vc = [[GoodsDeailController alloc] init];
        vc.goods_id  =   model.goods_id ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadGoodsData {
    _pageIndex = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"uid"] = [SARUserInfo userId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
    dic[@"cat_id"] = _catID;
    
    [mgr POST:SHOP_CLASS_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            _goodsDataArray = [LMShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [self.goodsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
    }];
}

#pragma mark -- 轮播图点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    SAMessageWebViewController *webView = [[SAMessageWebViewController alloc] init];
    //    webView.title = [[imgData objectAtIndex:index] objectForKey:@"title"];
    //    webView.webUrl = [[imgData objectAtIndex:index] objectForKey:@"url"];
    //    webView.hidesBottomBarWhenPushed = YES;
    //    [self pushTo:webView];
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
