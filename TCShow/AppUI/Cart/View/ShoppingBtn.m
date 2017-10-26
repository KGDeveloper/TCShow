//
//  ShoppingBtn.m
//  TDS
//
//  Created by 黎金 on 16/3/25.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingBtn.h"
#import "Util.h"
@implementation ShoppingBtn

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;

    }
    return self;
}



#pragma mark 根据父类的rect设定并返回文本label的rect
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleW=0;
    CGFloat titleH=0;
    CGFloat titleX=0;
    CGFloat titleY=0;
    
    contentRect=(CGRect){{titleX,titleY},{titleW,titleH}};
    return contentRect;
}

#pragma  mark根据父类的rect设定并返回Image的rect
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW=25;
    CGFloat imageH=25;
    CGFloat imageX=(self.frame.size.width - 25)*0.5;
    CGFloat imageY=(self.frame.size.height - 25)*0.5;
    
    contentRect=(CGRect){{imageX,imageY},{imageW,imageH}};
    return contentRect;
}


@end
