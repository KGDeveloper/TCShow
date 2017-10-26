//
//  QZKRechargeView.h
//  TCShow
//
//  Created by  m, on 2017/9/19.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZKRechargeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    id<AVRoomAble> av_room_ID;
}

//- (int)

@property (nonatomic,assign) NSMutableArray *dataArr;
@property (nonatomic,assign) NSString *av_room_id;
@property (nonatomic,strong) UIButton *firstBtu;
@property (nonatomic,strong) UIButton *secondBtu;
@property (nonatomic,strong) UIButton *threidBtu;
@property (nonatomic,strong) UIButton *chargeBtu;
@property (nonatomic,strong) UIView *chargerView;
@property (nonatomic,assign) NSMutableArray *lemon_idArr;//存放订单号
@property (nonatomic,assign) NSMutableArray *titleArr;//存放按钮名称
@property (nonatomic,strong) UITableView *tableView;


- (void)createData:(NSString *)room_id;

@end
