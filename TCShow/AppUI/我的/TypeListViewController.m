//
//  TypeListViewController.m
//  TCShow
//
//  Created by  m, on 2017/9/2.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "TypeListViewController.h"
#import "GoodsTypeListTableViewCell.h"

@interface TypeListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    
    UIButton *addBut;//添加数据的按钮
    UIButton *sucBut;//完成数据添加的按钮
    UITextField *typeField;//输入规格的输入框
    UITextField *nmbField;//输入库存数的输入框
    NSMutableArray *listArr;//用来存储规格以及库存数据
    NSMutableArray *typeArr;//用来存储规格数据
    NSString *good_size;
    NSString *store_count;
}

@property (nonatomic , strong) UITableView *listTableView;//显示规格和库存数量的文本列表

@end

/**
 **
 **
 **设置类型
 **
 **
 **/

@implementation TypeListViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"goods_standard"];
    [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加类型";
    
    listArr = [NSMutableArray array];//初始化
    
    if (listArr.count >0) {
        
        [listArr removeAllObjects];
    }

    
    [self createData];
    
    [self createTableView];
    
    [self createUI];
    
    
}



- (void) createData
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSArray *tmp = [defaults objectForKey:@"goods_standard"];
    [listArr addObjectsFromArray:tmp];
}

- (void) createUI{
    

    //创建textField
    typeField = [[UITextField alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 100, (kSCREEN_WIDTH)/2, 50)];
    
    typeField.text = @"请输入规格";
    typeField.backgroundColor = [UIColor clearColor];
    typeField.textAlignment = UITextBorderStyleLine;
    [typeField addTarget:self action:@selector(clearTextFieldText:) forControlEvents:UIControlEventEditingDidBegin];
    nmbField = [[UITextField alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH)/2,kSCREEN_HEIGHT - 100, (kSCREEN_WIDTH)/2, 50)];
    nmbField.text = @"请输入库存数";
    nmbField.backgroundColor = [UIColor clearColor];
    nmbField.textAlignment = UITextBorderStyleLine;
    [nmbField addTarget:self action:@selector(clearTextFieldText:) forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:typeField];
    [self.view addSubview:nmbField];
    
    //创建按钮
    addBut = [[UIButton alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 50, (kSCREEN_WIDTH)/2, 50)];
    
    [addBut setTitle:@"添加数据" forState:UIControlStateNormal];
    addBut.tintColor = [UIColor blackColor];
    addBut.backgroundColor = [UIColor redColor];
    [addBut addTarget:self action:@selector(addButTouch:) forControlEvents:UIControlEventTouchDown];
    sucBut = [[UIButton alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH)/2,kSCREEN_HEIGHT - 50, (kSCREEN_WIDTH)/2, 50)];
    [sucBut setTitle:@"完成添加" forState:UIControlStateNormal];
    sucBut.tintColor = [UIColor blackColor];
    sucBut.backgroundColor = [UIColor redColor];
    [sucBut addTarget:self action:@selector(sucButTouch:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addBut];
    [self.view addSubview:sucBut];
    
}


- (void) clearTextFieldText:(UITextField *)sender
{
    if ([sender isKindOfClass:[UITextField class]]) {
        
        sender.text = @"";
    }
}

#pragma mark -实现按钮的点击事件-
//实现添加按钮的点击事件
- (void) addButTouch:(id)sender
{
    
    
    
    
    if ([typeField.text isEqualToString:@""] & [nmbField.text isEqualToString:@""]) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请输入规格或者库存"];
    }else
    {

        
        
        
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:typeField.text forKey:@"good_size"];
            [dic setObject:nmbField.text forKey:@"store_count"];
            
        
            
            [listArr addObject:dic];
            
        
        
        
        [_listTableView reloadData];//刷新数据
        
    }
    
    
    
}

- (void)createTableView
{
    
    
    
    //    if (listArr.count == 0) {
    //
    //        [[HUDHelper sharedInstance] tipMessage:@"请添加规格以及库存"];
    //    }
    //    else
    //    {
    //创建用来显示库存以及规格的tableView
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 164) style:UITableViewStylePlain];
    
    _listTableView.backgroundColor = [UIColor yellowColor];
    _listTableView.rowHeight = 55.0f;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    
    //    }
}

//实现完成按钮的点击事件
- (void) sucButTouch:(id)sender
{
  
    self.sendArr(listArr);
    [self.navigationController popViewControllerAnimated:YES];
}

//实现收件盘
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [typeField resignFirstResponder];
    [nmbField resignFirstResponder];
}

#pragma mark -遵守tableView的代理协议，实现协议里的方法-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return listArr.count;
    
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    GoodsTypeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GoodsTypeListTableViewCell" owner:nil options:nil] firstObject];

        if (listArr.count == 0) {
            
            
        }else
        {

            NSMutableDictionary *dic = listArr[indexPath.row];
            
            cell.leftLable.text = dic[@"good_size"];
            cell.rightLable.text = dic[@"store_count"];
            cell.deleteBut.tag = indexPath.row;
            cell.giveTag =^(NSInteger butTag){
            
                
                for (int i = 0; i < listArr.count; i++) {
                    
                    if (i == butTag) {
                        
                        [listArr removeObjectAtIndex:i];
                        
                        [_listTableView reloadData];
                        
                        
                    }
                }
            
            };
            
        }

    }
    return cell;
   
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
