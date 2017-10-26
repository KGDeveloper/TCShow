

//
//  TCBlacklAddViewController.m
//  TCShow
//
//  Created by tangtianshi on 17/2/14.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TCBlacklAddViewController.h"
#import "TCBlackAddTableViewCell.h"
@interface TCBlacklAddViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UITableView *_tabeView;
    BOOL _isON;
}
@end

@implementation TCBlacklAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createData];
    _tabeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 61) style:UITableViewStylePlain];
    _tabeView.delegate = self;
    _tabeView.dataSource = self;
    [self.view addSubview:_tabeView];
    _tabeView.scrollEnabled = NO;
    _isON = NO;
    UIButton *deleteFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteFriend.frame = CGRectMake(10, 80, kSCREEN_WIDTH - 20, 45);
    deleteFriend.backgroundColor = kNavBarThemeColor;
    [deleteFriend setTitle:@"删除好友" forState:UIControlStateNormal];
    [deleteFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteFriend.layer.cornerRadius = 5;
    [self.view addSubview:deleteFriend];
    [deleteFriend addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBlackAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBlackAddTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TCBlackAddTableViewCell" owner:self options:nil]lastObject];
    }
    cell.textLabel.text = @"加入黑名单";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blackAdd.on = _isON;
    [cell.blackAdd addTarget:self action:@selector(black:) forControlEvents:UIControlEventValueChanged];
    
    return cell;

}

-(void)black:(id)sender
{
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//    if (isButtonOn) {
//        
//    }else {
//        
//    }
//    
//    
    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"friend_phone":_userPhone};
    [RequestData requestWithUrl:BLACK_OPERATION para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            
            _isON = !_isON;
        }else{
        
        }
    } fail:^(NSError *error) {
        
    }];

    
    
}
// 删除好友
- (void)deleteFriend{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认删除" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
   


}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"friend_phone":_userPhone};
    [RequestData requestWithUrl:FRIEND_DELEGATE para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)createData{
    
    NSDictionary *para = @{@"uid":[ SARUserInfo userId]};
    [RequestData requestWithUrl:BLACK_LIST para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0 ) {
            for (NSDictionary *obj in dic[@"data"]) {
                if ([obj[@"phone"] isEqualToString:_userPhone]) {
                    _isON = YES;
                }
            }
            [_tabeView reloadData];
           
        }
    }fail:^(NSError *error) {
        
    }];
    
    
    
    
}

@end
