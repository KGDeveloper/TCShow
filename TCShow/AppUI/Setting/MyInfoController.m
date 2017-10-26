//
//  MyInfoController.m
//  TCShow
//
//  Created by tangtianshi on 16/9/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MyInfoController.h"

@interface MyInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;

@end

@implementation MyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.iconImage.layer.cornerRadius = 35/2;
    self.iconImage.layer.masksToBounds = YES;
    self.nicknameTF.delegate = self;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX([[SARUserInfo gainUserInfo] objectForKey:@"headsmall"])] placeholderImage:IMAGE(@"default_head")];
    self.nicknameTF.text = [[SARUserInfo gainUserInfo] objectForKey:@"nickname"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}


-(void)loadData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [SARUserInfo userId];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:URL_INFO parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            hud.hidden = YES;
//            [user setObject:responseObject[@"data"][@"img"] forKey:@"icon"];
//            [user setObject:responseObject[@"data"][@"nickname"] forKey:@"nickname"];
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(responseObject[@"data"][@"img"])] placeholderImage:[UIImage imageNamed:@"default_head"]];
            self.nicknameTF.text = responseObject[@"data"][@"nickname"];
//            [user setObject:@"已加载" forKey:@"already"];
            [SARUserInfo saveUserInfo:responseObject[@"data"]];
            
        }else{
            hud.labelText = responseObject[@"message"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"加载失败";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
        
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.view endEditing:YES];
    [self changeNickname];
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改昵称
-(void)changeNickname{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [user objectForKey:@"uid"];
    params[@"nickname"] = self.nicknameTF.text;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:URL_CHANGEICON parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            hud.labelText = @"修改昵称成功";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            [user setObject:self.nicknameTF.text forKey:@"nickname"];
            [user synchronize];
        }else{
            hud.labelText = responseObject[@"message"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"修改昵称失败";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet *photoSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
   
    switch (indexPath.row) {
        case 0:
             [photoSheet showInView:self.view];
            
            break;
        case 1:
            
            [self.nicknameTF becomeFirstResponder];
            break;
        default:
            break;
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self selectForCameraButtonClick];
    }else if (buttonIndex == 1){
        [self selectForAlbumButtonClick];
    }
    
}
#pragma mark - 相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)  withObject:image afterDelay:0.5];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _iconImage.image = image;
    
    //    _cameraImage.hidden = YES;
    // 保存到本地 上传到服务器
    //    _photoImage.image = image;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //下面是iOS两种获取图片的方法，一种获取为jpeg，一种获取为png
    //转为jpeg上传可以让图片的大小压缩
    
    //UIImageJPEGRepresentation(image, 0.5); //0.5是压缩的比例
    //NSData *imageData = UIImagePNGRepresentation(image);
    
    
    //上传头像
    
    NSDictionary *paras = @{@"uid":[user objectForKey:@"uid"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URL_CHANGEICON parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //使用日期生成图片名称
        NSData *imageData = UIImagePNGRepresentation(image);
        //NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        
        [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //上传图片成功执行回调
        [user setObject:responseObject[@"data"][@"img"] forKey:@"icon"];
        [user synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //上传图片失败执行回调
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"上传图片失败";
        hud.mode = MBProgressHUDModeCustomView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
    
    
}
// 按取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)saveImage:(UIImage *)image {
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"XDSelfPhoto.jpg"];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(95.0f, 95.0f)];//将图片尺寸改为80*80
    // UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(95, 95)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:imageFilePath forKey:@"headsmallPath"];
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //_iconImg.image = selfPhoto;
    self.iconImage.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请开启图库访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

@end
