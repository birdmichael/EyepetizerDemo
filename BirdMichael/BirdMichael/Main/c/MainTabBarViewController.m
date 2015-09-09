//
//  MainTabBarViewController.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "HomeTableViewController.h"
#import "Header.h"
#import "MainTabBar.h"
#import "Header.h"
#import "UIView+XYWH.h"
#import "CategoriesCollectionViewController.h"



@implementation MainTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    HomeTableViewController *home = [[HomeTableViewController alloc]init];
    [self addChildVC:home WithTitle:@"每日精选"];
    
    CategoriesCollectionViewController *categries = [[CategoriesCollectionViewController alloc]init];
    [self addChildVC:categries WithTitle:@"往期分类"];


    
    

//    // 更换系统tabBar
    MainTabBar *tempBar = [[MainTabBar alloc]init];
    [self setValue:tempBar forKeyPath:@"tabBar"];

    
}

// 关闭屏幕默认旋转,在指定控制器添加
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIDeviceOrientationPortrait;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[AddMovieViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)addChildVC:(UIViewController *)childVc WithTitle:(NSString*)title;
{
    // 创建导航控制器,子控制器为childVc
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    
    
    // 设置文字
    childVc.title                              = title;
    NSMutableDictionary *Attributes            = [NSMutableDictionary dictionary];
    Attributes[NSForegroundColorAttributeName] = BMcolor(141, 200, 81);
    Attributes[NSFontAttributeName]            = Font_ChinaBold(20);
    [childVc.tabBarItem setTitleTextAttributes:Attributes forState:UIControlStateNormal];
//    childVc.tabBarItem.title = [[NSMutableAttributedString alloc]initWithString:title attributes:Attributes];
    // TabBar控制器添加子控制器
    [self addChildViewController:nav];
}
@end
