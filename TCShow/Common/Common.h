// 
//  Common.h
//  live
//
//  Created by hysd on 15/7/29.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Common : NSObject
+ (Common *) sharedInstance;
-(void)shakeView:(UIView*)viewToShake;
-(BOOL) isValidateMobile:(NSString *)mobile;
+ (void)turnTorch:(BOOL)on;
@end
