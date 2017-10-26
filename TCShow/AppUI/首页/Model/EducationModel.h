//
//  EducationModel.h
//  FineQuality
//
//  Created by tangtianshi on 16/5/24.
//  Copyright © 2016年 QCWL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Data,List,Img;
@interface EducationModel : NSObject
@property(nonatomic,assign)NSInteger statu;
@property(nonatomic,copy)NSString * msg;
@property(nonatomic,strong)Data * result;
@end


@interface Data : NSObject
@property(nonatomic,strong)NSArray <List*>*list;
@property(nonatomic,strong)NSArray <Img*>*img;
@end

@interface Img : NSObject
@property(nonatomic,copy)NSString * ad_id;
@property(nonatomic,copy)NSString * ad_name;
@property(nonatomic,copy)NSString * ad_link;
@property(nonatomic,copy)NSString * ad_code;

@end

@interface List : NSObject
@property(nonatomic,strong)NSString *t_id;
@property(nonatomic,strong)NSString *t_name;//课程名称
@property(nonatomic,strong)NSString *t_content;//课程内容
@property(nonatomic,strong)NSString *t_title;//课程简介
@property(nonatomic,strong)NSString *t_picture;//课程图片
@property(nonatomic,strong)NSString *t_type;//课程类型
@property(nonatomic,strong)NSString *t_ctime;//课程添加时间
@property(nonatomic,strong)NSString *t_utime;//课程修改时间
@property(nonatomic,strong)NSString *t_shou;
@property(nonatomic,strong)NSString * t_address;//课程地址
@property(nonatomic,strong)NSString * t_number;
@end
