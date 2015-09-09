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
@interface MainTabBarViewController()<MainTabBarDelegate>
@end

@implementation MainTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeTableViewController *home = [[HomeTableViewController alloc]init];
    [self addChildVC:home WithTitle:@"每日精选"];
    
    CategoriesCollectionViewController *categries = [[CategoriesCollectionViewController alloc]init];
    [self addChildVC:categries WithTitle:@"往期分类"];
    
    
    for (UIView *subView in self.tabBarController.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            subView.height = 10;
        }
    }
    
    

}

- (void)addChildVC:(UIViewController *)childVc WithTitle:(NSString*)title;
{
        static MainTabBar *myTabBar;
        static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 自定义TabBar
        myTabBar = [[MainTabBar alloc]initWithFrame:self.tabBar.frame];
        // 隐藏系统tabBar
        self.tabBar.hidden = YES;
        // 1.改变UITransitionView 高度
        
        myTabBar.delegate = self;
        [self.view addSubview:myTabBar];
    });
    [myTabBar addTabBarBtnWithName:title];
//     创建导航控制器,子控制器为childVc
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    
    childVc.title                              = title;
    NSMutableDictionary *Attributes            = [NSMutableDictionary dictionary];
    Attributes[NSForegroundColorAttributeName] = BMcolor(141, 200, 81);
    Attributes[NSFontAttributeName]            = Font_ChinaBold(20);
    [childVc.tabBarItem setTitleTextAttributes:Attributes forState:UIControlStateNormal];
    //    childVc.tabBarItem.title = [[NSMutableAttributedString alloc]initWithString:title attributes:Attributes];
    // TabBar控制器添加子控制器
    [self addChildViewController:nav];
}

- (void)mainTabBar:(UIView *)tabar didSelectBtnfrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to; // 跳转控制器
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
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
