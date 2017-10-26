//
//  SegmentView.m
//  live
//
//  Created by hysd on 15/8/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "SegmentView.h"
#import "Macro.h"
@interface SegmentView(){
    UISegmentedControl* segmentControl;
    UIView* indicatorView;
}
@end
@implementation SegmentView


- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border{
    self = [super initWithFrame:frame];
    if(self){
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        for(int index = 0; index < items.count; index++){
            [segmentControl insertSegmentWithTitle:items[index] atIndex:index animated:NO];
        }
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor whiteColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: [UIColor whiteColor]};// RGB16(COLOR_FONT_RED)
//        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: RGB16(COLOR_FONT_DARKGRAY)};
//        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-3, frame.size.width/items.count, 3)];
        indicatorView.backgroundColor = RGB16(COLOR_BG_RED);
        
        
        [self addSubview:segmentControl];
        if(border){
            UIView* sep = [[UIView alloc] initWithFrame:CGRectMake(0, segmentControl.frame.size.height-1, segmentControl.frame.size.width, 1)];
            sep.backgroundColor = RGB16(COLOR_BG_GRAY);
            [segmentControl addSubview:sep];
        }
//        [self addSubview:indicatorView];
    }
    return self;
}
- (void)segmentChanged:(id)sender{
    NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
    [UIView animateWithDuration:0.2f animations:^{
        indicatorView.frame = CGRectMake(newX, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
    }];
    if(self.delegate){
        [self.delegate segmentView:self selectIndex:segmentControl.selectedSegmentIndex];
    }
}
- (void)setSelectIndex:(NSInteger)index{
    segmentControl.selectedSegmentIndex = index;
    NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
    [UIView animateWithDuration:0.2f animations:^{
        indicatorView.frame = CGRectMake(newX, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
    }];
}
- (NSInteger)getSelectIndex{
    return segmentControl.selectedSegmentIndex;
}
@end
