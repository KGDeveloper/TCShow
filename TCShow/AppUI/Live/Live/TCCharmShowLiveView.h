//
//  TCCharmShowLiveView.h
//  TCShow
//
//  Created by 王孟 on 2017/7/28.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCCharmShowLiveView : UIView {
@protected
    TCShowLiveListItem *_room;
}

@property (nonatomic, copy, readwrite) void(^charmViewClickBlack)();

- (instancetype)initWithRoom:(id<TCShowLiveRoomAble>)room;

@end
