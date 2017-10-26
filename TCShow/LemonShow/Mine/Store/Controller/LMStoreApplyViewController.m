//
//  LMStoreApplyViewController.m
//  TCShow
//
//  Created by 王孟 on 2017/8/25.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LMStoreApplyViewController.h"
#import "TZImagePickerController.h"

@interface LMStoreApplyViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shenFenZhengTF;
@property (weak, nonatomic) IBOutlet UITextField *dianPuTF;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIImageView *cartImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *cartImageTwo;



@end

@implementation LMStoreApplyViewController {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    NSMutableArray *_selCodeImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请开店";
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _selCodeImages = [NSMutableArray array];
    _codeImage.userInteractionEnabled = YES;
    _cartImageOne.userInteractionEnabled = YES;
    _cartImageTwo.userInteractionEnabled = YES;
    _cartImageTwo.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    [_codeImage addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    [_cartImageTwo addGestureRecognizer:tap2];
    [_cartImageOne addGestureRecognizer:tap2];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"申请" style:UIBarButtonItemStyleDone target:self action:@selector(update)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    [self update];
}

- (void)update {
    if (_selCodeImages.count == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请上传收款二维码"];
        return;
    }
    if (_selectedPhotos.count != 2) {
        [[HUDHelper sharedInstance] tipMessage:@"请上传身份证正反面照片"];
        return;
    }
    if ([_shenFenZhengTF.text isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入身份证号"];
        return;
    }
    if ([_dianPuTF.text isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入店铺名称"];
        return;
    }
    
    //上传身份证照片 二维码 身份证号 店铺名
    NSDictionary *dict = @{@"uid":[SARUserInfo userId],
                           @"real_name":_dianPuTF.text,
                           @"idcard":_shenFenZhengTF.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:APPLY_ORDER parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (UIImage *obj in _selCodeImages ) {
            
            UIImage *eachImg = obj;
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            dateformatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
            
            [formData appendPartWithFileData:eachImgData name:@"original_img.jpg" fileName:@"original_img.jpg" mimeType:@"image/jpg"];
        }
        
        for(int i=0; i<2; i++) {
            
            
            UIImage *contentImg = _selectedPhotos[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSData *contentData = UIImageJPEGRepresentation(contentImg, 0.5);
            
            NSString *fileName = [NSString stringWithFormat:@"idcard_images%d.jpg", i];
            
            
            [formData appendPartWithFileData:contentData name:fileName
                                    fileName:fileName mimeType:@"image/jpg"];
            
            
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        
        if (dict[@"code"] == 0) {
            [[HUDHelper sharedInstance] tipMessage:dict[@"message"]];
        }else {
            [[HUDHelper sharedInstance] tipMessage:dict[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:@"请求失败"];
    }];

}

- (void)tap2 {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"身份证正反面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"手机相册选择" otherButtonTitles: nil];
    action.tag = 2;
    [action showInView:self.view];
}

- (void)tap1 {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"收款二维码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"手机相册选择" otherButtonTitles: nil];
    action.tag = 1;
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        [self selectForAlbumButtonClick];
    }else if (actionSheet.tag == 2){
        [self pushImagePickerController];
    }
    
}

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:[@"2" integerValue] columnNumber:[@"4" integerValue] delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    //    _img.image = _selectedPhotos[0];
    _cartImageOne.hidden = YES;
    _cartImageTwo.hidden = YES;
    for (int i = 0; i < _selectedPhotos.count; i++) {
        if (i == 0) {
            _cartImageOne.image = _selectedPhotos[i];
            _cartImageOne.hidden = NO;
        }else if (i == 1) {
            _cartImageTwo.image = _selectedPhotos[i];
            _cartImageTwo.hidden = NO;
        }
        
    }
    
    // 1.打印图片名字
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
    //生成一个包存储图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  
    
    _codeImage.image = image;
    [_selCodeImages removeAllObjects];
    [_selCodeImages addObject:image];
    NSDictionary *dict = @{@"uid":[SARUserInfo userId]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:APPLY_ORDER parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        UIImage *eachImg = [UIImage imageNamed:@"zanwu"];
//        NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"original_img" fileName:@"original_img.jpg" mimeType:@"image/jpg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    [self upLoadLiveCoverimage:image succ:^(NSString *msg, id data) {
        
    } fail:^(NSString *error) {
        
    }];
    
    
}


//判断照片是否上传成功
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



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_shenFenZhengTF resignFirstResponder];
    [_dianPuTF resignFirstResponder];
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
