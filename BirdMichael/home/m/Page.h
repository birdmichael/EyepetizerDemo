//
//  DaliyList.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/6.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Daily;
@interface Page : NSObject
/**
 *  	string	每日对象(Daily对象)。
 */
@property (nonatomic ,strong) NSArray *dailyList;

/**
 *  	请求路径
 */
+ (NSString *)toPath;

/**
 *  	请求参数(传入时间)
 */
+ (NSDictionary *)toParameterWith:(NSDate *)date;
/**
 *  	请求参数(传入字符串)
 */
+ (NSDictionary *)toParameterWithSrt:(NSString *)str;
@end
