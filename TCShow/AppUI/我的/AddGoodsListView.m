//
//  AddGoodsListView.m
//  TCShow
//
//  Created by  m, on 2017/8/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "AddGoodsListView.h"
#import "GoodsTypeListTableViewCell.h"


@interface AddGoodsListView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GoodsTypeDelegate>{
    
    UITableView *listTableView;//显示规格和库存数量的文本列表
    UIButton *addBut;//添加数据的按钮
    UIButton *sucBut;//完成数据添加的按钮
    UITextField *typeField;//输入规格的输入框
    UITextField *nmbField;//输入库存数的输入框
    NSMutableArray *listArr;//用来存储规格以及库存数据
    NSMutableArray *typeArr;//用来存储规格数据
    NSString *good_size;
    NSString *store_count;
}



@end

@implementation AddGoodsListView
    
//    UITableView *listTableView;//显示规格和库存数量的文本列表
//    UIButton *addBut;//添加数据的按钮
//    UIButton *sucBut;//完成数据添加的按钮
//    UITextField *typeField;//输入规格的输入框
//    UITextField *nmbField;//输入库存数的输入框
    
    



- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor purpleColor];
        
        listArr = [NSMutableArray array];//初始化
        
        [self createTableView];
        
        [self createUI];
    }
//     [self createUI];
    return self;
}


- (void) createUI{
    
    

   
    //创建textField
    typeField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.size.height - 140, ([[UIScreen mainScreen]bounds].size.width)/2, 50)];
    
    typeField.text = @"请输入规格";
    typeField.backgroundColor = [UIColor clearColor];
    typeField.textAlignment = UITextBorderStyleLine;
    [typeField addTarget:self action:@selector(clearTextFieldText:) forControlEvents:UIControlEventEditingDidBegin];
    nmbField = [[UITextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen]bounds].size.width)/2,self.size.height - 140, ([[UIScreen mainScreen]bounds].size.width)/2, 50)];
    nmbField.text = @"请输入库存数";
    nmbField.backgroundColor = [UIColor clearColor];
    nmbField.textAlignment = UITextBorderStyleLine;
    [nmbField addTarget:self action:@selector(clearTextFieldText:) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:typeField];
    [self addSubview:nmbField];
    
    //创建按钮
    addBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.size.height - 90, ([[UIScreen mainScreen]bounds].size.width)/2, 50)];
    
    [addBut setTitle:@"添加数据" forState:UIControlStateNormal];
    addBut.tintColor = [UIColor blackColor];
    addBut.backgroundColor = [UIColor redColor];
    [addBut addTarget:self action:@selector(addButTouch:) forControlEvents:UIControlEventTouchDown];
    sucBut = [[UIButton alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen]bounds].size.width)/2, self.size.height - 90, ([[UIScreen mainScreen]bounds].size.width)/2, 50)];
    [sucBut setTitle:@"完成添加" forState:UIControlStateNormal];
    sucBut.tintColor = [UIColor blackColor];
    sucBut.backgroundColor = [UIColor redColor];
    [sucBut addTarget:self action:@selector(sucButTouch:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:addBut];
    [self addSubview:sucBut];

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
        
//        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        
//        [tmpDic setValue:store_count forKey:good_size];
        
        [listArr addObject:dic];

    }
    
     [listTableView reloadData];//刷新数据
    
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
    
        listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -24, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 90 - 24) style:UITableViewStyleGrouped];
        
        listTableView.backgroundColor = [UIColor yellowColor];
        listTableView.rowHeight = 55.0f;
        listTableView.delegate = self;
        listTableView.dataSource = self;
        [self addSubview:listTableView];
        
//    }
}

//实现完成按钮的点击事件
- (void) sucButTouch:(id)sender
{
    [self.goodDelegate sendArr:listArr];
    
    self.hidden = YES;
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
    
//    return typeArr.count;
    return 10;
    
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     static NSString *CellIdentifier = @"Cell";
    
    GoodsTypeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.typeDelegate = self;
    
    if (!cell) {
        
         cell = [[GoodsTypeListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
//    if (listArr.count > 0 ) {

//        NSMutableDictionary *dic = listArr[indexPath.row];
//        cell.leftLable.text = dic[@"good_size"];
//        cell.rightLable.text = dic[@"store_count"];
        cell.leftLable.text = @"xxl";
        cell.rightLable.text = @"111";
//    }

    
    return cell;
}

- (void) sendKeyToArray:(NSString *)typeName
{
    for ( NSMutableDictionary *dic in listArr) {
        
        [dic removeObjectForKey:typeName];
    }
    
    [listTableView reloadData];
}

@end
