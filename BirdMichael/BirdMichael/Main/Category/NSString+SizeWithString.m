//
//  NSString+SizeWithString.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "NSString+SizeWithString.h"

@implementation NSString (SizeWithString)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)MaxW
{
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc]init];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MaxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}
@end
