//
//  UIBarButtonItem+itemLeftAndRightBtn.m
//  linju
//
//  Created by 李 阳 on 15/8/18.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "UIBarButtonItem+AddImageItem.h"
#import "UIView+XYWH.h"

@implementation UIBarButtonItem (AddImageItem)

+ (UIBarButtonItem *)ItemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (highImage) {
        [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    };
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}


- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action rendering:(BOOL)rendering;
{
    // 判断是否需要渲染.
    if (rendering == NO) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return [self initWithImage:image style:style target:target action:action];
}
@end
