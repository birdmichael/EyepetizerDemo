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

- (NSString *)toPath
{
    return @"http://baobab.wandoujia.com/api/v1/feed?";
}

- (NSDictionary *)toParameterWith:(NSDate *)date;
{
    NSMutableDictionary *Parameter = [NSMutableDictionary dictionary];
    Parameter[@"num"] = @"10";
    if (!date) {
        Parameter[@"date"] = @"20150902";
        return Parameter;
    }

    // 设置日期格式
    NSString *dateString = [date formattedDateWithFormat:@"YYYYMMdd"];
    Parameter[@"date"] = dateString;
    return Parameter;
}

@end
