//
//  NSString+SizeWithString.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (SizeWithString)

- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)MaxW;
@end
