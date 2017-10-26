//
//  TCHomeMapViewController.m
//  TCShow
//
//  Created by tangtianshi on 16/12/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCHomeMapViewController.h"
#import <MapKit/MapKit.h>//地图相关库
#import <CoreLocation/CoreLocation.h>//定位相关
#import "HomeCityChooseController.h"
#import "FishFxAnnotation.h"
@interface TCHomeMapViewController ()<MKMapViewDelegate,GYZChooseCityDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)MKMapView * mapView;//地图
@property (nonatomic,strong)CLLocationManager * locationManager;//定位相关
@property (nonatomic,strong)CLLocation * myLocation;
@property (nonatomic,strong)NSMutableArray * locationArray;
@property (nonatomic,strong)NSMutableArray * anArray;
@end

@implementation TCHomeMapViewController

-(NSMutableArray *)locationArray{
    if (!_locationArray) {
        _locationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _locationArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //创建地图
    [self createMap];
    [self createOtherUI];
    [self loadNearLive];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


#pragma mark --------请求附近的直播
-(void)loadNearLive{
    [[Business sharedInstance] getNearLives:[SARUserInfo userId] latitude:[NSString stringWithFormat:@"%f",_myLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",_myLocation.coordinate.longitude] succ:^(NSString *msg, id data) {
        _locationArray = [TCShowLiveListItem mj_objectArrayWithKeyValuesArray:data context:nil];
         [self createAnno];
    } fail:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    }];
}

#pragma mark 显示大头针
- (void)createAnno{
    
    _anArray = [NSMutableArray arrayWithCapacity:0];
    [_mapView removeAnnotations:_anArray];
    for (int i = 0; i<_locationArray.count; i++) {
        TCShowLiveListItem * listModel = _locationArray[i];
        FishFxAnnotation *annation=[[FishFxAnnotation alloc]init];
        annation.title = listModel.host.username;
        annation.subtitle = listModel.title;
        annation.iconPath=listModel.host.avatar;
        annation.liveAnnotatItem = listModel;
        [annation setCoordinate:CLLocationCoordinate2DMake(listModel.lbs.latitude, listModel.lbs.longitude)];
        [_mapView addAnnotation:annation];
        [_anArray addObject:annation];
    }
    [_mapView showAnnotations:_anArray animated:YES];
}

- (nullable MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation{
    
    MKAnnotationView*returnAnnotationView=nil;
    
    if([annotation isKindOfClass:[FishFxAnnotation class]])
        
    {
        FishFxAnnotation * ann = annotation;
        returnAnnotationView = [FishFxAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
        returnAnnotationView.image= [UIImage imageNamed:@"MapImage"];
        UIImageView * userNameView = [[UIImageView alloc]initWithFrame:CGRectMake(1.5, 1.5, returnAnnotationView.frame.size.width - 3, returnAnnotationView.frame.size.width - 3)];
        userNameView.backgroundColor = [UIColor redColor];
        userNameView.layer.cornerRadius = (returnAnnotationView.frame.size.width - 3)/2.0;
        userNameView.layer.masksToBounds = YES;
        [userNameView sd_setImageWithURL:[NSURL URLWithString:IMG_APPEND_PREFIX(ann.iconPath)] placeholderImage:IMAGE(@"defaultUser")];
        [returnAnnotationView addSubview:userNameView];
    }
    
    return returnAnnotationView;
    
}


#pragma mark ----------创建地图
- (void)createMap{
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    
    //设置地图样式
    /*
     MKMapTypeStandard 纸张地图
     MKMapTypeSatellite 纯卫星地图
     MKMapTypeHybrid 存在绘图的卫星地图
     */
    _mapView.mapType = MKMapTypeStandard;
    
    //设置地图是否可以放大和滚动
    _mapView.zoomEnabled = YES;
    
    _mapView.scrollEnabled = YES;
    
    //添加代理方法
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    //设置地图开启显示位置
    //经纬度
    //40.03761 116.37031
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.54, 116.28);

    //缩放比例 数值越小越精确
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    
    //通过经纬度和缩放比例确定区域
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    
    //地图显示区域
    [_mapView setRegion:region animated:YES];
    
    //定位功能
    //允许显示自己的位置
    _mapView.showsUserLocation = YES;
    
    //创建定位管理者
    _locationManager = [[CLLocationManager alloc]init];
    
    //设置定位的精确度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //设置定位的米数
    _locationManager.distanceFilter = 1.0;
    
    //Xcode6以上需要添加设置
    /*
     在info.plist
     NSLocationAlwaysUsageDescription
     NSLocationWhenInUseUsageDescription
     */
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    //定位添加代理
    _locationManager.delegate = self;
    
    //开启定位功能
    [_locationManager startUpdatingLocation];
    //方向定位
    [_locationManager startUpdatingHeading];
    
}


-(void)createOtherUI{

    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(kSCREEN_WIDTH - 62, kSCREEN_HEIGHT - 198, 50, 50);
    [searchButton setImage:[UIImage imageNamed:@"home_map_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(kSCREEN_WIDTH - 62, CGRectGetMaxY(searchButton.frame) + 13, 50, 50);
    [cancelButton setImage:[UIImage imageNamed:@"home_map_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
}

#pragma mark -------搜索
-(void)search{
    HomeCityChooseController *cityPickerVC = [[HomeCityChooseController alloc] init];
    cityPickerVC.currCity = self.currCity;
    [cityPickerVC setDelegate:self];
//    暂时注释
//    cityPickerVC.locationCityID = @"1400010000";
//    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
//    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
    }];
}

-(void)cancel{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定位相关的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //地理编码\逆地理编码
    //地理编码：通过位置名称找到该位置的经纬度
    //逆地理编码：通过经纬度找到位置信息(*****)
    //locations(用于存储每次定位信息)
    for (CLLocation * location in locations) {
        _myLocation = location;
    }
//    [self loadNearLive];
    //逆地理编码相关
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];//作用：经纬度转地址
    
    //为了测试获取第一次定位成功位置
    CLLocation * loc = locations[0];
    /*
     1、位置信息
     2、在Block体中解析位置信息
     */
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        //解析位置信息
        //获取具体位置
        for (CLPlacemark * place in placemarks) {
            //位置信息存在于字典中
            NSDictionary * dict = [place addressDictionary];
        }
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![IMAPlatform sharedInstance].isConnected)
    {
        [HUDHelper alert:@"当前无网络"];
        return;
    }
        for (FishFxAnnotation * ann in _anArray) {
            if(ann == (FishFxAnnotation *)view.annotation){
                for (TCShowLiveListItem * itemm in _locationArray) {
                    if (itemm.chatRoomId == ann.liveAnnotatItem.chatRoomId) {
                        id<TCShowLiveRoomAble> item = itemm;
                        TCShowMultiLiveViewController *vc = [[TCShowMultiLiveViewController alloc] initWith:item user:[IMAPlatform sharedInstance].host];
                        [[AppDelegate sharedAppDelegate] pushViewController:vc];
                    }
                }
        }
    }
}


#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(HomeCityChooseController *)chooseCityController didSelectCity:(GYZCity *)city
{
    //[chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(HomeCityChooseController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode  = MKUserTrackingModeNone;
    [self.mapView.layer removeAllAnimations];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
