//
//  FishFxAnnotation.m
//  MapLocaTest
//
//  Created by tangtianshi on 17/1/8.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "FishFxAnnotation.h"

@implementation FishFxAnnotation
-(NSString*)title{
    
    return _title;
    
}

-(NSString*)subtitle{
    
    return _subtitle;
    
}


-(NSString *)iconPath{
    return _iconPath;
}

-(TCShowLiveListItem *)liveAnnotatItem{
    return _liveAnnotatItem;
}

+(MKAnnotationView*)createViewAnnotationForMapView:(MKMapView*)mapView annotation:(id)annotation{
    
    MKAnnotationView*returnedAnnotationView =
    
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([FishFxAnnotation class])];
    
    if(returnedAnnotationView ==nil)
        
    {
        
        returnedAnnotationView =
        
        [[MKAnnotationView alloc]initWithAnnotation:annotation
         
                                   reuseIdentifier:NSStringFromClass([FishFxAnnotation class])];
        
        returnedAnnotationView.canShowCallout=YES;
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        
        returnedAnnotationView.centerOffset=CGPointMake( returnedAnnotationView.centerOffset.x+ returnedAnnotationView.image.size.width/2, returnedAnnotationView.centerOffset.y- returnedAnnotationView.image.size.height/2);
        
    }
    
    else
        
    {
        
        returnedAnnotationView.annotation= annotation;
        
        returnedAnnotationView.centerOffset=CGPointMake( returnedAnnotationView.centerOffset.x+ returnedAnnotationView.image.size.width/2, returnedAnnotationView.centerOffset.y- returnedAnnotationView.image.size.height/2);
        
    }
    
    return returnedAnnotationView;
    
}


@end
