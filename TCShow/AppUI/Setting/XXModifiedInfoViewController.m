//
//  XXModifiedInfoViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/13.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXModifiedInfoViewController.h"
//#import "TIMElem+ShowDescription.h"
@interface XXModifiedInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation XXModifiedInfoViewController

- (void)viewDidLoad {
    UIBarButtonItem *leftAtem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftAtem;
    
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    [super viewDidLoad];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.borderWidth = 1;
    _label.layer.borderColor = RGB(224, 222, 226).CGColor;
    _textField.placeholder = _placeholderStr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)save{
    NSString *name;
    NSString *job;
    NSString *city;
    if ([self.title isEqualToString:@"用户名"]){
        name = _textField.text;
    }else if([self.title isEqualToString:@"职业"]){
    job = _textField.text;
    }else{
    city = _textField.text;
    }
    [self modifyUserInfoNickname:name sex:nil birthday:nil city:city job:job headsmall:nil];
    
}

- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)modifyUserInfoNickname:(NSString *)nickname sex:(NSString *)sex birthday:(NSString *)birthday city:(NSString *)city job:(NSString *)job headsmall:(UIImage *)headsmall{
    //    NSDictionary *para = @{@"uid":[SARUserInfo userId],@"sex":sex,@"job":job,@"city":city,@"nickname":nickname,@"birthday":birthday,@"headsmall":headsmall};
    //    [para setValue:nickname forKey:@"nickname"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:nickname forKey:@"nickname"];
    [para setValue:[SARUserInfo userId] forKey:@"uid"];
    [para setValue:sex forKey:@"sex"];
    [para setValue:job forKey:@"job"];
    [para setValue:city forKey:@"city"];
    
    [para setValue:birthday forKey:@"birthday"];
    [para setValue:headsmall forKey:@"headsmall"];
    
    [RequestData requestWithUrl:MODIFY_USER_INFO para:para Complete:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] doubleValue] == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"修改成功"];
             [self.navigationController popViewControllerAnimated:YES];
            [[IMAPlatform sharedInstance].host asyncProfile];
            
        }
    } fail:^(NSError *error) {
    }];
    
    
    
}
@end
