//
//  RRContributeListTableView.m
//  live
//
//  Created by admin on 16/6/6.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "RRContributeListTableView.h"
#import "Business.h"
#import "RRContributeListModel.h"
#import "RRContributeCell.h"
//#import "UserInfo.h"
@implementation RRContributeListTableView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        self.headBtn.backgroundColor = [UIColor colorWithRed:254/255.0 green:233/255.0 blue:234/255.0 alpha:1];
        [self.headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headBtn setImage:[UIImage imageNamed:@"金币1"] forState:UIControlStateNormal];
        [self.headBtn setTitle:@"0金币" forState:UIControlStateNormal];
        self.headBtn.userInteractionEnabled = NO;
        self.tableHeaderView = self.headBtn;

        
    }
    return self;
}


#pragma mark -- 刷新
- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
    [self requestLiveData:@""];
}
#pragma mark -- 加载更多
- (void)loadData
{
    //    [self requestLiveData:@"2"];
    [_footer endRefreshing];
}

- (void)requestLiveData:(NSString*)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic1 = @{@"id":[IMAPlatform sharedInstance].host.profile.identifier};
    if (!self.userID) {
        self.userID = @"";
    }
    NSDictionary *dic = @{@"user_id":self.userID};

    // 获取贡献榜数据 list
    [manager POST:GET_CORNTRIBUTE_LIST parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (URLREQUEST_SUCCESS == [[responseObject objectForKey:@"code"] intValue]) {
            
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *msgAry = [dic objectForKey:@"lists"];
            NSString *price = [NSString stringWithFormat:@"%@金币",[dic objectForKey:@"price"]];
            [self.headBtn setTitle:price forState:UIControlStateNormal];
            if([lastTime isEqualToString:@""])
            {
                //刷新，如果是加载更多不用删除旧数据
                [_datas removeAllObjects];
            }
            for (NSDictionary *dic in msgAry) {
                
                RRContributeListModel *model = [[RRContributeListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_datas addObject:model];
                
            }
            [_header endRefreshing];
            [_footer endRefreshing];
            [self reloadData];
            if (_datas.count == 0) {
                [self showNoDataView:@"no_data_live" title:@"暂无贡献"];
            }else{
                [self hideNoDataView];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isLoading = NO;
            });
            
            
            
        }else{
            NSString *error = [responseObject objectForKey:@"message"];
            if (_header.isRefreshing || _footer.isRefreshing) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
                hud.labelText = error;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.hidden = YES;
                });
//                [hud hideText:error atMode:MBProgressHUDModeText andDelay:1.f andCompletion:NULL];
            }
            if ([error hasPrefix:@"空"]) {
                [_datas removeAllObjects];
                [self reloadData];
            }
            
            if (_datas.count == 0) {
                [self showNoDataView:@"no_data_live" title:@"暂无贡献"];
            }else{
                [self hideNoDataView];
            }
            
            [_header endRefreshing];
            [_footer endRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isLoading = NO;
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.respondController.view animated:YES];
        hud.labelText = @"请求失败，请稍后重试~";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
//        [hud hideText:@"请求失败，请稍后重试~" atMode:MBProgressHUDModeText andDelay:1.f andCompletion:NULL];
        
    }];

    
}




#pragma mark -- tableview代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRContributeListModel *model = [_datas objectAtIndex:indexPath.row];
    RRContributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RRContributeCell" owner:self options:nil]lastObject];
    }
    NSURL *headImgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_ENTRYY,model.img]];
    [cell.head_img sd_setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"no_data_live"]];
    cell.name.text = model.nickname;
    cell.number.text = [NSString stringWithFormat:@"%@",model.sum];
    cell.major_key.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RRContributeListModel *model = [_datas objectAtIndex:indexPath.row];
    if (self.cBlock) {
        self.cBlock(model,indexPath,tableView);
    }    
}


@end
