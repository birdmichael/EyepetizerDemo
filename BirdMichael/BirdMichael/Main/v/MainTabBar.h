//
//  MainTabBar.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//
#define TabBarH (35)

#import <UIKit/UIKit.h>
@protocol MainTabBarDelegate <NSObject>

@optional
- (void)mainTabBar:(UIView *)tabar didSelectBtnfrom:(NSInteger)from to:(NSInteger)to;
@end

@interface MainTabBar : UIView
@property (nonatomic ,weak) id<MainTabBarDelegate> delegate;
- (void)addTabBarBtnWithName:(NSString *)name;
@end
