//
//  FansTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/11/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FansTableViewController.h"
#import "FansTableViewCell.h"
@interface FansTableViewController (){
    MJRefreshNormalHeader *_header;
}

@end

@implementation FansTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self setUpRefresh];
    
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fansCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FansTableViewCell" owner:nil options:nil]firstObject];
    }
    if ([_dataArr[indexPath.row][@"is_follow"] doubleValue] == 1) {
        
         cell.fansStateImage.image = [UIImage imageNamed:@"Interested-person-Follow-success"];
    }else{
         cell.fansStateImage.image = [UIImage imageNamed:@"Interested-person-follow"];
    }

    
    [cell.userHeadImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_dataArr[indexPath.row][@"headsmall"])] placeholderImage:IMAGE(@"mine_placeholder")];
    cell.userNickName.text = _dataArr[indexPath.row][@"nickname"];
    cell.fansStateImage.tag = indexPath.row + 1;
    cell.fansStateImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
    [cell.fansStateImage addGestureRecognizer:tap];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)focus:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 1;
    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"fuid":_dataArr[index][@"uid"]};
    [RequestData requestWithUrl:FOCUS_UNFOLLOW_USER para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] doubleValue] == 0) {
            // 成功
            
            
        }
        [self.tableView.header beginRefreshing];
    } fail:^(NSError *error) {
        
    }];
   
    
    
    

}

#pragma mark - data
- (void)createData{
    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"type":_type};
    [RequestData requestWithUrl:GET_FUN_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
          
        if ([dataDic[@"code"] doubleValue] == 0) {
            
            _dataArr = dataDic[@"data"];
            
        }else if([dataDic[@"code"] doubleValue] == -2){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 61) / 2, 228, 61, 57)];
            img.image = [UIImage imageNamed:@"人"];
            [self.tableView addSubview:img];
            NSString *str;
            if ([_type isEqualToString:@"1"]) {
                str = @"你还没有关注的人哦";
            }else{
               str = @"目前还没有粉丝，赶快关注他把";
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, kSCREEN_WIDTH, 21)];
            label.text = str;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = RGB(152, 152, 152);
            label.textAlignment = UITextAlignmentCenter;
            [self.tableView addSubview:label];

        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } fail:^(NSError *error) {
        
    }];
    
    
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
    
}




@end
