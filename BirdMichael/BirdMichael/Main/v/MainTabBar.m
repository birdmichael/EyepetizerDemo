//
//  MainTabBar.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#define TabBarH (35)
#define LineTopPading (5)

#import "MainTabBar.h"
#import "UIView+XYWH.h"
#import "Header.h"
#import "NSString+SizeWithString.h"
@interface MainTabBar()
/**
 *  上一次按钮
 */
@property (nonatomic ,weak) UIButton *lastbarBtn;
/**
 *  分割线
 */
@property (nonatomic ,weak) UIView *lineView;
@end
@implementation MainTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BMcolorWithAlpha(250, 250, 250, 0.9);
    }
    return self;
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize osize = [super sizeThatFits:size];
    osize.height = 30;
    return osize;
    
}
- (void)addTabBarBtnWithName:(NSString *)name
{
    // ==== 创建按钮
    UIButton *barBtn  = [[UIButton alloc]init];
    // 2.设置按钮就标题及选中颜色
    barBtn.titleLabel.font = Font_China(14);
    [barBtn setTitle:name forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [barBtn setTitleColor:BMcolor(140, 140, 140) forState:UIControlStateNormal];
    
    // ==== 添加分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BMcolor(100, 100, 100);
    [barBtn addSubview:lineView];
    
    // 添加点击事件 (按下生效)
    [barBtn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchDown];
   
    // 添加按钮到BMTabBar
    [self addSubview:barBtn];
    if (self.subviews.count == 1) {
        [self barBtnClick:barBtn]; // 默认第一个按钮
    }
    
}
- (void)barBtnClick:(UIButton *)barBtn
{
    if ([self.delegate respondsToSelector:@selector(mainTabBar:didSelectBtnfrom:to:)]) {
        [self.delegate mainTabBar:self didSelectBtnfrom:self.lastbarBtn.tag to:barBtn.tag];
    }
    
    // 1.上一次选中状态恢复
    self.lastbarBtn.selected = NO;
    // 2.设置当前按钮状态
    barBtn.selected = YES;
    // 3.覆盖上一次选中状态
    self.lastbarBtn = barBtn;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    // 设置按钮frame

    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        // 计算frame
        CGFloat barW = self.frame.size.width / self.subviews.count;
        CGFloat barX = i * barW;
        CGFloat barY = 0;
        CGFloat BarH = self.frame.size.height;
        btn.frame = CGRectMake(barX, barY, barW, BarH);
        // 添加Tag为顺序
        btn.tag = i;
        
        for (UIView *view in btn.subviews) {
            if([view isKindOfClass:[UIView class]] && i > 0){ // 如果是View,且不是首个
                // 设置Line的Frame
                view.width = 1;
                view.height =  TabBarH - (LineTopPading * 2);
                view.x = 1;
                view.centerY = btn.centerY;}
        
        }
    
    }
}
@end
