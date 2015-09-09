//
//  NSData+BMDataTools.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/5.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (BMDataTools)
/**
 *  - MMM. dd -
 */
- (NSString *)formatterDate:(NSString *)date;

/**
 *  字符串转时间 /1000
 */
+ (NSData *)formatterDate:(NSString *)date;


@end
