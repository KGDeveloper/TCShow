//
//  SDContactsTableViewCell.h



#import <UIKit/UIKit.h>
#import "TCLiveUserList.h"

@interface SDContactsTableViewCell : UITableViewCell

@property (nonatomic, strong) TCLiveUserList *model;

+ (CGFloat)fixedHeight;

@end
