//
//  XXFeedbackTableViewCell.h
//  TCShow
//
//  Created by tangtianshi on 17/1/8.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXFeedbackTableViewCellDelegate <NSObject>

- (void)returnTextViewString:(NSString *)text click:(UITableViewCell *)cell;

@end

@interface XXFeedbackTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (assign, nonatomic) id<XXFeedbackTableViewCellDelegate>delegate;

@end
