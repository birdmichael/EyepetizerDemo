//
//  NSString+FormatterDate.h
//  BirdMichael
//
//  Created by 李 阳 on 15/9/10.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatterDate)
/**
 *  - MMM. dd -
 */
- (NSString *)formatterDateToMMMdd;

/**
 *  时间格式化 
 */
- (NSString *)formatterDateToYYMMDDToDay;

/**
 *  时间格式化 含1000
 */
- (NSString *)formatterDateToYYMMDDTo1000;
/**
 *  时间格式化昨天 不含1000
 */
- (NSString *)formatterDateToYYMMDDToYestday;
@end
