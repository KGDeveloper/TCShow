
//
//  LiveHomeController.m
//  TCShow
//
//  Created by tangtianshi on 16/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "LiveHomeController.h"
#import "BaseItemViewController.h"
#import "SCNavTabBarController.h"
#import "HotViewController.h"
#import "ConversationListViewController.h"
#import "SearchViewController.h"
#import "HomeCityChooseController.h"
#import "TCGoodsTypeModel.h"
#import "MJExtension.h"
#import "TCHomeMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RechargeViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>

#import "MXWechatConfig.h"
@interface LiveHomeController ()<CLLocationManagerDelegate>{
    NSMutableArray * _dataArray;
    UIButton * _messageButton;
}
@property(nonatomic,strong)UIButton * typeButton;
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

@implementation LiveHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"柠檬直播";
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.navigationController.navigationBar.barTintColor = kNavBarThemeColor;
    [self loadSubView];
    [self addNaviBar];
    [self locationStart];
    [self onUnReadMessag];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRelogin) name:kIMAMSG_ReloginNotification object:nil];
}
-(void)test{
    
    RechargeViewController * v = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:v animated:YES];
    
//    [MXWechatPayHandler jumpToWxPay];
//    [[Business sharedInstance] limoPayWithWexinWithParam:@{@"user_id":[SARUserInfo userId],@"lemon_id":@"3"} succ:^(NSString *msg, id data) {
    //        amount = 1000;
//    "create_time" = 1498207976;
//    "lmorder_id" = 410;
//    "order_price" = "100.00";
//    "order_sn" = 201706231652566721;
//    "pay_status" = 0;
//    "pay_time" = 0;
//    "pay_type" = 0;
//    uid = 26;
//        
//    } fail:^(NSString *error) {
//        
//    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    if (_dataArray != nil && _dataArray.count == 0) {
        [self loadSubView];
        [self locationStart];
        [self onUnReadMessag];
    }
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view bringSubviewToFront:btn];
//    btn.center = self.view.center;

}

- (void)updateMethod:(id)version{
    
    if (version==nil) {
        
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新的版本更新！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拉黑按钮点击确认
        [self updateMethodwithUrl:[NSString stringWithFormat:@"%@",[version valueForKey:@"appUrl"]]];
    }];
    [defaultAction setValue:YCColor(76, 199, 207, 1.0) forKey:@"titleTextColor"];
    [alertController addAction:defaultAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:YCColor(76, 199, 207, 1.0) forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)updateMethodwithUrl:(NSString *)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}

- (void)onRelogin
{
    [self.KVOController unobserveAll];
    [self configOwnViews];
    
}

- (void)configOwnViews
{
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    _conversationList = [mgr conversationList];
    
    __weak LiveHomeController *ws = self;
    mgr.conversationChangedCompletion = ^(IMAConversationChangedNotifyItem *item) {
        [ws onConversationChanged:item];
    };
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr keyPath:@"unReadMessageCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onUnReadMessag];
    }];
    [ws onUnReadMessag];
}

- (void)onConversationChanged:(IMAConversationChangedNotifyItem *)item
{
    switch (item.type)
    {
        case EIMAConversation_Connected:
        {
            [self loadSubView];
        }
            break;
        case EIMAConversation_DisConnected:
        {
            [self loadSubView];
        }
            break;

        default:
            
            break;
    }
    
}

- (void)onUnReadMessag
{
    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    NSString *badge = nil;
    if (unRead > 0 && unRead <= 99)
    {
        badge = [NSString stringWithFormat:@"%d", (int)unRead];
        [_messageButton setImage:IMAGE(@"home_message_unRead") forState:UIControlStateNormal];
    }
    else if (unRead > 99)
    {
        badge = @"99+";
        [_messageButton setImage:IMAGE(@"home_message_unRead") forState:UIControlStateNormal];
    }else if(unRead==0){
        [_messageButton setImage:IMAGE(@"message") forState:UIControlStateNormal];
    }
    self.navigationController.tabBarItem.badgeValue = badge;
}


//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        
    }
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             [_typeButton setTitle:[currCity substringToIndex:currCity.length - 1] forState:UIControlStateNormal];
             
         } else if (error ==nil && [array count] == 0)
         {
         }else if (error !=nil)
         {
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}



#pragma mark ------------loadSubView
-(void)loadSubView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Business sharedInstance] homeGoodsTypeSucc:^(NSString *msg, id data) {
        _dataArray = [TCGoodsTypeModel mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
        NSUserDefaults * goodsAllType = [NSUserDefaults standardUserDefaults];
        [goodsAllType setObject:data forKey:@"allGoods"];
        [goodsAllType synchronize];
        hud.hidden = YES;
        [self pageView];
    } fail:^(NSString *error) {
        hud.labelText = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
        });
    }];
}


-(void)pageView{
    NSMutableArray * typeName = [NSMutableArray arrayWithCapacity:0];
    HotViewController * hot = [[HotViewController alloc]init];
    hot.sectionTitle = @"热门推荐";
    hot.title = @"热门";
    [typeName addObject:hot];
    // ---注释下面代码---wxt
//    for (TCGoodsTypeModel * typeModel in _dataArray) {
//        BaseItemViewController * delicacy = [[BaseItemViewController alloc]init];
//        delicacy.title = typeModel.type_name;
//        delicacy.sectionTitle = typeModel.type_name;
//        delicacy.sectionImagePath = IMG_APPEND_PREFIX(typeModel.type_img);
//        [typeName addObject:delicacy];
//    }

    
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = typeName;
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.canPopAllItemMenu = YES;
    [navTabBarController addParentController:self];
}


#pragma mark --------------addNaviBar
-(void)addNaviBar{
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(0, 0, 60, 30);
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_typeButton setTitle:@"北京" forState:UIControlStateNormal];
    [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [_typeButton setImage:IMAGE(@"home_city") forState:UIControlStateNormal];
    [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_typeButton.imageView.width, 0, _typeButton.imageView.width)];
    [_typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, _typeButton.titleLabel.width, 0, -_typeButton.titleLabel.width)];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:_typeButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
    UIView * searchField = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH*0.6, 30)];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.layer.cornerRadius = 5;
    searchField.layer.masksToBounds = YES;
    searchField.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap)];
    [searchField addGestureRecognizer:tap];
//    self.navigationItem.titleView = searchField;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
    imageView.userInteractionEnabled = YES;

    imageView.image = [UIImage imageNamed:@"home_lemon"];
    [searchField addSubview:imageView];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 122, 20)];
    label.text = @"连衣裙";
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor lightGrayColor];
    [searchField addSubview:label];
    
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton.size = CGSizeMake(24, 24);
    [_messageButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_messageButton addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:_messageButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *backV =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH*0.6, 30)];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH*0.6 - 122) / 2, 3, 122, 22)];
    imgV.image = [UIImage imageNamed:@"home_lemon"];
    [backV addSubview:imgV];
    self.navigationItem.titleView = backV;
    
}


#pragma mark --------搜索
-(void)searchTap{
    SearchViewController * search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark --------定位
-(void)location{
    TCHomeMapViewController * mapView = [[TCHomeMapViewController alloc] init];
    mapView.currCity = _typeButton.titleLabel.text;
    [self.navigationController pushViewController:mapView animated:YES];
}

 
#pragma mark -------消息通知
-(void)messageClick{
    ConversationListViewController * message = [[ConversationListViewController alloc]init];
    message.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
