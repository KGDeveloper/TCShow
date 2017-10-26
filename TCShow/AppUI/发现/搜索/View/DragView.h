//
//  DragView.h
//  live
//
//  Created by tangtianshi on 16/6/12.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseDelegate<NSObject>
-(void)getChooseIndex;
@end
@interface DragView : UIView
@property(nonatomic,copy)UIImageView * imageView;
@property(nonatomic,copy)UILabel * bottomLabel;
@property (nonatomic,copy)NSNumber * isAttend;
@property (nonatomic,copy)NSString * attendId;
@property (nonatomic,copy)NSString * phone; // add by zxd on 2016-09-29 16:46
@property (nonatomic,strong)UIViewController * levelController;
@property(nonatomic,assign)id<ChooseDelegate>chooseDelegatel;

-(void)updateView:(NSNumber *)isAttend;

@end
