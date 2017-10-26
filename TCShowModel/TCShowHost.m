//
//  TCShowHost.m
//  TCShow
//
//  Created by AlexiChen on 16/4/13.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowHost.h"


// 退出上次使用房间的通知
NSString *const kTCShow_ExitLastRoomNotification = @"kTCShow_ExitLastRoomNotification";

// 获取地理位置通知
NSString *const kTCShow_LocationSuccNotification = @"kTCShow_LocationSuccNotification";;
NSString *const kTCShow_LocationFailNotification = @"kTCShow_LocationFailNotification";;


@implementation TCShowHost



- (void)asyncProfile
{
    [super asyncProfile];
    NSString *imuid = [[SARUserInfo gainUserInfo]objectForKey:@"phone"];
    // 加载AVRoomID
    NSString *avidKey = [NSString stringWithFormat:@"%@_avRoomId", imuid];
    NSNumber *avidnum = [[NSUserDefaults standardUserDefaults] objectForKey:avidKey];
    if (avidnum){
        _avRoomId = [avidnum intValue];
        TCAVLog(([NSString stringWithFormat:@" *** clogs.host.createRoom|%@|SUCCEED|get room id from local %d", imuid, _avRoomId]));
    }else{
        __weak TCShowHost *ws = self;

        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr GET:URL_GETROOMID parameters:@{@"phone":imuid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int code = [responseObject[@"code"] intValue];
            if (code == 0) {
                ws.avRoomId = [responseObject[@"data"][@"num"] intValue];
            }else{
                [[HUDHelper sharedInstance]tipMessage:responseObject[@"message"] delay:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[HUDHelper sharedInstance]tipMessage:@"请求房间号失败！！！" delay:1.5];
        }];
        TCAVLog(([NSString stringWithFormat:@" *** clogs.host.createRoom|%@|request room id", imuid]));
    }
    
    // 是否显示位置
    NSString *slKey = [NSString stringWithFormat:@"%@_showLocation", imuid];
    NSNumber *slnum = [[NSUserDefaults standardUserDefaults] objectForKey:slKey];
    _showLocation = [slnum boolValue];
    
    if (_showLocation)
    {
        [self startLbs];
    }
    
    // live cover
    NSString *lcKey = [NSString stringWithFormat:@"%@_liveCover", imuid];
    _liveCover = [[NSUserDefaults standardUserDefaults] objectForKey:lcKey];
}

- (void)setAvRoomId:(int)avRoomId
{
    if (_avRoomId != avRoomId)
    {
        _avRoomId = avRoomId;
        
        NSString *avidKey = [NSString stringWithFormat:@"%@_avRoomId", [self imUserId]];
        [[NSUserDefaults standardUserDefaults] setObject:@(_avRoomId) forKey:avidKey];
    }
}

- (void)setShowLocation:(BOOL)showLocation
{
    if (_showLocation != showLocation)
    {
        _showLocation = showLocation;
        NSString *slKey = [NSString stringWithFormat:@"%@_showLocation", [self imUserId]];
        [[NSUserDefaults standardUserDefaults] setObject:@(_showLocation) forKey:slKey];
        
    }
}

- (void)setLiveCover:(NSString *)liveCover
{
    _liveCover = liveCover;
    NSString *slKey = [NSString stringWithFormat:@"%@_liveCover", [self imUserId]];
    [[NSUserDefaults standardUserDefaults] setObject:_liveCover forKey:slKey];
}

- (void)startLbs
{
    if ([CLLocationManager locationServicesEnabled])
    {
        // 支持定位才开启lbs
        if (!_lbsManager)
        {
            _lbsManager = [[CLLocationManager alloc] init];
            [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
            _lbsManager.delegate = self;
            [_lbsManager startUpdatingLocation];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                [_lbsManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTCShow_LocationFailNotification object:nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_lbsInfo.isVaild)
    {
        [manager stopUpdatingHeading];
        _lbsManager.delegate = nil;
        _lbsManager = nil;
    }
    CLLocation *newLocatioin = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocatioin completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            CLPlacemark *placeMark = placemarks[0];
            //记录地址
            if (!_lbsInfo)
            {
                _lbsInfo = [[LocationItem alloc] init];
            }
            
            CLLocation *loc = placeMark.location;
            _lbsInfo.latitude = loc.coordinate.latitude;
            _lbsInfo.longitude = loc.coordinate.longitude;
            
            NSString *country = placeMark.country;
            NSString *aa = [placeMark administrativeArea];
            NSString *state = aa.length ? aa : [placeMark subAdministrativeArea];
            NSString *city = placeMark.locality;
            NSString *sub = placeMark.subLocality;
            NSString *street = placeMark.thoroughfare;
            NSString *subStreet = placeMark.subThoroughfare;
            
            _lbsInfo.address = [NSString stringWithFormat:@"%@%@%@%@%@%@", country ? country : @"", state ? state : @"", city ? city : @"", sub ? sub : @"", street ? street : @"", subStreet ? subStreet : @""];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTCShow_LocationSuccNotification object:nil];
        }
    }];
}


#if kIsTCShowSupportIMCustom
- (BOOL)gender
{
    NSDictionary *dic = self.profile.customInfo;

    NSData *customData = dic[kIMCustomFlag];
    
    if (customData.length)
    {
        NSDictionary *cdic = [customData objectFromJSONData];
        
        NSNumber *num = cdic[@"gender"];
        return [num boolValue];
    }
    return NO;
}
#endif

@end
