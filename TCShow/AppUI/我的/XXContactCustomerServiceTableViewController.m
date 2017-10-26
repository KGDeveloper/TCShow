//
//  XXContactCustomerServiceTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXContactCustomerServiceTableViewController.h"

@interface XXContactCustomerServiceTableViewController ()<UIActionSheetDelegate>
{
    NSArray *_titleArr;
    NSArray *_imgArr;
}
@end

@implementation XXContactCustomerServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系客服";
    self.view.backgroundColor = RGB(239, 241, 250);
    _titleArr = @[@"微信16838277639",@"QQ3762889038",@"电话10086"];
    _imgArr = @[@"联系客服WeChat",@"联系客服QQ",@"联系客服tel"];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
}


-(void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10086", nil];
        action.tag = 1;
        [action showInView:self.view];

    }
}
    
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
         if (buttonIndex == 0) {
             NSString * url = [NSString stringWithFormat:@"telprompt://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
             
             [self openMyUrl:url];
         }
        
    }

#pragma mark - 调用方法
- (void)openMyUrl:(NSString *)url{
    //转换为NSURL类型
    NSURL * myUrl = [NSURL URLWithString:url];
    
    //应判断设备是否支持功能,或者设备上是否安装该应用程序
    UIApplication * app = [UIApplication sharedApplication];
    
    if (![app canOpenURL:myUrl]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备无此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }else{
        
        [app openURL:myUrl];
    }
}



@end
