//
//  HttpTools.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "HttpTools.h"
#import "AFNetworking.h"
@implementation HttpTools

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mrg = [AFHTTPRequestOperationManager manager];
    [mrg POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mrg = [AFHTTPRequestOperationManager manager];
    [mrg GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
        success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
        failure(error);
        }

    }];
}
@end
