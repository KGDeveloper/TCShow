//
//  EditCartView.m
//  TDS
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "EditCartView.h"
#import "Util.h"
#define TextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
@implementation EditCartView
{

    NSInteger num;
    
    UIView *topView;
    UIButton *minusBtn;
    UILabel *numLabel;
    UIButton *addBtn;
    
    UIView *bottomView;
    UILabel *styleLabel;
    UIImageView *imageView;
    
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        num = 1;
        topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
        topView.backgroundColor = YCColor(251, 251, 251, 1);
        [self addSubview:topView];
        
        minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.height +5, topView.frame.size.height)];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        minusBtn.titleLabel.font = [UIFont systemFontOfSize:37.0];
        [minusBtn addTarget:self action:@selector(MinusBtn:) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:minusBtn];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(topView.frame.size.height +5, (topView.frame.size.height - 18)/2,topView.frame.size.width - (topView.frame.size.height +5) *2, 18)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = TextColor;
        numLabel.font = [UIFont systemFontOfSize:17.0];
        [topView addSubview:numLabel];
        [Util setFoursides:numLabel Direction:@"left" sizeW:18];
        [Util setFoursides:numLabel Direction:@"right" sizeW:18];
        
        addBtn = [[UIButton alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:numLabel Direction:@"X"], 0, topView.frame.size.height +5, topView.frame.size.height)];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitleColor:YCColor(51, 51, 51, 1) forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:25.0];
        [addBtn addTarget:self action:@selector(AddBtn:) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:addBtn];
        
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [Util setFoursides:bottomView Direction:@"top" sizeW:frame.size.width];
        [self addSubview:bottomView];
        [Util addClickEvent:self action:@selector(bottom) owner:bottomView];
        
        
        styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bottomView.frame.size.width - 15 - 30, frame.size.height/2)];
        styleLabel.textColor = YCColor(102, 102, 102, 1);
        styleLabel.font = [UIFont systemFontOfSize:13.0];
        [bottomView addSubview:styleLabel];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:styleLabel Direction:@"X"] + 3, frame.size.height/4- 7.5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"down.png"];
        [bottomView addSubview:imageView];
        
    }
    return self;
}



-(void)MinusBtn:(UIButton *)sender{
    
    if ((num - 1) <= 0 || num == 0) {
        
       
        
    }else{
        
        num  = num -1;
    }
    
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    [_delegate EditCartView:num];

}

-(void)AddBtn:(UIButton *)sender{
    
    if (num >= 10 ) {
        
    }else{
        
        num = num +1;
    }
    
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    [_delegate EditCartView:num];
}

-(void)bottom{

    [_delegate EditCartView];
}


-(void)setNumInteger:(NSInteger)numInteger{
    
    _numInteger = numInteger;
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)_numInteger];
    num = _numInteger;
}

-(void)setStyleString:(NSString *)styleString{

    styleLabel.text = styleString;
}

-(void)setMinInteget:(NSInteger)minInteget{
    
    _minInteget = minInteget;
    if (_minInteget == 0) {
        
        [_delegate EditCartView:_minInteget];
        numLabel.text = @"0";
        num = 0;
        
    }else if (_minInteget<=[numLabel.text integerValue]){
        
        [_delegate EditCartView:_minInteget];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)_minInteget];
        num = _minInteget;
    }
    
}


@end
