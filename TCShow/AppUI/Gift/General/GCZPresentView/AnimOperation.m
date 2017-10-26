//
//  AnimOperation.m
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "AnimOperation.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AnimOperation ()
@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@end


@implementation AnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithUserID:(NSString *)userID model:(GiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    AnimOperation *op = [[AnimOperation alloc] init];
    op.presentView = [[PresentView alloc] init];
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

- (void)start {

    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        _presentView.model = _model;
        _presentView.originFrame = _presentView.frame;
        [self.listView addSubview:_presentView];
        
        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];

    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
