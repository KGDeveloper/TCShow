//
//  FishFxAnnotation.h
//  MapLocaTest
//
//  Created by tangtianshi on 17/1/8.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface FishFxAnnotation : NSObject
@property(nonatomic,readwrite)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,copy)NSString * iconPath;
@property(nonatomic,strong)TCShowLiveListItem * liveAnnotatItem;
+(MKAnnotationView*)createViewAnnotationForMapView:(MKMapView*)mapView annotation:(id)annotation;
@end
