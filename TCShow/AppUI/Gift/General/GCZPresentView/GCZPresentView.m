//
//  GCZPresentView.m
//  PresentDemo
//
//  Created by gongcz on 16/5/23.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "GCZPresentView.h"
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
@interface GCZPresentView ()
{
    NSMutableDictionary *infoDic_;
    GCZPresentItem *carItem_;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSOperationQueue *carQueue; // 汽车队列

@end

@implementation GCZPresentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)instance
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        infoDic_ = [NSMutableDictionary dictionary];
//        self.frame = CGRectMake(0, 0, 264, 80*numOfLines);
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, 0, screenBounds.size.width, 300);
//        [self configItemView];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)configItemView
{
    for (int i = 0; i < numOfLines; i++) {
        if ([self viewWithTag:100+i]) {
            continue;
        }
        // 第一个视图
        GCZPresentItem *item1 = [[NSBundle mainBundle] loadNibNamed:@"GCZPresentItem" owner:nil options:nil][0];
        CGRect frame = item1.frame;
        item1.frame = CGRectMake(0, 150+i*(frame.size.height), frame.size.width, frame.size.height);
        item1.tag = 100+i;
        item1.alpha = 0;
        [self addSubview:item1];
        [self sendSubviewToBack:item1];
    }
    
}

- (NSMutableArray *)items
{
    [self configItemView];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < numOfLines; i++) {
        GCZPresentItem *item = [self viewWithTag:100+i];
        NSAssert(item != nil, @"不能为空");
        [arr addObject:item];
    }
    
    return arr;
}

- (BOOL)exist:(NSString *)name
{
    __block BOOL exist = NO;
    [[self items] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCZPresentItem *item = obj;
        if ([item.nameLbl.text isEqualToString:name]) {
            exist = YES;
            *stop = YES;
        }
    }];
    return exist;
}

- (NSString *)key:(GCZPresentItem *)item
{
    return [NSString stringWithFormat:@"%@_%ld",item.nameLbl.text, (unsigned long)item.type];
}

- (BOOL)containOperation:(NSString *)name
{
    __block BOOL contain = NO;
    [self.queue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSOperation *operation = obj;
        if ([operation.name isEqualToString:name]) {
            contain = YES;
            *stop = YES;
        }
    }];
    return contain;
}

- (BOOL)continuousOver:(GCZPresentItem *)presentItem
{
    if (presentItem.nameLbl.text.length == 0) {
        return YES;
    }
    NSString *numStr = [presentItem.numLbl.text substringFromIndex:1];
    NSString *key = [self key:presentItem];
    return  numStr.integerValue >= [infoDic_[key] integerValue];
}


/**
 在这里貌似做的动画

 @param headImgUrl <#headImgUrl description#>
 @param name <#name description#>
 @param presentType <#presentType description#>
 @param num <#num description#>
 */
- (void)showCarViewWith:(NSString *)headImgUrl name:(NSString *)name type:(PresentType)presentType num:(NSUInteger)num
{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        
        __block GCZPresentItem *presentItem;
        dispatch_async(dispatch_get_main_queue(),^{
            
            //            [self configView];
            GCZPresentItem *item1 = [[NSBundle mainBundle] loadNibNamed:@"GCZPresentItem_Car" owner:nil options:nil][0];
            CGRect frame = item1.frame;
            item1.frame = CGRectMake(self.frame.size.width-frame.size.width, self.frame.size.height-frame.size.height, frame.size.width, frame.size.height);
            item1.tag = 1000;
            [self addSubview:item1];
            [self bringSubviewToFront:item1];
            presentItem = item1;
            
//            item1.presentIcon.image = [UIImage imageNamed:@"1"];
            item1.type = presentType;
            item1.nameLbl.text = [NSString stringWithFormat:@"%@%@",name,[presentItem descriptionForType:presentType]];//name;
//            item1.desLbl.text = [presentItem descriptionForType:presentType];
            
            [self showAnimation:presentItem num:num];
            
        });
        presentItem.isFinished = NO;
        while (!presentItem.isFinished) {}
    }];
    operation.name = [NSString stringWithFormat:@"%@_%ld",name,(unsigned long)presentType];
    [operation setCompletionBlock:^{
    }];
    [self.carQueue addOperation:operation];
}

- (void)showPresentViewWith:(NSString *)headImgUrl
                       name:(NSString *)name
                       type:(PresentType)presentType
                        num:(NSUInteger)num
                      image:(UIImage *)image
                      title:(NSString *)title
{
    
    
}
- (void)showPresentViewWith:(NSString *)headImgUrl name:(NSString *)name type:(PresentType)presentType num:(NSUInteger)num{
//    [self configView];
    
    if (presentType == PresentType_Car) {
#pragma mark ---------在这里注释了---------
        [self showCarViewWith:headImgUrl name:name type:presentType num:num];
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@_%ld",name,(unsigned long)presentType];
    [infoDic_ setObject:@(num) forKey:key];
    if (num > 1 && [self exist:name]) { // 这种情况就不创建线程了，用已存在的视图即可
        return;
    }
    if ([self containOperation:key] && num > 1) { // 如果已创建了该operation则不再创建，至于为何要做这个判断是因为operation一旦创建了就不能修改了。
        return;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        if ([NSThread currentThread].isMainThread) {
            return ;
        }
        __block GCZPresentItem *presentItem;
        dispatch_async(dispatch_get_main_queue(),^{
            
//            [self configView];
            
            [[self items] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GCZPresentItem *item = obj;
                // 由于线程最大并发为2做了线程保护，所以这里只要判断视图的alpha即可
                if (item.alpha == 0 && CGAffineTransformEqualToTransform(item.transform, CGAffineTransformIdentity)) {
                    presentItem = item;
                    *stop = YES;
                }
            }];
            [presentItem.headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,headImgUrl]] placeholderImage:HOLDER_HEAD options:SDWebImageRetryFailed];
            presentItem.type = presentType;
            presentItem.nameLbl.text = name;
            [presentItem.nameLbl sizeToFit];
//            presentItem.desLbl.text = [presentItem descriptionForType:presentType];
            //            [presentItem updateNum:[NSString stringWithFormat:@"X%ld",num] animated:NO];
            [self showAnimation:presentItem num:num];
            
        });
//        presentItem.operation = operation;
//        sleep(MAXFLOAT); // 这样就导致永远无法释放了，[operation cancel]也是不行的
//        sleep(3.2);
        presentItem.isFinished = NO;
        while (!presentItem.isFinished) {
            // 保持线程不被销毁
        }
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; // 不知为何 设置这个竟然无效果
    }];
    operation.name = [NSString stringWithFormat:@"%@_%lud",name,(unsigned long)presentType];
    [operation setCompletionBlock:^{
    }];
    [self.queue addOperation:operation];
}



/**
 连发

 @param presentItem 传经来的礼物类型
 @param num 礼物被点击了几次
 */
- (void)showAnimation:(GCZPresentItem *)presentItem num:(NSUInteger)num
{
    if (presentItem.type == PresentType_Car) {
        presentItem.bottomWheel.hidden = NO;
        presentItem.backWheel.hidden = YES;
        CGRect frame = presentItem.frame;
        [UIView animateWithDuration:3.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            presentItem.transform = CGAffineTransformMakeTranslation(frame.size.width-self.frame.size.width, frame.size.height-self.frame.size.height);
        } completion:^(BOOL finished) {
//            [presentItem removeFromSuperview];
//            presentItem.isFinished = YES;
            presentItem.transform = CGAffineTransformMakeTranslation(0, presentItem.transform.ty);
            presentItem.presentIcon.highlighted = YES;
            presentItem.bottomWheel.hidden = YES;
            presentItem.backWheel.hidden = NO;
            [presentItem.wheelContainer viewWithTag:21].hidden = YES;
            [UIView animateWithDuration:3.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                presentItem.transform = CGAffineTransformMakeTranslation(frame.size.width-self.frame.size.width, 0);
            } completion:^(BOOL finished) {
                presentItem.isFinished = YES;
                [presentItem removeFromSuperview];
            }];
        }];
        
    }else{
        CGRect frame = presentItem.frame;
        presentItem.transform = CGAffineTransformMakeTranslation(-frame.size.width, 0);
        presentItem.alpha = 1;
        presentItem.presentIcon.transform = CGAffineTransformMakeTranslation(-195, 0);
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            presentItem.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 花动
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                presentItem.presentIcon.transform = CGAffineTransformIdentity;
            } completion:NULL];
            if (num > 0) {
                [self showNumAnimation:presentItem num:[NSString stringWithFormat:@"X%ld",(unsigned long)num]];
            }
        }];
    }
}

- (void)showNumAnimation:(GCZPresentItem *)presentItem num:(NSString *)num
{
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideItem:) object:presentItem]; // 取消上一个线程
    [presentItem updateNum:num];
    if (![self continuousOver:presentItem]) {
        [self performSelector:@selector(addNum:) withObject:presentItem afterDelay:0.5];
        return;
    }
    [self performSelector:@selector(hideItem:) withObject:presentItem afterDelay:2.f];
}

- (void)addNum:(GCZPresentItem *)presentItem
{
    NSString *num = [presentItem.numLbl.text substringFromIndex:1];
    NSUInteger lastNum = num.integerValue+1;
    [self showNumAnimation:presentItem num:[NSString stringWithFormat:@"X%ld",(unsigned long)lastNum]];
}

- (void)hideItem:(GCZPresentItem *)presentItem
{
    if (![self continuousOver:presentItem]) {
        [self addNum:presentItem];
        return;
    }
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        presentItem.alpha = 0;
        presentItem.transform = CGAffineTransformMakeTranslation(0, -30);
    } completion:^(BOOL finished) {
        NSString *key = [NSString stringWithFormat:@"%@_%ld",presentItem.nameLbl.text,(unsigned long)presentItem.type];
        [infoDic_ removeObjectForKey:key];
        
        presentItem.transform = CGAffineTransformIdentity;
        [presentItem.operation cancel]; // 无效 >_<
        presentItem.isFinished = YES;
        [presentItem removeFromSuperview];
    }];
}

#pragma mark - Private method
- (NSString *)nameWithType:(PresentType)type
{
    switch (type) {
        case PresentType_Blowakiss:
            return @"飞吻";
            break;
        case PresentType_Mua:
            return @"么么哒";
            break;
        case PresentType_Red:
            return @"红包";
            break;
        case PresentType_Candy:
            return @"糖果";
            break;
        case PresentType_Kiss:
            return @"亲亲";
            break;
        case PresentType_Rose:
            return @"玫瑰花";
            break;
        case PresentType_Watermelon:
            return @"西瓜";
            break;
        case PresentType_Pig:
            return @"招财猪";
            break;
        case PresentType_Car:
            return @"跑车";
            break;
        case PresentType_Six:
            return @"柠檬啪";
            break;
        case PresentType_Home:
            return @"城堡";
            break;
        case PresentType_Love:
            return @"爱心";
            break;
        case PresentType_Diamondring:
            return @"钻戒";
            break;
        case PresentType_Number:
            return @"1314";
            break;
        case PresentType_Wand:
            return @"魔杖";
            break;
        case PresentType_HappyBirdy:
            return @"生日蛋糕";
            break;
    }
}

#pragma mark - Override method
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 2;
    }
    return _queue;
}

- (NSOperationQueue *)carQueue
{
    if (!_carQueue) {
        _carQueue = [[NSOperationQueue alloc] init];
        _carQueue.maxConcurrentOperationCount = 1;
    }
    return _carQueue;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.respondController.view endEditing:YES];
}

-(void)animationWith:(GiftModel *)gift
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"giftChangeCharms" object:nil];
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = self;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    [manager animWithUserID:[NSString stringWithFormat:@"%@",gift.senderChatID] model:gift finishedBlock:^(BOOL result) {
        
    }];
}
@end
