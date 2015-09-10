//
//  Categorie.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/6.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "Categorie.h"

@implementation Categorie

/**
 *  	请求路径
 */
+ (NSString *)toPath
{
    return @"http://baobab.wandoujia.com/api/v1/categories";
}

/**
 *  	请求参数
 */
+ (NSDictionary *)toParameter
{
    return nil;
}
@end


