//
//  DIYRefresh.m
//  BirdMichael
//
//  Created by 李 阳 on 15/9/12.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "DIYRefresh.h"
#import "UIView+XYWH.h"
#import "NSDate+DateTools.h"
#import "Header.h"


#define logoH (35)

@interface DIYRefresh ()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@end

@implementation DIYRefresh
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = logoH + 14;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = coverViewColor;
    label.font = Font_EnglishFont(15);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;

    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon100"]];
    [self addSubview:logo];
    logo.clipsToBounds = YES;
    self.logo = logo;
    
    
    self.clipsToBounds = NO;

}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.logo.size = CGSizeMake(logoH, logoH);
    self.logo.centerX = self.centerX;
    self.logo.centerY = self.mj_h * 0.5;
    self.label.width = self.width;
    self.label.height = 20;
    self.label.center = CGPointMake(self.mj_w * 0.5, -self.label.height *0.5);

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
        case MJRefreshStateIdle:
            [self setLabelHowlongTimeRefresh];
            [self showLogoAnimate:NO];
            break;
        case MJRefreshStatePulling:
            [self setLabelHowlongTimeRefresh];
            break;
        case MJRefreshStateRefreshing:
            [self showLogoAnimate:YES];
            [self setLabelHowlongTimeRefresh];

            break;
        default:
            [self setLabelHowlongTimeRefresh];
            [self showLogoAnimate:NO];
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];

}

#pragma mark 动画
-(void) showLogoAnimate:(BOOL)show {
    if (show) {// 显示动画
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 2;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
            [self.logo.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        
        
    } else {// 移除动画
      
          [self.logo.layer removeAllAnimations];
  
    }
    
}

- (void)setLabelHowlongTimeRefresh
{

    int iHours = 23 - (int)[[NSDate date] formattedDateWithFormat:@"HHHH"].integerValue ;
    int iMinutes = 59 - (int)[[NSDate date] formattedDateWithFormat:@"mm"].integerValue ;
    NSString *str = [NSString stringWithFormat:@"距离更新还有%d小时%d分" ,iHours ,iMinutes];
    

    self.label.text = str;
}

@end
