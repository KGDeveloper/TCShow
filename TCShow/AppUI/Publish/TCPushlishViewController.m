//
//  TCPushlishViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCPushlishViewController.h"
#import "TCGoodsTypeModel.h"
#import "MyCollectionView.h"
#import "TCChanceTypeCell.h"
#import "TCLiveTypeReusableView.h"
#import "MJExtension.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
static BOOL isLocation;
static BOOL isLocationItem;
static NSString * liveTitle = @"";
static NSString * live_type = @"0";
@interface TCPushlishViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) IBOutlet UITextField *liveTitleTextField;
- (IBAction)closeClick:(UIButton *)sender;
- (IBAction)liveStartClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *chanceTypeView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
- (IBAction)wechat:(UIButton *)sender;
- (IBAction)qq:(UIButton *)sender;
- (IBAction)sina:(UIButton *)sender;
- (IBAction)collection:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic,strong)NSMutableArray * goodsTypeArray;
@property(nonatomic,strong)MyCollectionView *collectionView;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)NSMutableArray * livetypeArray;
@end

@implementation TCPushlishViewController {
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_captureLayer;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)iamgePicker {
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:captureInput];
    [_captureSession addOutput:captureOutput];
    [_captureSession startRunning];
    
    //实时显示摄像头内容
    _captureLayer = [AVCaptureVideoPreviewLayer layerWithSession: _captureSession];
    _captureLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,width, height, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(newImage);
    [_backImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsTypeArray = [NSMutableArray arrayWithCapacity:0];
    _livetypeArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary * typeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"allGoods"];
    _goodsTypeArray = [TCGoodsTypeModel mj_objectArrayWithKeyValuesArray:typeDic[@"data"] context:nil];
    for (TCGoodsTypeModel * model in _goodsTypeArray) {
        [_livetypeArray addObject:model.id];
    }
    self.liveTitleTextField.tintColor = [UIColor whiteColor];
    [self.liveTitleTextField setTextAlignment:NSTextAlignmentCenter];
    self.liveTitleTextField.delegate = self;
    
#if kIsMeasureSpeed
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测速" style:UIBarButtonItemStylePlain target:self action:@selector(onTestSpeed)];
#endif
    
    UITapGestureRecognizer * locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTap)];
    [self.locationView addGestureRecognizer:locationTap];
    
//    UITapGestureRecognizer * typeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeChangeTap)];
//    [self.chanceTypeView addGestureRecognizer:typeTap];
//    [self addCollection];
    _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 49, kSCREEN_WIDTH, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
//    [self loadLiveCover];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (TCGoodsTypeModel * model in _goodsTypeArray) {
        model.isSelect = NO;
    }
    
    if (_captureSession) {
        [_captureSession stopRunning];
    }
    [_collectionView reloadData];
    self.liveTitleTextField.text = @"";
    self.typeLabel.text = @"直播";
    live_type = @"1";
    self.locationLabel.text = @"添加定位";
    isLocation = NO;
    isLocationItem = NO;
}

//- (void)loadLiveCover
//{
//    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
//    NSString *liveCover = [host liveCover];
//    if (liveCover)
//    {
//        [_publishContent sd_setImageWithURL:[NSURL URLWithString:liveCover] placeholderImage:nil];
//        _lableCover.hidden = YES;
//    }
//}


#pragma mark ------添加分类选择
-(void)addCollection{
    [_liveTitleTextField resignFirstResponder];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH,40);
    _collectionView = [[MyCollectionView alloc] initWithFrame:CGRectMake(0,kSCREEN_HEIGHT/2.0 + 50,kSCREEN_WIDTH,kSCREEN_HEIGHT/2.0-50 - 49) collectionViewLayout:flowLayout];
    [_collectionView setAllowsMultipleSelection:YES];
    [_collectionView registerNib:[UINib nibWithNibName:@"TCChanceTypeCell" bundle:nil] forCellWithReuseIdentifier:@"TYPECHANCE"];
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.hidden = YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TCLiveTypeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
//    if (_captureSession) {
//        [_captureSession startRunning];
//    }
    [self iamgePicker];
}


#pragma mark ---------选择分类
-(void)typeChangeTap{
    _collectionView.hidden = NO;
    _bottomView.hidden = NO;
    [_liveTitleTextField resignFirstResponder];
}


#pragma mark - 发布

- (void)onTestSpeed
{
#if kIsMeasureSpeed
    [[IMAPlatform sharedInstance] requestTestSpeed];
#endif
}


- (void)onPublish
{
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        return;
    }
    
    
#if DEBUG
    
    if ( liveTitle.length>0)
    {
        [self uploadImage];
    }
    else
    {
        IMAHost *host1 = [IMAPlatform sharedInstance].host;
//        [host1 asyncProfile];
        TCShowHost *host = (TCShowHost *)host1;
        
        
        if (host.avRoomId == 0)
        {
            __weak TCPushlishViewController *ws = self;
            LiveAVRoomIDRequest *req = [[LiveAVRoomIDRequest alloc] initWithHandler:^(BaseRequest *request) {
                LiveAVRoomIDResponseData *data = (LiveAVRoomIDResponseData *)request.response.data;
                host.avRoomId = data.num;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", data.num] forKey:@"STAR_LIVE_AVROOMID"];
                [ws startLive];
            } failHandler:^(BaseRequest *request) {
            }];
            req.uid = [host imUserId];
            [[WebServiceEngine sharedEngine] asyncRequest:req wait:NO];
        }
        else
        {
            [self startLive];
        }
        
    }
#else
    // 需要授权
    [self uploadImage];
#endif
}

#pragma mark - 上传图片
- (void)uploadImage
{
    __weak TCPushlishViewController *ws = self;

        [ws startLive];
}


/**
 开始直播
 */
- (void)startLive
{
    [self postStarsCoins];
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    NSString *liveCover = [host liveCover];
    
    TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
    if (liveTitle.length>0)
    {
        liveRoom.title = liveTitle;
    }
    else
    {
        
        liveRoom.title = [NSString stringWithFormat:@"%@ Live", [host imUserName]];
     
    }
    liveRoom.cover = liveCover;
    if (![self.typeLabel.text isEqualToString:@"选择分类"]) {
         liveRoom.live_type = live_type;
    }else{
        liveRoom.live_type = @"0";
    }
    TCShowUser *user = [[TCShowUser alloc] init];
    user.avatar = [host imUserIconUrl];
    user.phone = [host imUserId];
    user.username = [host imUserName];
    user.uid = [SARUserInfo userId];
    
    liveRoom.host = user;
    liveRoom.avRoomId = [host avRoomId];
    
    LocationItem *lbs = host.lbsInfo;
    liveRoom.lbs = lbs;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", liveRoom.avRoomId] forKey:@"STAR_LIVE_AVROOMID"];
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


- (void)onClickPublishContent:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self onLoadPublishLiveCover];
    }
}

- (void)postStarsCoins {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SARUserInfo userId] forKey:@"uid"];
    
    [[Business sharedInstance] postStarsCoinsWithParam:params succ:^(NSString *msg, id data) {
        [[NSUserDefaults standardUserDefaults] setObject:data[@"lemon_coins"] forKey:@"ZHUBO_STARLEMONNUM"];
    } fail:^(NSString *error) {
    }];
}

- (void)onLoadPublishLiveCover
{
    if ([_liveTitleTextField isFirstResponder])
    {
        [_liveTitleTextField resignFirstResponder];
        return;
    }
    [self callImagePickerActionSheet];
}


#pragma mark --------添加定位
- (void)locationTap
{
    [_liveTitleTextField resignFirstResponder];
    isLocation = YES;
    TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
    host.showLocation = isLocation;
    if (isLocation)
    {
        NSString *address = host.lbsInfo.address;
        if (address == nil)
        {
            [host startLbs];
            _locationLabel.text = @"正在定位";
            isLocationItem = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetAddressSucc) name:kTCShow_LocationSuccNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetAddressFail) name:kTCShow_LocationFailNotification object:nil];
        }
        else
        {
            NSArray *strarray = [address componentsSeparatedByString:@"市"];
            _locationLabel.text = [NSString stringWithFormat:@"%@市",strarray[0]];
            isLocationItem = YES;
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kTCShow_LocationSuccNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kTCShow_LocationFailNotification object:nil];
        _locationLabel.text = @"不显示位置";
        isLocationItem = NO;
    }
}

- (void)onGetAddressSucc
{
    if (isLocation)
    {
        TCShowHost *host = (TCShowHost *)[IMAPlatform sharedInstance].host;
        NSString *address = host.lbsInfo.address;
        
        if (address)
        {
            NSArray *strarray = [address componentsSeparatedByString:@"市"];
            _locationLabel.text = [NSString stringWithFormat:@"%@市",strarray[0]];
//            [_location setTitle:address forState:UIControlStateNormal];
//            [_location setTitleColor:kBlackColor forState:UIControlStateNormal];
            isLocationItem = YES;
//            _location.selected = YES;
        }
        
    }
    else
    {
        _locationLabel.text = @"不显示位置";
//        [_location setTitle:@"不显示位置" forState:UIControlStateNormal];
//        [_location setTitleColor:kLightGrayColor forState:UIControlStateNormal];
        isLocationItem = NO;
//        _location.selected = NO;
    }
}

- (void)onGetAddressFail
{
    if (isLocation)
    {
        _locationLabel.text = @"获取位置失败";
        isLocationItem = YES;
    }
    else
    {
        _locationLabel.text = @"不显示位置";
        isLocationItem = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeClick:(UIButton *)sender {
    [_liveTitleTextField resignFirstResponder];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)liveStartClick:(UIButton *)sender {
    if (_liveTitleTextField.text.length == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入直播标题"];
        return;
    }
    if ([_typeLabel.text isEqualToString:@"选择分类"]) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入直播分类"];
        return;
    }
    if ([_typeLabel.text isEqualToString:@"添加定位"]) {
        [[HUDHelper sharedInstance] tipMessage:@"请定位到当前位置"];
        return;
    }
    liveTitle = _liveTitleTextField.text;
    [_liveTitleTextField resignFirstResponder];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.selectedIndex = 0;
    [self onPublish];
}


- (IBAction)wechat:(UIButton *)sender {
}

- (IBAction)qq:(UIButton *)sender {
}

- (IBAction)sina:(UIButton *)sender {
}

- (IBAction)collection:(UIButton *)sender {
}


#pragma mark --------collectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (kSCREEN_WIDTH-30)/3.0;
    return  CGSizeMake(W, 50);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark -------dataSource


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCChanceTypeCell * typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYPECHANCE" forIndexPath:indexPath];
    //    id item = [self itemAtIndexPath:indexPath];
    //    self.configureCellBlock(_myCell, item);
    //    if ([self.sectionTitle isEqualToString:@"服装"]) {
    //        self.homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HOMECOLLECTCELL" forIndexPath:indexPath];
    //        self.homeCell.titleImage.hidden = YES;
    //        self.homeCell.personImage.hidden = YES;
    //        self.homeCell.personNumber.hidden = YES;
    //    }
    if (indexPath.row == 0) {
        typeCell.typeModel.isSelect = YES;
    }
    typeCell.typeModel = _goodsTypeArray[indexPath.row];
    return typeCell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsTypeArray.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    if (kind == UICollectionElementKindSectionHeader) {
        TCLiveTypeReusableView *headerView = (TCLiveTypeReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
        reusableView = headerView;
    }
    return reusableView;
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    live_type = _livetypeArray[indexPath.row];
    TCGoodsTypeModel * typeModel = _goodsTypeArray[indexPath.row];
    for (TCGoodsTypeModel * model in _goodsTypeArray) {
        model.isSelect = NO;
    }
    [_collectionView reloadData];
    typeModel.isSelect = YES;
    [_goodsTypeArray replaceObjectAtIndex:indexPath.row withObject:typeModel];
    self.typeLabel.text = typeModel.type_name;
    _collectionView.hidden = YES;
    _bottomView.hidden = YES;
    [_collectionView reloadData];
    return YES;
}

#pragma mark --------textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    liveTitle = _liveTitleTextField.text;
    [self.liveTitleTextField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
