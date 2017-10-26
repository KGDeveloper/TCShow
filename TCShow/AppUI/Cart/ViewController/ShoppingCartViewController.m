//
//  ShoppingCartViewController.m
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "Util.h"
#import "ShoppingTableView.h"
#import "ShoppingModel.h"
#import "ConfirmOrderViewController.h"
#define BACKGROUNDCOLOR [UIColor colorWithRed:239.0/255.0 green:34.0/255.0 blue:109.0/255.0 alpha:1.0]
@interface ShoppingCartViewController ()
{
    BOOL isbool;
    BOOL editbool;
    NSString *numString;
    UIButton *_editLabel;
    ShoppingTableView *shopping;
    NSArray *cellArray;
}
@end

@implementation ShoppingCartViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    _allPriceLabel.text = [NSString stringWithFormat:@"总价: ￥0.00"];
    [Util setUILabel:_allPriceLabel Data:@"总价: " SetData:@"￥0.00" Color:kNavBarThemeColor Font:15 Underline:NO];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    _settlementLabel.textColor = [UIColor whiteColor];
    _editLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _editLabel.frame = CGRectMake(0, 0, 40, 20);
    [_editLabel setTitle:@"编辑" forState:UIControlStateNormal];
    [_editLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_editLabel addTarget:self action:@selector(EditBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_editLabel];
    self.navigationItem.rightBarButtonItem = item;
    [self setInit];
}

-(void)setInit{
    numString = @"0";
    [Util setFoursides:_bottomView Direction:@"top" sizeW:SCREEN_WIDTH];
    shopping = [[ShoppingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -50 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:shopping];
    [self setData];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllPrice:) name:@"AllPrice" object:nil];
    
}


#pragma mark 通知
- (void)AllPrice:(NSNotification *)text{
    _allPriceLabel.text = [NSString stringWithFormat:@"总价: %@",text.userInfo[@"allPrice"]];
     [Util setUILabel:_allPriceLabel Data:@"总价: " SetData:text.userInfo[@"allPrice"] Color:kNavBarThemeColor Font:15 Underline:NO];
    numString = text.userInfo[@"num"];
    
    [self setTlementLabel];
    [self setAllBtnState:[text.userInfo[@"allState"]  isEqual: @"YES"]?NO:YES];
    cellArray =  text.userInfo[@"cellModel"];
}

#pragma mark 设置结算按钮状态
-(void)setTlementLabel{
    NSString *string = editbool?@"删除":@"结算";
    _settlementLabel.text = [NSString stringWithFormat:@"%@(%@)",string,numString];
    _settlementLabel.textColor = [UIColor whiteColor];
}

#pragma mark 数据
-(void)setData{
    
    [RequestData requestWithUrl:CART_LIST para:@{@"user_id":[SARUserInfo userId]} Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *arrayl = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in dic[@"data"]) {
            
            NSMutableArray *dictarray = [[NSMutableArray alloc] init];
            ShoppingModel *model = [[ShoppingModel alloc] initWithShopDict:dict];
            [dictarray addObject:model];
            
            [arrayl addObject:model];
            
        }
        
        shopping.shoppingArray = arrayl;

    } fail:^(NSError *error) {
        
    }];
    
    
    
    /*
    
    NSDictionary *dicts = @{@"item":@[
                                @{
                                    @"headID":@"10",
                                    @"headState":@1,
                                    @"discount":@"9",
                                    @"headCellArray":@[
                                            @{
                                                @"imageUrl":@"headurl.png",
                                                @"title":@"韩版宽松杂色马海毛休闲",
                                                @"color":@"浅蓝",
                                                @"size":@"s",
                                                @"price":@"100.00",
                                                @"numInt":@2,
                                                @"inventoryInt":@10,
                                                @"mustInteger":@1,
                                                @"ID":@"10",
                                                },
                                            @{
                                                
                                                @"imageUrl":@"headurl.png",
                                                @"title":@"韩版宽松杂色马海毛休闲",
                                                @"color":@"浅蓝",
                                                @"size":@"s",
                                                @"price":@"100.00",
                                                @"numInt":@2,
                                                @"inventoryInt":@10,
                                                @"mustInteger":@1,
                                                @"ID":@"11",
                                                },
                                            @{
                                                
                                                @"imageUrl":@"headurl.png",
                                                @"title":@"韩版宽松杂色马海毛休闲",
                                                @"color":@"浅蓝",
                                                @"size":@"s",
                                                @"price":@"100.00",
                                                @"numInt":@2,
                                                @"inventoryInt":@10,
                                                @"mustInteger":@0,
                                                @"ID":@"12",
                                                },
                                            ]
                                        
                                    }
                                ]
                            };
    
    
    NSMutableArray *arrayl = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dicts[@"item"]) {
        
        NSMutableArray *dictarray = [[NSMutableArray alloc] init];
        ShoppingModel *model = [[ShoppingModel alloc] initWithShopDict:dict];
        [dictarray addObject:model];
        
        [arrayl addObject:model];
        
    }
    
    shopping.shoppingArray = arrayl;
     */
    
}

#pragma mark 编辑
- (void)EditBtn:(UIButton *)sender {
    if (editbool) {
        [shopping editBtn:editbool];
        editbool = NO;
        _subLabel.hidden = NO;
    }else{
        [shopping editBtn:editbool];
        editbool = YES;
        _subLabel.hidden = YES;
    }
    [_editLabel setTitle:editbool?@"完成":@"编辑" forState:UIControlStateNormal];
    [self setTlementLabel];
    _allPriceLabel.hidden = editbool;
}

#pragma mark 返回
- (IBAction)ReturnBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 全选
- (IBAction)AllBtn:(UIButton *)sender {
    
    [shopping allBtn:!isbool];
}

#pragma mark 全选
-(void)setAllBtnState:(BOOL)_bool{

    if (_bool) {
        _allImage.image = [UIImage imageNamed:@"iconfont-yuanquan"];
        isbool = NO;
    }else{
        _allImage.image = [UIImage imageNamed:@"iconfont-zhengque"];
        isbool = YES;
    }
}

#pragma mark 结算
- (IBAction)SettlementBtn:(UIButton *)sender {
    if (editbool) {
        [shopping deleteBtn:editbool];
    }else{
        if (cellArray.count > 0) {
            ConfirmOrderViewController * conf = [[ConfirmOrderViewController alloc]init];
            conf.isCart = YES;
            conf.cartArray = cellArray;
            conf.totalPrice = [self.allPriceLabel.text substringFromIndex:5];
            [self.navigationController pushViewController:conf animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
