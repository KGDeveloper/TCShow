#import "ShoppingTableView.h"
#import "Util.h"
#import "ShoppingBtn.h"
#import "ShoppingModel.h"
#import "ShoppingTableViewCell.h"
#define BACKGROUNDCOLOR [UIColor colorWithRed:239.0/255.0 green:34.0/255.0 blue:109.0/255.0 alpha:1.0]
@interface ShoppingTableView ()<ShoppingTableViewCellDelegate>
{
    
}
@end

@implementation ShoppingTableView
{
    
}
-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self  = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor =YCColor(238, 238, 238, 1);
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = YCColor(221, 221, 221, 1);
        self.tableFooterView = [[UIView alloc]init];
        self.showsVerticalScrollIndicator = NO;
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}


-(void)setShoppingArray:(NSMutableArray *)shoppingArray{
    if (_shoppingArray != shoppingArray) {
        _shoppingArray = shoppingArray;
        [self reloadData];
    }
}


#pragma mark 分割线去掉左边15个像素
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ShoppingModel *headModel = _shoppingArray[section];
    if (headModel.headState == 1) {
        return 40;
    }else if (headModel.headState == 2){
        return 40;
    }else{
        return 0.0001;
    }
}

#pragma mark头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingModel *headModel = _shoppingArray[section];
    if (headModel.headState == 1) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [Util setFoursides:view Direction:@"top" sizeW:SCREEN_WIDTH];
        ShoppingBtn *collocationBtn = [[ShoppingBtn alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
        collocationBtn.tag = section;
        [collocationBtn addTarget:self action:@selector(CollocationBtn:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:collocationBtn];
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, [[UIScreen mainScreen] bounds].size.width - 70, 20)];
        subLabel.textColor = [UIColor grayColor];
        subLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:subLabel];
        //享受优惠力度
        if (headModel.headPriceDict) {
//            subLabel.text = headModel.headPriceDict[@"headTitle"];
            subLabel.text = @"店铺名称";
        }
        //用来判断 section Header 是否被选中
        if (headModel.headClickState == 1) {
            [collocationBtn setImage:[UIImage imageNamed:@"iconfont-zhengque"] forState:UIControlStateNormal];
        }else{
            [collocationBtn setImage:[UIImage imageNamed:@"iconfont-yuanquan"] forState:UIControlStateNormal];
        }
        return  view;
    }else if (headModel.headState == 2){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor blueColor];
        return  view;
    }
    return nil ;
}


#pragma mark 底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ShoppingModel *forModel = _shoppingArray[section];
    if (forModel.headState == 1) {
        return 50;
    }else {
        return 10;
    }
}

#pragma mark底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ShoppingModel *forModel = _shoppingArray[section];
    if (forModel.headState == 1) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, SCREEN_WIDTH -55, 40)];
        priceLabel.textColor = kNavBarThemeColor;
        priceLabel.text = @"小计:￥00.00";
        priceLabel.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:priceLabel];
        //享受优惠力度
        if (forModel.headPriceDict) {
            priceLabel.text = [NSString stringWithFormat:@"%@%@",forModel.headPriceDict[@"footerTitle"],forModel.headPriceDict[@"footerMinus"]];
            [Util setUILabel:priceLabel Data:forModel.headPriceDict[@"footerTitle"] SetData:forModel.headPriceDict[@"footerMinus"] Color:[UIColor grayColor] Font:12.0 Underline:NO];
        }
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 10)];
        bottomview.backgroundColor = YCColor(238, 238, 238, 1);
        [view addSubview:bottomview];
        [Util setFoursides:bottomview Direction:@"top" sizeW:SCREEN_WIDTH];
        return  view;
    }else{
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 10)];
        bottomview.backgroundColor = YCColor(238, 238, 238, 1);
        return bottomview;
    }
    return nil ;
}

#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _shoppingArray.count;
}

#pragma mark  每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingModel *model = _shoppingArray[section];
    return model.headCellArray.count;
}

#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer=@"detacell";
    ShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell=[[ShoppingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate = self;
    }
    ShoppingModel *shoppingmodel = _shoppingArray[indexPath.section];
    ShoppingCellModel *cellmodel = shoppingmodel.headCellArray[indexPath.row];
    cellmodel.section = indexPath.section;
    cell.model = cellmodel;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 单选
-(void)ShoppingTableViewCell:(ShoppingCellModel *)model{
    ShoppingModel *headmodel = _shoppingArray[model.section];
    int i = 0;
    for (ShoppingCellModel *cellmodel in headmodel.headCellArray) {
        if ( cellmodel.cellClickState == 1) {
            i++;
        }
    }
    if (i == headmodel.headCellArray.count) {
        headmodel.headClickState = 1;
    }else{
         headmodel.headClickState = 0;
    }
    [self CalculationPrice];
    [self reloadData];
}

#pragma mark 分组全选
-(void)CollocationBtn:(UIButton *)sender{
    ShoppingModel *model = _shoppingArray[sender.tag];
    [self RefreshAllCellState:model];
    [self CalculationPrice];
    [self reloadData];
}

#pragma mark 刷新cell状态
-(void)RefreshAllCellState:(ShoppingModel *)model{
    if (model.headClickState == 1) {
        model.headClickState = 0;
        for (ShoppingCellModel *cellmodel in model.headCellArray) {
            cellmodel.cellClickState = 0;
        }
    }else{
        model.headClickState = 1;
        for (ShoppingCellModel *cellmodel in model.headCellArray) {
            cellmodel.cellClickState = 1;
        }
    }
}

#pragma mark 计算价格
-(void)CalculationPrice{
    //所有商品的总价
    CGFloat allPrict = 0.0;
    //结算处的个数
    NSInteger numInteger = 0;
    //用于判断是否全选
    NSMutableArray *allClickArray = [[NSMutableArray alloc] init];
    //纪录选中的cellModel;
    NSMutableArray *cellModelArray = [[NSMutableArray alloc] init];
    for (ShoppingModel *model in _shoppingArray) {
        //用于判断是否全选，当该数组个数和_shoppingArray个数一样时，说明我选中了全部产品
        if (model.headClickState ==1) {
            [allClickArray addObject:[NSString stringWithFormat:@"%ld",(long)model.headClickState]];
        }
        //纪录每个分组下面的头部 和 尾部 数据的变化
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //纪录搭配下面选中的必选cell，用来和当前该条数据中必选单品做比较，是否讲必选单品都选中，如果都选中了，就会享受搭配折扣，反之不享受，按原价计算
        NSMutableArray *array = [[NSMutableArray alloc] init];
        //每条数据下面的总价
        CGFloat allprice = 0.0;
        for (ShoppingCellModel *cellmodel in model.headCellArray) {
            //计算每个cell的总价
            if (cellmodel.cellClickState == 1) {
                [cellModelArray addObject:cellmodel];
                numInteger = numInteger +1;
                allprice = allprice + cellmodel.goods_num * [cellmodel.goods_price floatValue] ;
            }
            //纪录选中的必选单品
//            if (cellmodel.cellClickState == 1 && cellmodel.mustInteger == 1){
//                [array addObject:cellmodel.ID];
//            }
        }
        // “搭配购” 下面必选单品的id 和 当前选中的必选单品 做比较，如果该搭配下面的必选单品都选中后，则享受搭配折扣，同时我们的头部视图和页尾相应的改变状态
        if ([[self RutrnCellModel:model] isEqualToArray:array] && array.count >0) {
            CGFloat oldprice = allprice;
            CGFloat _newprice = allprice * [model.discount floatValue] * 0.1;
            NSString *string = [NSString stringWithFormat:@"已享受%@折优惠，已减%.2f元",model.discount ,oldprice - _newprice];
            [dict setObject:string forKey:@"headTitle"];
            [dict setObject:[NSString stringWithFormat:@"小计 ¥%.2f",_newprice] forKey:@"footerTitle"];
            [dict setObject:[NSString stringWithFormat:@"  立减 ¥%.2f",oldprice - _newprice] forKey:@"footerMinus"];
            allprice = _newprice;
        }else{
            //说明单品没有被选中或者没有完全选中，提示
            NSString *string = [NSString stringWithFormat:@"选择必选单品,即可享受%@折优惠",model.discount];
            [dict setObject:string forKey:@"headTitle"];
            [dict setObject:[NSString stringWithFormat:@"小计 ¥%.2f",allprice] forKey:@"footerTitle"];
            [dict setObject:@"  立减 ¥0.00" forKey:@"footerMinus"];
        }
        allPrict = allPrict + allprice;
        model.headPriceDict = dict;
    }
    NSDictionary *dict = @{
                           @"cellModel":cellModelArray,
                           @"allPrice":[NSString stringWithFormat:@"￥%.2f",allPrict],
                           @"num":[NSString stringWithFormat:@"%lu",(unsigned long)numInteger],
                           @"allState":allClickArray.count == _shoppingArray.count && _shoppingArray.count>0?@"YES":@"NO"
                           };
    NSNotification *notification =[NSNotification notificationWithName:@"AllPrice" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark 返回 “搭配购” 下面必选单品的id，用于和当前选中的必选单品做比较
-(NSArray *)RutrnCellModel:(ShoppingModel *)model{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ShoppingCellModel *cellmodel in model.headCellArray) {
//        if (cellmodel.mustInteger == 1) {
//            [array addObject:cellmodel.ID];
//        }
    }
    return [array copy];
}

#pragma mark 全选
-(void)allBtn:(BOOL)isbool{
    //当isbool为yes时,是全选状态，为no反之
    if (isbool) {
        for (ShoppingModel *model in _shoppingArray) {
            //选中状态时 model.headClickState = 0; 然后调用 [self RefreshAllCellState:model];改为1
            model.headClickState = 0;
            [self RefreshAllCellState:model];
        }
    }else{
        for (ShoppingModel *model in _shoppingArray) {
            model.headClickState = 1;
            [self RefreshAllCellState:model];
        }
    }
    [self CalculationPrice];
    [self reloadData];
}

#pragma mark 编辑
-(void)editBtn:(BOOL)isbool{
    for (ShoppingModel *model in _shoppingArray) {
        if (!isbool) {
            for (ShoppingCellModel *cellmodel in model.headCellArray) {
                cellmodel.cellEditState = 1;
            }
        }else{
            for (ShoppingCellModel *cellmodel in model.headCellArray) {
                cellmodel.cellEditState = 0;
            }
        }
    }
    [self reloadData];
}

#pragma mark 删除
-(void)deleteBtn:(BOOL)isbool{
    NSMutableArray *headDeleteArray = [[NSMutableArray alloc] init];
    for (ShoppingModel *model in _shoppingArray) {
        if (model.headClickState == 1) {
            [headDeleteArray addObject:model];
        }else{
            NSMutableArray *cellDeleteArray = [[NSMutableArray alloc] init];
            for (ShoppingCellModel *cellmodel in model.headCellArray) {
                if (cellmodel.cellClickState == 1) {
                    [cellDeleteArray addObject:cellmodel];
                }
            }
            NSMutableArray *headcellArray = [NSMutableArray arrayWithArray:model.headCellArray];
            for (ShoppingCellModel *cellmodel in cellDeleteArray) {
                if ([headcellArray containsObject:cellmodel]) {
                    
                    [headcellArray removeObject:cellmodel];
                }
            }
            model.headCellArray = headcellArray;
        }
    }
    NSMutableArray *shopArray = [NSMutableArray arrayWithArray:_shoppingArray];
    for (ShoppingModel *model in headDeleteArray) {
        if ([shopArray containsObject:model]) {
            [shopArray removeObject:model];
        }
    }
    _shoppingArray = shopArray;
    [self CalculationPrice];
    [self reloadData];
}

#pragma mark 响应选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
