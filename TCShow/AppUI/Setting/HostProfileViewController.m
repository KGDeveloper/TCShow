//
//  HostProfileViewController.m
//  TCShow
//
//  Created by AlexiChen on 16/5/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "HostProfileViewController.h"
#import "HostProfileTableViewCell.h"
#import "XXModifiedInfoViewController.h"
#import "XDDateView.h"
#import "AdressController.h"
#import "TCLoginViewController.h"

@implementation HostProfileViewController
{
    NSArray *_titleArr1;
    NSArray *_titleArr2;
    NSMutableDictionary *_dataDic;
    MJRefreshNormalHeader *_header;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = RGB(235, 235, 241);
    //tableview没有数据的时候不显示线
    //设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = LEMON_MAINCOLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = btn;

    _titleArr1 = @[@"头像",@"用户名",@"直播号",@"性别",@"年龄",@"家乡"];
    _titleArr2 = @[@"职业",@"收货地址"];
//    _dataDic = [NSMutableDictionary dictionary];
//    [self setUpRefresh];
    
}

- (void)backBtnClick {
    [self onExit];
}

- (void)onExit
{
    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    
    [[IMAPlatform sharedInstance] logout:^{
        
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:0.5 completion:^{
            
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartAPPWMENG"];
            [[AppDelegate sharedAppDelegate] enterLoginUI];
            
//            TCLoginViewController *vc = [[TCLoginViewController alloc]init];
//            
//            [self presentViewController:vc animated:YES completion:nil];
            
            /*判断用户登录**/
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"already"];
            [SARUserInfo removeUserInfo];
            [user removeObjectForKey:@"user_login_type"];
            [user removeObjectForKey:WX_ACCESS_TOKEN];
            [user removeObjectForKey:WX_OPEN_ID];
            
            [user synchronize];
        }];
        
    } fail:^(int code, NSString *err) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
    }];
}


- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }else{
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HostProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HostProfileTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HostProfileTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.contentStr.hidden = YES;
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 45, 45)];
            [img cornerViewWithRadius:45/2.0];
            [cell.contentView addSubview:img];
            if (_dataDic) {
                [img sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(_dataDic[@"headsmall"])]];
            }
           
        }else if (indexPath.row == 1){
            if (_dataDic[@"nickname"]) {
               cell.contentStr.text = _dataDic[@"nickname"];
            }else{
            cell.contentStr.text = @"未填写";
            }
        }else if (indexPath.row == 2){
            if (_dataDic[@"livenum"]) {
                cell.contentStr.text = _dataDic[@"livenum"];
            }else{
                cell.contentStr.text = @"未填写";
            }
        }else if (indexPath.row == 3){
            if ([_dataDic[@"sex"] doubleValue] == 1) {
                cell.contentStr.text = @"男";
            }else if([_dataDic[@"sex"] doubleValue] == 2){
                cell.contentStr.text = @"女";
            }else{
            cell.contentStr.text = @"未填写";
            }
        }else if (indexPath.row == 4){
            if ([_dataDic[@"birthday"] doubleValue] != 0) {

                NSString *str=_dataDic[@"birthday"];//时间戳
                NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
             
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
               
               
               
                
                //生日
                NSDate *birthDay = [dateFormatter dateFromString:currentDateStr];
                //当前时间
                NSString *DateStr = [dateFormatter stringFromDate:[NSDate date]];
                NSDate *currentDate = [dateFormatter dateFromString:DateStr];
                NSTimeInterval timetime = [currentDate timeIntervalSinceDate:birthDay];
                int age = ((int)timetime)/(3600*24*365);

                 cell.contentStr.text = [NSString stringWithFormat:@"%d",age];
                
            }else{
                cell.contentStr.text = @"未填写";
            }
        }else{
            if (![_dataDic[@"city"] isEqualToString:@""]) {
                cell.contentStr.text = _dataDic[@"city"];
            }else{
                cell.contentStr.text = @"未填写";
            }
        }
        
        cell.textLabel.text = _titleArr1[indexPath.row];
    }else{
        if (indexPath.row == 0) {
            
            if (![_dataDic[@"job"] isEqualToString:@""]) {
                cell.contentStr.text = _dataDic[@"job"];
            }else{
                cell.contentStr.text = @"未填写";
            }

            
        }else{
            cell.contentStr.hidden = YES;
        }
        cell.textLabel.text = _titleArr2[indexPath.row];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.contentStr.textColor = RGB(152, 152, 152);
    cell.contentStr.font = [UIFont systemFontOfSize:16];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
          // 头像
//            @"拍照",@"手机相册选择",@"取消"
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"手机相册选择", nil];
            action.tag = 1;
            [action showInView:self.view];
            
        }else if (indexPath.row == 1){
        // 用户名
            XXModifiedInfoViewController *modified = [[XXModifiedInfoViewController alloc] init];
            modified.placeholderStr = @"请输入用户名(最多20个字)";
            modified.title = @"用户名";
            [self.navigationController pushViewController:modified animated:YES];
            
        }else if (indexPath.row == 2){
            // 直播号
            
        }else if (indexPath.row == 3){
            // 性别
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
            action.tag = 2;
            [action showInView:self.view];

        }else if (indexPath.row == 4){
            // 年龄
            XDDateView *dateView = [XDDateView XDDateView];
            dateView.clickBtnActionBlock = ^(NSString *dateStr){
                
                //计算年龄
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                //生日
                NSDate *birthDay = [dateFormatter dateFromString:dateStr];
                //当前时间
                NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
                NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
                int age = ((int)time)/(3600*24*365);
               
             
                NSMutableString *biethStr = [NSMutableString stringWithString:dateStr];
                [biethStr replaceCharactersInRange:NSMakeRange(4, 1) withString:@"/"];
                [biethStr replaceCharactersInRange:NSMakeRange(7, 1) withString:@"/"];
              
                [self modifyUserInfoNickname:nil sex:nil birthday:biethStr city:nil job:nil headsmall:nil];
            };

        }else{
        // 家乡
           
            XXModifiedInfoViewController *modified = [[XXModifiedInfoViewController alloc] init];
            modified.placeholderStr = @"您的家乡";
            modified.title = @"家乡";
            [self.navigationController pushViewController:modified animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
          // 职业
            XXModifiedInfoViewController *modified = [[XXModifiedInfoViewController alloc] init];
            modified.placeholderStr = @"您的职业";
            modified.title = @"职业";
            [self.navigationController pushViewController:modified animated:YES];
            
        }else{
        // 收货地址
            AdressController *adress = [[AdressController alloc] init];
            [self.navigationController pushViewController:adress animated:YES];
        }
    
    }


}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self selectForCameraButtonClick];
        }else if(buttonIndex == 1){
            [self selectForAlbumButtonClick];
        }
    }else if (actionSheet.tag == 2){
        NSString *sex;
        if (buttonIndex == 0) {
        sex = @"1";
        }else if(buttonIndex == 1){
          sex = @"2";
        }
        [self modifyUserInfoNickname:nil sex:sex birthday:nil city:nil job:nil headsmall:nil];
    }
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//访问相册
-(void)selectForAlbumButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"访问图片库错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}
//访问摄像头
-(void)selectForCameraButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置中开启照相功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }
}

#pragma mark - 相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     NSData *imgData = UIImagePNGRepresentation(image);
    [self upLoadLiveCoverimage:image succ:^(NSString *msg, id data) {
        
    } fail:^(NSString *error) {
        
    }];

    
}



-(void)setUpRefresh{
    
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(createData)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

- (void)createData{
    NSDictionary *para = @{@"phone":[SARUserInfo userPhone],@"uid":[SARUserInfo userId]};
    
    [RequestData requestWithUrl:GET_USER_INFO para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {

//            [_dataDic setDictionary:dic[@"data"]];
            _dataDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
        }else{
        // error
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];


}

- (void)modifyUserInfoNickname:(NSString *)nickname sex:(NSString *)sex birthday:(NSString *)birthday city:(NSString *)city job:(NSString *)job headsmall:(NSData *)headsmall{
//    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"sex":sex,@"job":job,@"city":city,@"nickname":nickname,@"birthday":birthday,@"headsmall":headsmall};
//    [para setValue:nickname forKey:@"nickname"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
     [para setValue:[SARUserInfo userId] forKey:@"uid"];
     [para setValue:sex forKey:@"sex"];
     [para setValue:job forKey:@"job"];
     [para setValue:city forKey:@"city"];
     [para setValue:nickname forKey:@"nickname"];
     [para setValue:birthday forKey:@"birthday"];
     [para setValue:headsmall forKey:@"headsmall"];
    
    
    [RequestData requestWithUrl:MODIFY_USER_INFO para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] doubleValue] == 0) {
            [self.tableView.header beginRefreshing];
        }

        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    

}

-(void)upLoadLiveCoverimage:(UIImage *)image succ:(businessSucc)succ fail:(businessFail)fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     [params setValue:[SARUserInfo userId] forKey:@"uid"];
    
    [manager POST:MODIFY_USER_INFO parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image != nil)
        {
            [formData appendPartWithFileData:
             UIImageJPEGRepresentation(image, 0.5) name:@"headsmall" fileName:@"headsmall_image.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (0 == [[responseObject objectForKey:@"code"] integerValue])
        {
            if (succ)
            {
                succ(@"上传图片成功", responseObject[@"data"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"上传图片失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
        {
            fail(@"上传图片失败");
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setUpRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


@end
