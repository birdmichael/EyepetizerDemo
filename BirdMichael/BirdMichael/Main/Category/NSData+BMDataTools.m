//
//  NSData+BMDataTools.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/5.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "NSData+BMDataTools.h"
#import "NSDate+DateTools.h"

@implementation NSData (BMDataTools)
- (NSString *)formatterDate:(NSString *)date
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[date integerValue]/1000.0];
    NSString *dateString = [currentDate formattedDateWithFormat:@"- MMM. dd -" locale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    return dateString;
}


@end
