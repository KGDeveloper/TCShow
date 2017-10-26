//
//  TCShowAVParView.h
//  TCShow
//
//  Created by AlexiChen on 16/5/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCShowAVParView;
@protocol TCShowAVParViewDelegate <NSObject>

- (void)onAVParView:(TCShowAVParView *)par clickPar:(UIButton *)button;
- (void)onAVParView:(TCShowAVParView *)par clickPush:(UIButton *)button;
- (void)onAVParView:(TCShowAVParView *)par clickRec:(UIButton *)button;
- (void)onAVParView:(TCShowAVParView *)par clickSpeed:(UIButton *)button;

@end

@interface TCShowAVParView : UIView
{
@protected
    UIButton *_par;     // PAR
    UIButton *_push;    // Push
    UIButton *_rec;     // rec
    UIButton *_speed;   // 测速
}

@property (nonatomic, weak) id<TCShowAVParViewDelegate> delegate;
@property (nonatomic, assign) BOOL isHostPar;

- (void)onRefrshPARView:(TCAVLiveRoomEngine *)engine;

@end
