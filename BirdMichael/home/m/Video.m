//
//  video.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "Video.h"
#import "Play.h"

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


@end
