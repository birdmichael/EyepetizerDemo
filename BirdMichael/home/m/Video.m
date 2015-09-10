//
//  video.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "Video.h"
#import "Play.h"
#import "Categorie.h"
#import "CategoriesTimeViewController.h"

@implementation Video
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"playInfo" : [Play class]
             };
}
+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"videoDescription" : @"description"};
}


/**
 *  	请求路径
 */
+ (NSString *)toPathFromCategorie
{
    return @"http://baobab.wandoujia.com/api/v1/videos?";
}

/**
 *  	请求参数
 */
+ (NSDictionary *)toParameterFromCategorie:(Categorie *)categorie WithController:(id)controller Withlength:(NSUInteger)length;
{
    NSMutableDictionary *Parameter = [NSMutableDictionary dictionary];
    Parameter[@"num"] = @"10";
    Parameter[@"categoryName"] = categorie.name;
    if ([controller isKindOfClass:[CategoriesTimeViewController class]]) {
        Parameter[@"strategy"] = @"date";
    }
    Parameter[@"start"] = [NSString stringWithFormat:@"%lu",(unsigned long)length];
    return Parameter;
}
@end
