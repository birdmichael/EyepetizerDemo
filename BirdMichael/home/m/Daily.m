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


@end
