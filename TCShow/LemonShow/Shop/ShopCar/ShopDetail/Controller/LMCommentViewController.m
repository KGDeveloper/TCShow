//
//  LMCommentViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/26.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMCommentViewController.h"
#import "LMCommentViewCell.h"

@interface LMCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LMCommentViewController {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"LMCommentViewCell" bundle:nil]  forCellReuseIdentifier:@"LMCommentViewCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [self setUpRefresh];
}

-(void)setUpRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //    _tableView.header.
    [_tableView.header beginRefreshing];
    
    
    
}
- (void)loadData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_id"] = [SARUserInfo userId];
    dic[@"goods_id"] = self.goods_id;
    
    [mgr POST:COMMENT_LIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            _dataArray = responseObject[@"data"];
        }else {
            
            [[HUDHelper sharedInstance] tipMessage:responseObject[@"message"]];
        }
        hud.hidden = YES;
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        [[HUDHelper sharedInstance] tipMessage:@"加载失败"];
        [_tableView.header endRefreshing];
    }];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMCommentViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LMCommentViewCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *conten = dict[@"content"];
    NSString *nameLb = dict[@"username"];
    cell.desLab.text = conten;
    cell.nameLab.text = nameLb;
    NSString *imgStr =dict[@"img"];
    if ([imgStr isEqual:[NSNull null]] || imgStr ==nil) {
        
        imgStr =@"";
        
        if ([imgStr rangeOfString:@"http"].location == NSNotFound) {
            imgStr = IMG_APPEND_PREFIX(imgStr);
        }
        
    }
    [cell.imageIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGE(@"zanwu")];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
