//
//  Daily.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface Daily : NSObject
/**
 *     NSInteger 数量
 */
@property (nonatomic, assign) NSInteger total;
/**
 *  	NSArray	视频组模型>Video。
 */
@property (nonatomic, strong) NSArray *videoList;
/**
 *  	string	时间(从1970  *1000)。
 */
@property (nonatomic,copy) NSString *date;


/**
 *  	请求路径
 */
- (NSString *)toPath;

/**
 *  	请求参数
 */
- (NSDictionary *)toParameterWith:(NSDate *)date;
@end
