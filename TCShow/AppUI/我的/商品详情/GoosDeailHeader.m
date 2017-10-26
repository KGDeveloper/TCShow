//
//  GoosDeailHeader.m
//  TCShow
//
//  Created by liberty on 2017/1/11.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GoosDeailHeader.h"

@implementation GoosDeailHeader

- (IBAction)blockBtn:(UIButton *)sender {
    self.loockTopBlock();
}
- (IBAction)inputChatView:(UIButton *)sender {
    self.inputChatBlock();
}

- (IBAction)dianpuBtnClick:(id)sender {
    if (self.diannpuBtnClickBlock) {
        self.diannpuBtnClickBlock();
    }
}
- (IBAction)leixingBtnClick:(id)sender {
    if (self.leixingBtnClickBlock) {
        self.leixingBtnClickBlock();
    }
}
- (IBAction)morePingjiaBtnClick:(id)sender {
    if (self.pingjiaBtnClickBlock) {
        self.pingjiaBtnClickBlock();
    }
}


@end
