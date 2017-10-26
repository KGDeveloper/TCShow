//
//  ContactItemTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactItemTableViewCell : UITableViewCell
{
@protected
    __weak id<IMAContactItemShowAble> _item;
}

- (void)configWithItem:(id<IMAContactItemShowAble>)item;

@end


@interface ContactPickItemTableViewCell : UITableViewCell
{
@protected
    
    UIButton    *_pick;
    UIImageView *_iconView;
    UILabel     *_nameLabel;
@protected
    __weak id<IMAContactItemShowAble> _item;
}

@property (nonatomic, weak) id<IMAContactItemShowAble> item;
@property (nonatomic, readonly) UIButton *pick;

- (void)configWithItem:(id<IMAContactItemShowAble>)item;

- (void)onPick;

@end
