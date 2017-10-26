//
//  QZKRechargeView.m
//  TCShow
//
//  Created by  m, on 2017/9/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "QZKRechargeView.h"
#import "QZKChargeModel.h"
#import "TCCharmTableViewCell.h"
#import "QZKChargeTopModle.h"
#import "QZKChargeTopCell.h"
#import "QZKChargeTopLastCell.h"

#define ViewWidth  self.frame.size.width
#define ViewHeight  self.frame.size.height

@implementation QZKRechargeView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        self.lemon_idArr = [NSMutableArray array];
        self.dataArr = [NSMutableArray array];
        [self createUI];
        [self createNiuniuGamesBtuTitle];
    }
    return self;
}
- (void)createNiuniuGamesBtuTitle{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak typeof(self) weakSelf = self;
    [manager POST:LIVE_CONINLISTS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = responseObject[@"data"];
        for (int i =0; i < arr.count; i++) {
            if (i == 0) {
                NSDictionary *dic = arr[0];
                [weakSelf.firstBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
                weakSelf.firstBtu.tag = [dic[@"lemon_id"] integerValue];
                weakSelf.firstBtu.hidden = NO;
            }else if (i== 1){
                NSDictionary *dic = arr[1];
                [weakSelf.secondBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
                weakSelf.secondBtu.tag = [dic[@"lemon_id"] integerValue];
            }else if (i== 2){
                NSDictionary *dic = arr[2];
                [weakSelf.threidBtu setTitle:[NSString stringWithFormat:@"%@元",dic[@"price"]] forState:UIControlStateNormal];
                weakSelf.threidBtu.tag = [dic[@"lemon_id"] integerValue];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) createUI{
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth,ViewHeight)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"圆角矩形-10"];
    [self insertSubview:imageView atIndex:0];
    
    UILabel *topLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 46)];
    topLab.backgroundColor = [UIColor clearColor];
    topLab.text = @"土豪排行榜TOP10";
    topLab.textAlignment = NSTextAlignmentCenter;
    topLab.font = [UIFont systemFontOfSize:18.0f];
    topLab.textColor = [UIColor colorWithRed:243/255.0 green:204/255.0 blue:119/255.0 alpha:1];
    [self addSubview:topLab];
    
    UIButton *clickBtu = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth - 33, 10, 18, 18)];
    clickBtu.backgroundColor = [UIColor clearColor];
    clickBtu.layer.cornerRadius = 9.0f;
    clickBtu.layer.masksToBounds = YES;
    [clickBtu setImage:[UIImage imageNamed:@"10"] forState:UIControlStateNormal];
    [clickBtu addTarget:self action:@selector(clickBtuTouch:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:clickBtu];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, ViewWidth, 2)];
    lineLab.backgroundColor = [UIColor grayColor];
    [self addSubview:lineLab];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,48, ViewWidth, ViewHeight - 98) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor yellowColor];
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    [self addSubview:_tableView];
    
    self.chargerView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight - 50, ViewWidth, 50)];
    self.chargerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.chargerView];
    
    UILabel *viewlineLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,ViewWidth,2)];
    viewlineLab.backgroundColor = [UIColor grayColor];
    [self.chargerView addSubview:viewlineLab];
    
    self.firstBtu = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, 100, 35)];
    self.firstBtu.backgroundColor = [UIColor clearColor];
    self.firstBtu.titleLabel.textColor = [UIColor grayColor];
    self.firstBtu.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.firstBtu.layer.cornerRadius = 5.0f;
    self.firstBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    self.firstBtu.layer.borderWidth = 1.0f;
    self.firstBtu.layer.masksToBounds = YES;
    self.firstBtu.hidden = YES;
    [self.firstBtu addTarget:self action:@selector(fistBtuSelect:) forControlEvents:UIControlEventTouchDown];
    [self.chargerView addSubview:self.firstBtu];
    
    self.secondBtu = [[UIButton alloc]initWithFrame:CGRectMake(130, 8, 100, 35)];
    self.secondBtu.backgroundColor = [UIColor clearColor];
    self.secondBtu.titleLabel.textColor = [UIColor grayColor];
    self.secondBtu.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.secondBtu.layer.cornerRadius = 5.0f;
    self.secondBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    self.secondBtu.layer.borderWidth = 1.0f;
    self.secondBtu.layer.masksToBounds = YES;
    [self.secondBtu addTarget:self action:@selector(secondBtuSelect:) forControlEvents:UIControlEventTouchDown];
    [self.chargerView addSubview:self.secondBtu];
    
    self.threidBtu = [[UIButton alloc]initWithFrame:CGRectMake(245, 8, 100, 35)];
    self.threidBtu.backgroundColor = [UIColor clearColor];
    self.threidBtu.titleLabel.textColor = [UIColor grayColor];
    self.threidBtu.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.threidBtu.layer.cornerRadius = 5.0f;
    self.threidBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    self.threidBtu.layer.borderWidth = 1.0f;
    self.threidBtu.layer.masksToBounds = YES;
    [self.threidBtu addTarget:self action:@selector(threidBtuSelect:) forControlEvents:UIControlEventTouchDown];
    [self.chargerView addSubview:self.threidBtu];
    
    self.chargeBtu = [[UIButton alloc]initWithFrame:CGRectMake(355, 8, 55, 35)];
    [self.chargeBtu setBackgroundColor:[UIColor clearColor]];
    [self.chargeBtu setTitle:@"充值" forState:UIControlStateNormal];
    [self.chargeBtu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.chargeBtu.layer.cornerRadius = 5.0f;
    self.chargeBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    self.chargeBtu.layer.borderWidth = 1.0f;
    self.chargeBtu.layer.masksToBounds = YES;
    self.chargeBtu.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.chargeBtu addTarget:self action:@selector(chargeBtuSelect:) forControlEvents:UIControlEventTouchDown];
    [self.chargerView addSubview:self.chargeBtu];
    
}

- (void)chargeBtuSelect:(UIButton *)sender{
    sender.backgroundColor = [UIColor yellowColor];
    sender.titleLabel.textColor = [UIColor whiteColor];
    sender.layer.borderColor = [[UIColor yellowColor] CGColor];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.av_room_id forKey:@"room_id"];
    [dic setValue:[SARUserInfo userId] forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)sender.tag] forKey:@"lemon_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak typeof(self) weakSelf = self;
    [manager POST:RECHARGE_DE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf animated:YES];
        hud.labelText = @"订单生成中...";
        [[Business sharedInstance] limoPayWithWexinWithParam:@{@"user_id":[SARUserInfo userId],@"lemon_id":[NSString stringWithFormat:@"%ld",(long)sender.tag]} succ:^(NSString *msg, id data) {
            [hud hide:YES afterDelay:0];
            NSString *lam = [NSString stringWithFormat:@"%ld",[data[@"order_price"] integerValue]*100];
            [MXWechatPayHandler jumpToWxPayWithMoney:lam Order:data[@"order_sn"] type:0];
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:@"订单生成失败,请重试!"];
            [hud hide:YES afterDelay:2];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    AFHTTPRequestOperationManager *seeManager = [AFHTTPRequestOperationManager manager];
    [seeManager POST:RWXNOTIFY_DE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)threidBtuSelect:(UIButton *)sender{
    sender.backgroundColor = [UIColor yellowColor];
    sender.titleLabel.textColor = [UIColor whiteColor];
    sender.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.firstBtu.backgroundColor = [UIColor clearColor];
    self.firstBtu.titleLabel.textColor = [UIColor grayColor];
    self.firstBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.secondBtu.backgroundColor = [UIColor clearColor];
    self.secondBtu.titleLabel.textColor = [UIColor grayColor];
    self.secondBtu.layer.borderColor = [[UIColor grayColor] CGColor];

    self.chargeBtu.backgroundColor = [UIColor clearColor];
    self.chargeBtu.titleLabel.textColor = [UIColor grayColor];
    self.chargeBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.chargeBtu.tag = sender.tag;
}

- (void)secondBtuSelect:(UIButton *)sender{
    sender.backgroundColor = [UIColor yellowColor];
    sender.titleLabel.textColor = [UIColor whiteColor];
    sender.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.firstBtu.backgroundColor = [UIColor clearColor];
    self.firstBtu.titleLabel.textColor = [UIColor grayColor];
    self.firstBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.threidBtu.backgroundColor = [UIColor clearColor];
    self.threidBtu.titleLabel.textColor = [UIColor grayColor];
    self.threidBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.chargeBtu.backgroundColor = [UIColor clearColor];
    self.chargeBtu.titleLabel.textColor = [UIColor grayColor];
    self.chargeBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.chargeBtu.tag = sender.tag;
}

- (void)fistBtuSelect:(UIButton *)sender{
    sender.backgroundColor = [UIColor yellowColor];
    sender.titleLabel.textColor = [UIColor whiteColor];
    sender.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.secondBtu.backgroundColor = [UIColor clearColor];
    self.secondBtu.titleLabel.textColor = [UIColor grayColor];
    self.secondBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.threidBtu.backgroundColor = [UIColor clearColor];
    self.threidBtu.titleLabel.textColor = [UIColor grayColor];
    self.threidBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.chargeBtu.backgroundColor = [UIColor clearColor];
    self.chargeBtu.titleLabel.textColor = [UIColor grayColor];
    self.chargeBtu.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.chargeBtu.tag = sender.tag;
}

- (void)clickBtuTouch:(UIButton *)sender{
    self.hidden = YES;
}

//请求充值排行榜名单
- (void) createData:(NSString *)room_id{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *tmp = [NSString stringWithFormat:@"%@",self.av_room_id];
    [dic setValue:tmp forKey:@"av_room_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak typeof(self) weakSelf = self;
    [manager POST:LIVE_RECHARGE_LIST_DE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = responseObject[@"data"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *arrDic = arr[i];
            QZKChargeTopModle *model = [[QZKChargeTopModle alloc]initWithNsdictionary:arrDic];
            [_dataArr addObject:model];
        }
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <=2 ) {
        QZKChargeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"QZKChargeTopCell" owner:nil options:nil] firstObject];
        }
        if (_dataArr.count > 0) {
            QZKChargeTopModle *model = _dataArr[indexPath.row];
            cell.titleImage.layer.cornerRadius = 24.0f;
            cell.titleImage.layer.masksToBounds = YES;
            if (indexPath.row == 0) {
                cell.numberImage.image = [UIImage imageNamed:@"rank_1"];
            }else if (indexPath.row == 1){
                cell.numberImage.image = [UIImage imageNamed:@"rank_2"];
            }else{
                cell.numberImage.image = [UIImage imageNamed:@"rank_3"];
            }
            if ([model.title containsString:@"http"]) {
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.title]];
            }else{
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(model.title)]];
            }
            cell.userName.text = [NSString stringWithFormat:@"%@",model.nickname];
            cell.userPrice.text = [NSString stringWithFormat:@"消费值 %@",model.order_price];
        }
        return cell;
    }else{
        QZKChargeTopLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"QZKChargeTopLastCell" owner:nil options:nil] firstObject];
        }
        QZKChargeTopModle *model = _dataArr[indexPath.row];
        cell.userTitle.layer.cornerRadius = 24.0f;
        cell.userTitle.layer.masksToBounds = YES;
        cell.numberLabel.text = [NSString stringWithFormat:@"NO.%ld",(long)indexPath.row + 1];
        if ([model.title containsString:@"http"]) {
            [cell.userTitle sd_setImageWithURL:[NSURL URLWithString:model.title]];
        }else{
            [cell.userTitle sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(model.title)]];
        }
        cell.userName.text = model.nickname;
        cell.userPirce.text = [NSString stringWithFormat:@"消费值 %@",model.order_price];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

@end
