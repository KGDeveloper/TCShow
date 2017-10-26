//
//  GCZPresentItem.h
//  PresentDemo
//
//  Created by gongcz on 16/5/23.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PresentType_Blowakiss = 0,//飞吻
    PresentType_Mua,//么么哒
    PresentType_Red,//红包
    PresentType_Candy,//糖果
    PresentType_Six, // 666
    PresentType_Love, //爱心
    PresentType_Wand,//魔杖
    PresentType_Diamondring,//钻戒
    PresentType_Kiss,//亲亲
    PresentType_Rose,//玫瑰花
    PresentType_Watermelon,//西瓜
    PresentType_Pig,//招财猪
    PresentType_HappyBirdy,//生日快乐
    PresentType_Home,//城堡
    PresentType_Car, // 汽车
    PresentType_Number, // 1314
    
} PresentType;

@interface GCZRotateImageView : UIImageView

@end

@interface GCZPresentItem : UIView

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

// 礼物图标
@property (weak, nonatomic) IBOutlet UIImageView *presentIcon;
// 数量
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
// 描述
@property (weak, nonatomic) IBOutlet UILabel *desLbl;

@property (weak, nonatomic) IBOutlet UIView *wheelContainer;
// 后轮
@property (weak, nonatomic) IBOutlet GCZRotateImageView *backWheel;
// 底轮
@property (weak, nonatomic) IBOutlet GCZRotateImageView *bottomWheel;


@property (nonatomic, strong) NSOperation *operation;
@property (nonatomic) BOOL isFinished;

@property (nonatomic) PresentType type; // 类型

- (void)updateNum:(NSString *)num;

- (void)updateNum:(NSString *)num animated:(BOOL)animated;

- (NSString *)descriptionForType:(PresentType)type;

@end
