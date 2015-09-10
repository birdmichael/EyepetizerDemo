//
//  Daily.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "Daily.h"
#import "video.h"
#import "NSDate+DateTools.h"
@implementation Daily
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"videoList" : [Video class]
             };
}

/**
 *  	请求路径
 */
- (NSString *)toPath
{
    return nil;
}

/**
 *  	请求参数
 */
- (NSDictionary *)toParameterWith:(NSDate *)date
{
    return nil;
}

@end
