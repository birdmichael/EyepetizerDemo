//
//  HttpTools.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTools : NSObject
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
