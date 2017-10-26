//
//  PhoneViewController.m
//  TCShow
//
//  Created by wxt on 2017/7/17.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()
{
    
    __weak IBOutlet UITextField *phone;
}
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)phone:(id)sender {
    if (phone.text.length==11) {
        [[NSUserDefaults standardUserDefaults] setObject:phone.text forKey:@"userPhone"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self logNoContent];
        return;
    }
    
}

- (void)logNoContent {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入正确格式的电话号码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
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
