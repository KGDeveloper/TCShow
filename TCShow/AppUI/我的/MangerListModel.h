//
//  MangerListModel.h
//  TCShow
//
//  Created by  m, on 2017/9/4.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MangerListModel : NSObject

@property (nonatomic,assign) NSString *goods_name;
@property (nonatomic,assign) NSString *goods_num;
@property (nonatomic,assign) NSString *goods_price;
@property (nonatomic,assign) NSString *original_img;
@property (nonatomic,assign) NSString *order_sn;
@property (nonatomic,assign) NSString *address;
@property (nonatomic,assign) NSString *shipping_code;
@property (nonatomic,assign) NSString *shipping_name;
@property (nonatomic,assign) NSString *order_status_desc;
@property (nonatomic,assign) NSString *order_id;
@property (nonatomic,assign) NSString *status;
@property (nonatomic,assign) NSString *ID;


/*初始化*
 *dic 传过去需要解析的字典
 */
- (instancetype) initWithDictionary:(NSMutableDictionary*)dic;

@end
