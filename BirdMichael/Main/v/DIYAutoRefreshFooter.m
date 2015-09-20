//
//  DIYAutoFooter.m
//  BirdMichael
//
//  Created by 李 阳 on 15/9/13.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "DIYAutoRefreshFooter.h"
#import "Header.h"
#import "UIView+XYWH.h"
@interface DIYAutoRefreshFooter()
@property (nonatomic, weak)UILabel *label;
@end
@implementation DIYAutoRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 160;
    self.triggerAutomaticallyRefreshPercent = -0.5;
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = Font_EnglishFont(18);
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self addSubview:label];
    self.label = label;


}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
//    self.label.frame =self.bounds;
    self.label.y = 30;
    self.label.centerX = self.centerX;
    self.label.width = self.width;
    self.label.height = 30;
  

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateNoMoreData:
            self.label.text = @"- The end -";
            self.hidden= NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}

- (void)setColseAutomaticallyAdjustsSuperViewInsets:(BOOL)colseAutomaticallyAdjustsSuperViewInsets{
    _colseAutomaticallyAdjustsSuperViewInsets = colseAutomaticallyAdjustsSuperViewInsets;
    self.mj_h += 64;
}
@end
