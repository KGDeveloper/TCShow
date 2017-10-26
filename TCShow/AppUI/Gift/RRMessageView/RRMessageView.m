//
//  RRMessageView.m
//  直播消息Demo
//
//  Created by gongcz on 16/5/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "RRMessageView.h"
#import "Macro.h"
#import "SendGiftCell.h"
#import "MessageCell.h"

@interface RRMessageView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RRMessageView


/**
 **
 **礼物票品
 **
 **/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.datasource = [NSMutableArray array];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        [self.tableView addGestureRecognizer:tap];
        [self addSubview:self.tableView];
       
    }
    return self;
}


//- (void)awakeFromNib
//{
//    self.backgroundColor = [UIColor clearColor];
//    self.datasource = [NSMutableArray array];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//    [self.tableView addGestureRecognizer:tap];
//    [self addSubview:self.tableView];
//}

- (void)hideKeyBoard
{
    [self.respondController.view endEditing:YES];
}

#pragma mark - UITableViewDataSource & delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCellModel *model = [self.datasource objectAtIndex:indexPath.row];
    return model.cellheight;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCellModel *model = [self.datasource objectAtIndex:indexPath.row];
    
    
    if (model.isSendGift) {
        SendGiftCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (cell1 == nil) {
            cell1 = [[SendGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        }
        cell1.model = model;
        cell1.messageLabel.attributedText = model.content;
        cell1.giftImageView.image = [UIImage imageNamed:model.imageName];
        return cell1;
    }
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = model;
    cell.messageLabel.attributedText = model.content;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.respondController.view endEditing:YES];
}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.respondController.view endEditing:YES];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.respondController.view endEditing:YES];
}

@end
