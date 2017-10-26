//
//  XConcernCell.m
//  live
//
//  Created by admin on 16/5/30.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "XConcernCell.h"
#import "Macro.h"
@implementation XConcernCell


//-(void)setHeadIcon:(UIImageView *)headIcon{
//    headIcon.layer.masksToBounds = YES;
//    headIcon.layer.cornerRadius = 20;
//}

//-(void)setCellImage:(UIImageView *)cellImage{
//    
//    cellImage.frame = CGRectMake(0, 54, self.frame.size.width,CELL_IMAGE_HEIGHT);
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configWith:_liveItem];
    // Initialization code
}
//-(void)setConcernModel:(ConcernModel *)concernModel{
//    _concernModel = concernModel;
//    self.username.text = concernModel.user_nickname;
//    self.contntTitle.text = concernModel.subject;
//    self.watchNum.text = concernModel.viewernum;
//    self.heartNum.text = concernModel.praisenum;
//     NSString *coverUrl = [NSString stringWithFormat:IMG_PREFIX,concernModel.coverimagepath];
//
//    [_cellImage sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:kDefaultCoverIcon];
//    NSString *logoUrl = [NSString stringWithFormat:IMG_PREFIX,concernModel.header_img];
//    [_headIcon sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:kDefaultUserIcon];
//    
//}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = 20;
    self.cellImage.frame = CGRectMake(0, 54, self.frame.size.width,CELL_IMAGE_HEIGHT);
}
- (void)configWith:(TCShowLiveListItem *)item
{
    id<IMUserAble> host = [item liveHost];
    [_cellImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,[item liveCover]]] placeholderImage:kDefaultCoverIcon];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMG_PREFIX,[host imUserIconUrl]]]  placeholderImage:kDefaultUserIcon];
   
    if (item)
    {
        _username.text = [host imUserName];
        _contntTitle.text = [item liveTitle];
        _watchNum.text = [NSString stringWithFormat:@"%d", (int)[item liveWatchCount]];
        _heartNum.text = [NSString stringWithFormat:@"%d", (int)[item livePraise]];
        if (![[[item lbs] address] isEqualToString:@""]) {
            _address.text = [[item lbs] address];
        }else{
            
            _address.text = @"难道在火星？";
        }
        
    }
    else
    {
        _contntTitle.text = @"测试直播标题";
        _username.text = @"测试帐号";
        _watchNum.text = @"1000";
        _heartNum.text = @"2000";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
