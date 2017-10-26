//
//  DistributionViewController.m
//  FineQuality
//
//  Created by tangtianshi on 16/9/9.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "DistributionViewController.h"
#import "CourierTableViewCell.h"
@interface DistributionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
      UITableView *_tableView;
}
@end

@implementation DistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    // 关闭
    UIButton *shutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 41, kSCREEN_WIDTH, 41)];
    shutBtn.backgroundColor = [UIColor whiteColor];
    [shutBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [shutBtn setTitleColor:YCColor(139, 20, 27, 1) forState:UIControlStateNormal];
    shutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shutBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutBtn ];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    line.backgroundColor = YCColor(230, 230, 230, 1);
    [shutBtn addSubview:line];
    
}

- (void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 320, kSCREEN_WIDTH, 280) style:UITableViewStylePlain];
   
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.tableFooterView = [[UIView alloc] init];


}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)  {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
        }
        cell.textLabel.text = _selectType;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        CourierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourierTableViewCell"];
        if (!cell) {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"CourierTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 30;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 1) {
        NSIndexPath *index = [tableView indexPathForSelectedRow];
        CourierTableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        [cell.selectedBox setImage:[UIImage imageNamed:@"矩形-203@2x2"] forState:UIControlStateNormal];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate returnType:_selectType title:cell.options.text section:_distributionSection];

    }
    
}
    


- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];

}








@end
