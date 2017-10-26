//
//  HomeCithChooseController.h
//  TCShow
//
//  Created by tangtianshi on 16/10/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"

#define     MAX_COMMON_CITY_NUMBER      8
#define     COMMON_CITY_DATA_KEY        @"GYZCommonCityArray"
#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0


@interface HomeCityChooseController : UITableViewController
@property (nonatomic, assign) id <GYZChooseCityDelegate> delegate;
/*
 *  定位城市id
 */
@property (nonatomic, strong) NSString *locationCityID;

/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;

/*
 *  热门城市id数组
 */
@property (nonatomic, strong) NSArray *hotCitys;


/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *cityDatas;

@property (nonatomic,strong)NSString * currCity;

@end
