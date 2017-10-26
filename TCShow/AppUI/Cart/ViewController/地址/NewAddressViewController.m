//
//  NewAddressViewController.m
//  tangtianshi
//
//  Created by tangtianshi on 16/2/25.
//  Copyright © 2016年 kaxiuzhibo. All rights reserved.
//

#import "NewAddressViewController.h"
#import "NewAddressTableViewCell.h"
#import "HZAreaPickerView.h"
//#import "Masonry.h"
#define address @"address"
@interface NewAddressViewController ()<UITableViewDelegate,UITableViewDataSource,HZAreaPickerDelegate,UITextFieldDelegate>
{
    NSArray *_placeholderArr;
    NSString *_addressStr;
    
    HZAreaPickerView *_locatePicker;
    NSString *_areaValue;
    UITextField *_name;
    UITextField *_phone;
//    UITextField *_zip;
    UITextField *_address;
    UITextView *_detailed;
    NSMutableArray *_userInfoArr;
    
}
@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YCColor(242, 242, 242, 1);
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 20, 15);
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
//    backImageView.image = [UIImage imageNamed:@"btn-left"];
//    [back addSubview:backImageView];
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (_isModify == YES) {
        self.navigationItem.title = @"编辑收货地址";
    }else{
    self.navigationItem.title = @"添加收货地址";
        
    }
    _modifyArr = [[NSMutableArray alloc] init];
    [self createData];
    _name = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, kSCREEN_WIDTH - 95, 30)];
    
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, kSCREEN_WIDTH - 95, 30)];
//    _zip = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, TTSW - 95, 30)];
    _address = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, kSCREEN_WIDTH - 95, 30)];
    _detailed = [[UITextView alloc] initWithFrame:CGRectMake(85, 7, kSCREEN_WIDTH - 95, 60)];
    _userInfoArr = [[NSMutableArray alloc] initWithObjects:_name,_phone,_address,_detailed, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 206) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //设置分割线的风格
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tableview没有数据的时候不显示线
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    _placeholderArr = [NSArray arrayWithObjects:@"收货人:",@"手机号:",@"省市区:",@"详细地址:", nil];
    
    UIButton *manage = [UIButton buttonWithType:UIButtonTypeCustom];
    manage.frame = CGRectMake(0, 0, 40, 15);
    [manage setTitle:@"保存" forState:UIControlStateNormal];
    manage.titleLabel.font = [UIFont systemFontOfSize:17];
    [manage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manage addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartButtonItem = [[UIBarButtonItem alloc] initWithCustomView:manage];
    self.navigationItem.rightBarButtonItem = cartButtonItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)tap{
    [self cancelLocatePicker];

}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewAddressTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewAddressTableViewCell" owner:self options:nil] lastObject];
    }
    cell.title.text = _placeholderArr[indexPath.row];
    [cell addSubview:_userInfoArr[indexPath.row]];
   
    [_userInfoArr[indexPath.row] setFont:[UIFont systemFontOfSize:14]];
    
    if (_isModify == YES && (_modifyArr.count > 0)) {
        [_userInfoArr[indexPath.row] setText:_modifyArr[indexPath.row]];
        
    }
    if (indexPath.row == 2) {
     [_userInfoArr[indexPath.row] setDelegate:self];
    [_userInfoArr[indexPath.row] setText:_addressStr];
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 80;
    }else{
    return 44;
    }
    
}

- (void)save{
    
    if (_isModify == YES) {
        NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"address_id":_aid,@"consignee":_name.text,@"province_name":_provinceStr,@"city_name":_cityStr,@"district_name":_districtStr,@"address":_addressStr,@"mobile":_phone,@"is_default":@"0"};
        
        [RequestData requestWithUrl:ADD_EDIT_ADDRESS para:para Complete:^(NSData *data) {
            
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *code = d[@"code"];
            if ([code intValue] == 0) {
                
            }else{
                
            }
            
        } fail:^(NSError *error) {
            
        }];
        
    }else{
        
        NSDictionary *para = @{@"user_id":[SARUserInfo userId],@"consignee":_name.text,@"province_name":_provinceStr,@"city_name":_cityStr,@"district_name":_districtStr,@"address":_addressStr,@"mobile":_phone.text,@"is_default":@"0"};
        
                [RequestData requestWithUrl:ADD_EDIT_ADDRESS para:para Complete:^(NSData *data) {
        
                    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString *code = d[@"code"];
                    if ([code intValue] == 0) {
                        
                    }else{
                        
                    }
        
                } fail:^(NSError *error) {
                    
                }];
        
        
        [self.navigationController popViewControllerAnimated:YES];
     
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        [self cancelLocatePicker];
        _locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [_locatePicker showInView:self.view];
    }else{

        [self cancelLocatePicker];
        
    }
    
}
/***********************************/

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        _addressStr = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        _provinceStr = picker.locate.state;
        _cityStr = picker.locate.city;
        _districtStr = picker.locate.district;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

-(void)cancelLocatePicker
{
    [_locatePicker cancelPicker];
    _locatePicker.delegate = nil;
    _locatePicker = nil;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    if ([textField.text isEqual:_addressStr]) {
        
        [self cancelLocatePicker];
        _locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [_locatePicker showInView:self.view];
        return NO;
        
    }else{
       
        [self cancelLocatePicker];
        
        return YES;
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    
}

- (void)createData{
    if (_isModify) {
//        [self showHint:@"加载成功"];
        
           [_modifyArr addObject:_arr[@"consignee"]];
           [_modifyArr addObject:_arr[@"mobile"]];
           
           [_modifyArr addObject:_arr[@"place"]];

           [_modifyArr addObject:_arr[@"address"]];
           _addressStr = _modifyArr[2];
           [_tableView reloadData];
  
    }else{
        
        _addressStr = @"";
    }

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
