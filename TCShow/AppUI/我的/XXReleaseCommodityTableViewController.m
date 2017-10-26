//
//  XXReleaseCommodityTableViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "XXReleaseCommodityTableViewController.h"
#import "XXNoticeViewController.h"
#import "TCGoodsTypeController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TypeListViewController.h"

@interface XXReleaseCommodityTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ReleaseForTypeDelegate,UIAlertViewDelegate,TZImagePickerControllerDelegate,PassingValueDelegate,PassingValueDelegate>{
    NSString * _goodsTypeId;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imgThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgFour;



@property (weak, nonatomic) IBOutlet UITextField *goodsTitleTF;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeName;
@property (weak, nonatomic) IBOutlet UILabel *describeStr;
@property (nonatomic,strong)NSMutableArray * typeArray;
@property (nonatomic,strong)NSMutableArray * remarkArray;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation XXReleaseCommodityTableViewController
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"发布宝贝";
    self.tabBarController.tabBar.hidden = YES;
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _typeArray = [NSMutableArray array];
    _remarkArray = [NSMutableArray array];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kSCREEN_HEIGHT - 114, kSCREEN_WIDTH, 50);
    [btn setTitle:@"立即发布" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.backgroundColor = kNavBarThemeColor;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(Release) forControlEvents:UIControlEventTouchUpInside];
    [_img cornerViewWithRadius:30];
    [_imgTwo cornerViewWithRadius:30];
    [_imgThree cornerViewWithRadius:30];
    [_imgFour cornerViewWithRadius:30];
    _img.userInteractionEnabled = YES;
    _imgTwo.userInteractionEnabled = YES;
    _imgThree.userInteractionEnabled = YES;
    _imgFour.userInteractionEnabled = YES;
    _imgTwo.hidden = YES;
    _imgThree.hidden = YES;
    _imgFour.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img:)];
    [_imgFour addGestureRecognizer:tap];
    [_imgThree addGestureRecognizer:tap];
    [_imgTwo addGestureRecognizer:tap];
    [_img addGestureRecognizer:tap];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
}


#pragma mark -------返回按钮点击
-(void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---------上传图片
- (void)img:(UITapGestureRecognizer *)img{

    __weak typeof(self) ws = self;
    UIActionSheet *testSheet = [[UIActionSheet alloc] init];//[UIActionSheet bk_actionSheetWithTitle:@"请选择照片源"];
    [testSheet bk_addButtonWithTitle:@"拍照" handler:^{
        [ws takePhoto];
        
    }];
    [testSheet bk_addButtonWithTitle:@"相册" handler:^{
        [ws pushImagePickerController];
    }];
    [testSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [testSheet showInView:self.view];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:[@"4" integerValue] columnNumber:[@"4" integerValue] delegate:self pushPhotoPickerVc:YES];
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


#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
        }
    }
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
    _img.hidden = YES;
    _imgTwo.hidden = YES;
    _imgThree.hidden = YES;
    _imgFour.hidden = YES;
    for (int i = 0; i < _selectedPhotos.count; i++) {
        if (i == 0) {
            _img.image = _selectedPhotos[0];
            _img.hidden = NO;
        }else if (i == 1) {
            _imgTwo.image = _selectedPhotos[i];
            _imgTwo.hidden = NO;
        }else if (i == 2) {
            _imgThree.image = _selectedPhotos[i];
            _imgThree.hidden = NO;
        }else if (i == 3) {
            _imgFour.image = _selectedPhotos[i];
            _imgFour.hidden = NO;
        }
    }

    // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _img.image = _selectedPhotos[0];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // (@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _img.image = _selectedPhotos[0];
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
    }
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

#pragma mark --------立即发布
- (void)Release{
    if (_selectedPhotos.count == 0)
    {
        [_img shake];
        [[HUDHelper sharedInstance] tipMessage:@"请上传商品图片"];
        return;
    }
    if (_goodsTitleTF.text.length == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请添加商品标题"];
        return ;
    }
    [[HUDHelper sharedInstance]syncLoading:@"正在添加。。。"];

    [[Business sharedInstance] releaseGoodsUid:[SARUserInfo userId] cat_id:_goodsTypeId goods_name:_goodsTitleTF.text shop_price:_price.text store_count:_number.text goods_remark:_remarkArray goods_standard:_typeArray original_img:_selectedPhotos goods_content:nil succ:^(NSString *msg, id data) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:msg];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSString *error) {
        
        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
    }];
   // [[Business sharedInstance] releaseGoodsUid:[SARUserInfo userId] cat_id:_goodsTypeId goods_name:_goodsTitleTF.text shop_price:_price.text store_count:_number.text goods_remark:_describeStr.text original_img:_selectedPhotos goods_content:nil succ:^(NSString *msg, id data) {
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:msg];
//        [self.navigationController popViewControllerAnimated:YES];
//    
//    } fail:^(NSString *error) {
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:error];
//    }];
    
}
    

#pragma mark -------tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        // 分类
        TCGoodsTypeController * typeController = [[TCGoodsTypeController alloc]init];
        typeController.typeDelegate = self;
        [self.navigationController pushViewController:typeController animated:YES];
    }else if (indexPath.row == 2){
        // 价格
    }else if (indexPath.row == 3){
        // 库存
    }else if (indexPath.row == 4){
        // 类型
        TypeListViewController *typeListController = [[TypeListViewController alloc]init];
        typeListController.sendArr = ^(NSMutableArray *sendArr) {
            
            _typeArray = [NSMutableArray array];
            
            _typeArray = sendArr;
        };
        [self.navigationController pushViewController:typeListController animated:YES];
        
    }else if (indexPath.row == 5){
        // 描述
        XXNoticeViewController *notice = [[XXNoticeViewController alloc] init];
        notice.strDelegate = self;
        [self.navigationController pushViewController:notice animated:YES];
        
    }else{
        // 发货地
    }
}


- (void) sendArray:(NSArray *)arr type:(NSString *)type
{
    _remarkArray = arr;
    _describeStr.text = type;
}

#pragma mark -遵守AddGoodsListDelegate-
- (void) sendArr:(NSMutableArray *)arr
{
    _typeArray = arr;
}


#pragma mark -------------releaseTypeDelegate
-(void)releaseGoodsUid:(NSString *)goodsUid goodsName:(NSString *)goodsName{
    self.goodsTypeName.text = goodsName;
    _goodsTypeId = goodsUid;
}


@end
