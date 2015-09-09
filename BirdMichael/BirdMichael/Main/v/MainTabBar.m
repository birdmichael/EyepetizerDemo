//
//  MainTabBar.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "MainTabBar.h"
#import "UIView+XYWH.h"
#import "Header.h"
@interface MainTabBar()
@end
@implementation MainTabBar
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize osize = [super sizeThatFits:size];
    osize.height = 30;
    return osize;
    
}


@end
