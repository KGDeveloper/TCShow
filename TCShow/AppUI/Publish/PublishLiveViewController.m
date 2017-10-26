//
//  PublishLiveViewController.m
//  TCShow
//
//  Created by AlexiChen on 15/11/23.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "PublishLiveViewController.h"

@implementation PublishLiveViewController

// 本地保存的通信息

//#define kShowLocationOnPublish                  @"kShowLocationOnPublish"

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.title = @"直播";
#if kIsMeasureSpeed
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测速" style:UIBarButtonItemStylePlain target:self action:@selector(onTestSpeed)];
#endif
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBlank:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self registerKeyBoardNotification];
    
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    _locationSwitch.on = host.showLocation;
    [self onTurnLoc:_locationSwitch];
    
    [self loadLiveCover];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)loadLiveCover
{
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    NSString *liveCover = [host liveCover];
    if (liveCover)
    {
        [_publishContent sd_setImageWithURL:[NSURL URLWithString:liveCover] placeholderImage:nil];
        _lableCover.hidden = YES;
    }
}


- (void)onClose:(UIButton *)btn
{
    [_publishTitle resignFirstResponder];
    
    [[AppDelegate sharedAppDelegate] dismissViewController:self animated:YES completion:nil];
}

#pragma mark - 上传图片
- (void)uploadImage
{
    if (!_publishContent.image)
    {
        [_publishContent shake];
        return;
    }
    
    if (_publishTitle.text.length == 0)
    {
        [_publishTitle shake];
        return;
    }
    _publishBtn.enabled = NO;
    _publishInteractBtn.enabled = NO;
    __weak PublishLiveViewController *ws = self;
    __weak UIButton *wp = _publishBtn;
    __weak UIButton *wpi = _publishInteractBtn;
    
    
    [[Business sharedInstance] upLoadLiveCover:2 phone:[IMAPlatform sharedInstance].host.imUserId image:_publishContent.image succ:^(NSString* msg, id data){
        
        
        //保存到相册
        TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
        host.liveCover = [NSString stringWithFormat:IMG_PREFIX,data];
        [ws startLive];
        wp.enabled = YES;
        wpi.enabled = YES;
        
        TCAVLog(([NSString stringWithFormat:@"*** clogs.host.createRoom|%@|upload room info to server|room id %d",host.imUserId, host.avRoomId]));
        
         } fail:^(NSString *error){
             
             wp.enabled = YES;
             wpi.enabled = YES;
             [[HUDHelper sharedInstance] tipMessage:error];
             
             [ws startLive];
        
    }];
    
//    [[UploadImageHelper shareInstance] upload:_publishContent.image completion:^(NSString *imageSaveUrl) {
//
//        //保存到相册
//        TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
//        host.liveCover = imageSaveUrl;
//        [ws startLive];
//        wp.enabled = YES;
//        wpi.enabled = YES;
//        
//        TCAVLog(([NSString stringWithFormat:@"*** clogs.host.createRoom|%@|upload room info to server|room id %d",host.imUserId, host.avRoomId]));
//        
//    } failed:^(NSString *failTip) {
//
//        wp.enabled = YES;
//        wpi.enabled = YES;
//        [[HUDHelper sharedInstance] tipMessage:failTip];
//        
//        [ws startLive];
//    }];
}

#pragma mark - 发布

- (void)onTestSpeed
{
   
#if kIsMeasureSpeed
    [[IMAPlatform sharedInstance] requestTestSpeed];
#endif
}

- (void)onPublishInteract
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.selectedIndex = 0;
//    _isPublishInteractLive = YES;
    [self onPublish];
}

- (void)onPublish
{
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        return;
    }
    
    
}

- (void)startLive
{
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    NSString *liveCover = [host liveCover];
    
    TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
    if (_publishTitle.text.length)
    {
        liveRoom.title = _publishTitle.text;
    }
    else
    {

        liveRoom.title = [NSString stringWithFormat:@"%@ Live", [host imUserName]];

    }
    liveRoom.cover = liveCover;
    liveRoom.live_type = @"热门直播";
    TCShowUser *user = [[TCShowUser alloc] init];
    user.avatar = [host imUserIconUrl];
    user.phone = [host imUserId];
    user.username = [host imUserName];
    user.uid = [[SARUserInfo gainUserInfo]objectForKey:@"uid"];
    
    liveRoom.host = user;
    liveRoom.avRoomId = [host avRoomId];
    
    LocationItem *lbs = host.lbsInfo;
    if (lbs && _locationSwitch.on)
    {
        liveRoom.lbs = lbs;
    }
    
    if (_isPublishInteractLive)
    {
#if kSupportMultiLive
        TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:liveRoom user:host];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
#endif
    }
    else
    {
        TCShowLiveViewController *vc = [[TCShowLiveViewController alloc] initWith:liveRoom user:host];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
    
    
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    return [_publishTitle shouldChangeTextInRange:range replacementText:text];
//}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_publishTitle updateLimitText];
}

#pragma mark - reg & unreg notification

- (void)registerKeyBoardNotification
{
    if ([IOSDeviceConfig sharedConfig].isIPhone4)
    {
        //添加键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)onKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (kbSize.height > _publishTitle.frame.origin.y)
    {
        kbSize.height = _publishTitle.frame.origin.y - _publishTitle.frame.size.height;
    }
    _scrollView.contentOffset = CGPointMake(0, kbSize.height);
    _scrollView.scrollEnabled = NO;
}

- (void)onKeyboardWillHide:(NSNotification*)aNotification
{
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.scrollEnabled = YES;
}

- (void)addPublishContent
{
    _publishContent = [[UIImageView alloc] init];
    _publishContent.backgroundColor = kLightGrayColor;
    
    _lableCover = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    [_lableCover setImage:[UIImage imageNamed:@"publishcover"] forState:UIControlStateNormal];
    [_lableCover setImage:[UIImage imageNamed:@"publishcover_hover"] forState:UIControlStateHighlighted];
    [_lableCover setTitle:@"给你的直播设置一个满意的封面" forState:UIControlStateNormal];
    _lableCover.titleLabel.font = kAppMiddleTextFont;
    _lableCover.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_lableCover setTitleColor:[kWhiteColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [_lableCover addTarget:self action:@selector(onLoadPublishLiveCover) forControlEvents:UIControlEventTouchUpInside];
    [_publishContent addSubview:_lableCover];
    [_scrollView addSubview:_publishContent];
    
    _publishContent.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPublishContent:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_publishContent addGestureRecognizer:tap];
}

- (void)onClickBlank:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [_publishTitle resignFirstResponder];
    }
}



- (void)onClickPublishContent:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self onLoadPublishLiveCover];
    }
}

- (void)onLoadPublishLiveCover
{
    if ([_publishTitle isFirstResponder])
    {
        [_publishTitle resignFirstResponder];
        return;
    }
    [self callImagePickerActionSheet];
}

- (void)addOwnViews
{
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    
    [self addPublishContent];
    
    _publishTitle = [[UILimitTextView alloc] init];
    _publishTitle.textColor = kBlackColor;
    _publishTitle.placeHolder = @"请输入直播标题";
    _publishTitle.textAlignment = NSTextAlignmentCenter;

    [_publishTitle setFont:kAppMiddleTextFont];
    _publishTitle.delegate = self;
    _publishTitle.placeHolderColor = kLightGrayColor;
    _publishTitle.mainTextColor = kBlackColor;
    _publishTitle.layer.borderWidth = 1.0;
    _publishTitle.layer.borderColor = [kBlackColor colorWithAlphaComponent:0.1].CGColor;
    _publishTitle.limitLength = 32;
    [_scrollView addSubview:_publishTitle];
    
    _locationPanel = [[UIView alloc] init];
    _locationPanel.backgroundColor = kWhiteColor;
    _locationPanel.layer.borderWidth = 1.0;
    _locationPanel.layer.borderColor = [kBlackColor colorWithAlphaComponent:0.1].CGColor;
    [_scrollView addSubview:_locationPanel];
    
    _location = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightLeft];
    [_location setImage:[UIImage imageNamed:@"position_gray"] forState:UIControlStateNormal];
    [_location setImage:[UIImage imageNamed:@"position_red"] forState:UIControlStateSelected];
    [_location setTitle:@"不显示位置" forState:UIControlStateNormal];
    [_location setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    _location.titleLabel.font = kAppMiddleTextFont;
    [_locationPanel addSubview:_location];
    
    _locationSwitch = [[UISwitch alloc] init];
    [_locationSwitch addTarget:self action:@selector(onTurnLoc:) forControlEvents:UIControlEventValueChanged];
    [_locationPanel addSubview:_locationSwitch];
    
    _publishBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_publishBtn addTarget:self action:@selector(onPublishInteract) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.backgroundColor = RGBOF(0XDC4B53);
    [_publishBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [_publishBtn.titleLabel setFont:kAppMiddleTextFont];
    [_publishBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
#if kSupportMultiLive
    _publishBtn.layer.cornerRadius = 6;
    _publishBtn.layer.masksToBounds = YES;
#else
    
#endif
    [self.view addSubview:_publishBtn];
    _publishBtn.hidden = YES;
    
    _publishInteractBtn = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightCenter];
    [_publishInteractBtn addTarget:self action:@selector(onPublishInteract) forControlEvents:UIControlEventTouchUpInside];
    _publishInteractBtn.backgroundColor = RGBOF(0XDC4B53);
    [_publishInteractBtn setTitle:@"开始互动直播" forState:UIControlStateNormal];
    [_publishInteractBtn.titleLabel setFont:kAppMiddleTextFont];
    [_publishInteractBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
#if kAppStoreVersion
#else
#if kSupportMultiLive
    _publishInteractBtn.layer.cornerRadius = 6;
    _publishInteractBtn.layer.masksToBounds = YES;
#else
    _publishInteractBtn.hidden = YES;
#endif
    
#endif
    [self.view addSubview:_publishInteractBtn];
}


- (void)onTurnLoc:(UISwitch *)sw
{
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    host.showLocation = sw.on;
    if (sw.on)
    {
        NSString *address = host.lbsInfo.address;
        if (address == nil)
        {
            [host startLbs];
            [_location setTitle:@"正在定位" forState:UIControlStateNormal];
            [_location setTitleColor:kBlackColor forState:UIControlStateNormal];
            _location.selected = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetAddressSucc) name:kTCShow_LocationSuccNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetAddressFail) name:kTCShow_LocationFailNotification object:nil];
        }
        else
        {
            [_location setTitle:address forState:UIControlStateNormal];
            [_location setTitleColor:kBlackColor forState:UIControlStateNormal];
            _location.selected = YES;
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kTCShow_LocationSuccNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kTCShow_LocationFailNotification object:nil];
        
        [_location setTitle:@"不显示位置" forState:UIControlStateNormal];
        [_location setTitleColor:kLightGrayColor forState:UIControlStateNormal];
        _location.selected = NO;
    }
}

- (void)onGetAddressSucc
{
    if (_locationSwitch.on)
    {
        TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
        NSString *address = host.lbsInfo.address;
        if (address)
        {
            [_location setTitle:address forState:UIControlStateNormal];
            [_location setTitleColor:kBlackColor forState:UIControlStateNormal];
            _location.selected = YES;
        }
        
    }
    else
    {
        [_location setTitle:@"不显示位置" forState:UIControlStateNormal];
        [_location setTitleColor:kLightGrayColor forState:UIControlStateNormal];
        _location.selected = NO;
    }
}

- (void)onGetAddressFail
{
    if (_locationSwitch.on)
    {
        NSString *address = @"获取位置失败";
        
        [_location setTitle:address forState:UIControlStateNormal];
        [_location setTitleColor:kBlackColor forState:UIControlStateNormal];
        _location.selected = YES;
    }
    else
    {
        [_location setTitle:@"不显示位置" forState:UIControlStateNormal];
        [_location setTitleColor:kGrayColor forState:UIControlStateNormal];
        _location.selected = NO;
    }
}

- (CGSize)publishSize
{
    return CGSizeMake(_scrollView.bounds.size.width, (NSInteger)(_scrollView.bounds.size.width * 0.618));
}

- (void)layoutOnIPhone
{
    [_scrollView sizeWith:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    

    
    
    
    CGSize pubSize = [self publishSize];
    [_publishContent sizeWith:pubSize];
    if (_lableCover)
    {
        NSInteger off = (pubSize.height - 120)/2;
        _lableCover.margin = UIEdgeInsetsMake(off, 0, off, 0);
        [_lableCover sizeWith:[self publishSize]];
        [_lableCover alignParentCenter];
    }
    
    
    [_publishTitle sizeWith:CGSizeMake(_scrollView.bounds.size.width, 100)];
    [_publishTitle layoutBelow:_publishContent margin:0];
    
    [_locationPanel sizeWith:CGSizeMake(_scrollView.bounds.size.width, 50)];
    [_locationPanel layoutBelow:_publishTitle margin:-1];                 //-1是为了让边缘重合
    
    [_locationSwitch sizeWith:CGSizeMake(100, 24)];
    [_locationSwitch alignParentRight];
    [_locationSwitch alignParentRightWithMargin:kDefaultMargin];
    [_locationSwitch layoutParentVerticalCenter];
    
    [_location sizeWith:CGSizeMake(80, 24)];
    [_location alignParentLeftWithMargin:kDefaultMargin];
    [_location scaleToLeftOf:_locationSwitch margin:kDefaultMargin];
    [_location layoutParentVerticalCenter];
    
    CGRect rect = _location.frame;
    if (rect.origin.y + rect.size.height + kDefaultMargin > _scrollView.bounds.size.height)
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, rect.origin.y + rect.size.height + kDefaultMargin);
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height)];//将发布按钮显示出来
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 0);
    }
    
    
//#if kAppStoreVersion
//    [_publishInteractBtn sizeWith:CGSizeMake(self.view.bounds.size.width, 60)];
//    [_publishInteractBtn alignParentBottomWithMargin:kDefaultMargin];
//#else
#if kSupportMultiLive
  
    [_publishBtn sizeWith:CGSizeMake((self.view.bounds.size.width - 3 * kDefaultMargin)/2, 44)];
//    [_publishBtn alignParentBottomWithMargin:50];
    [_publishBtn alignParentTopWithMargin:400];
    [_publishBtn alignHorizontalCenterOf:_scrollView];
    
    [_publishInteractBtn sameWith:_publishBtn];
    //    [_publishInteractBtn layoutToRightOf:_publishBtn margin:kDefaultMargin];
    [_publishInteractBtn alignHorizontalCenterOf:_scrollView];
    //#else
    //    [_publishInteractBtn sizeWith:CGSizeMake(self.view.bounds.size.width, 60)];
    //    [_publishInteractBtn alignParentBottom];
    //#endif
#else
    [_publishBtn sizeWith:CGSizeMake(self.view.bounds.size.width, 60)];
    [_publishBtn alignParentBottom];
#endif
    
//#endif
}


#pragma mark - 打开相机或相册
- (void)openImageActionSheet
{
    __weak typeof(self) ws = self;
    UIActionSheet *testSheet = [[UIActionSheet alloc] init];//[UIActionSheet bk_actionSheetWithTitle:@"请选择照片源"];
    [testSheet bk_addButtonWithTitle:@"拍照" handler:^{
        [ws openCamera];
    }];
    [testSheet bk_addButtonWithTitle:@"相册" handler:^{
        [ws openPhotoLibrary];
    }];
    [testSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [testSheet showInView:self.view];
}

- (void)openCamera
{
    // 暂时弃用自定义相机
    // 打开系统相机拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"您没有相机使用权限,请到设置->隐私中开启权限" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        [alert show];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *cameraIPC = [[UIImagePickerController alloc] init];
        cameraIPC.delegate = self;
        cameraIPC.allowsEditing = YES;
        cameraIPC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraIPC animated:YES completion:nil];
        return;
    }
}

- (void)openPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *cutImage = [self cutImage:image];
    _publishContent.image = cutImage;
    [_lableCover removeFromSuperview];
    _lableCover = nil;
    
    //如果是相机拍照，则保存到相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        _currentImage = cutImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图片剪裁
- (UIImage *)cutImage:(UIImage *)image
{
    CGSize pubSize = [self publishSize];
    if (image)
    {
        CGSize imgSize = image.size;
        CGFloat pubRation = pubSize.height / pubSize.width;
        CGFloat imgRatio = imgSize.height / imgSize.width;
        if (fabs(imgRatio -  pubRation) < 0.01)
        {
            // 直接上传
            return image;
        }
        else
        {
            if (imgRatio > 1)
            {
                // 长图，截正中间部份
                CGSize upSize = CGSizeMake(imgSize.width, (NSInteger)(imgSize.width * pubRation));
                UIImage *upimg = [self cropImage:image inRect:CGRectMake(0, (image.size.height - upSize.height)/2, upSize.width, upSize.height)];
                return upimg;
            }
            else
            {
                // 宽图，截正中间部份
                CGSize upSize = CGSizeMake(imgSize.height, (NSInteger)(imgSize.height * pubRation));
                UIImage *upimg = [self cropImage:image inRect:CGRectMake((image.size.width - upSize.width)/2, 0, upSize.width, upSize.height)];
                return upimg;
            }
        }
    }
    
    return image;
}

- (UIImage *)cropImage:(UIImage *)image inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [image drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return croppedImage;
}


@end
