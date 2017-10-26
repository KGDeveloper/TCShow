
//
//  EducationModel.m
//  FineQuality
//
//  Created by tangtianshi on 16/5/24.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import "EducationModel.h"

@implementation EducationModel
+ (NSDictionary *) modelCustomPropertyMapper {
    return @{@"statu" : @"status"
             };
}
@end


@implementation Data

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [List class]};
}

@end


@implementation List

@end


@implementation Img


@end
