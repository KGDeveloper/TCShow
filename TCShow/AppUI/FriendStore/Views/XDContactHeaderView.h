//
//  XDContactHeaderView.h
//  TCShow
//
//  Created by tangtianshi on 2016/10/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebModels.h"
@protocol ContactHeaderDelegate <NSObject>
-(void)watchLive:(TCShowLiveListItem *)itemModel;
@end

@interface XDContactHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *CoverImgArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *liveStoreLabArr;
@property(nonatomic,assign)id<ContactHeaderDelegate>contactDelegate;
- (IBAction)moreClick:(id)sender;


@property (nonatomic, strong) UIViewController *parentVC;
@end
