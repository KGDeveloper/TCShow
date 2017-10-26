 //
//  LMStoreMoldEditViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/26.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMStoreMoldEditViewController.h"
#import "LMStoreMoldEditCell.h"

@interface LMStoreMoldEditViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LMStoreMoldEditViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"LMStoreMoldEditCell" bundle:nil]  forCellReuseIdentifier:@"LMStoreMoldEditCell"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [btn setTitle:@"添加类型" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = LEMON_MAINCOLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = btn;
    
    [self.view addSubview:_tableView];
    
    
    
}

- (void)backBtnClick {
//    [_tableView beginUpdates];
    
    [_dataArray addObject:@"1111"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
    
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_tableView endUpdates];
    
    
//    //1. 先向数据源增加数据
//    TRContact *contact = [[TRContact alloc]init];
//    contact.name = @"陈七";
//    contact.phoneNumber = @"18612345678";
//    [self.contacts addObject:contact];
//    //2. 再向TableView增加行
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contacts.count - 1 inSection:0];
//    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count == 0) {
        return 1;
    }else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMStoreMoldEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMStoreMoldEditCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LMStoreMoldEditCell" owner:nil options:nil] lastObject];
    }
    if ([_dataArray[indexPath.row] isEqualToString:@""]) {
        
    }else {
        cell.leiXingTF.text = _dataArray[indexPath.row + 1];
    }
    cell.removeBtnClickBlock = ^{
        if (_dataArray.count == 1) {
            
        }else {
            [_dataArray removeObjectAtIndex:_dataArray.count];
        }
    };
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
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
