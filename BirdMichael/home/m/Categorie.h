//
//  Categorie.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/6.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categorie : NSObject
/**
 *  	string	分类名称。
 */
@property (nonatomic, copy) NSString *name;

/**
 *  	string	背景图片Url地址。
 */
@property (nonatomic, copy) NSString *bgPicture;



#pragma mark 请求参数
/**
 *  	请求路径
 */
+ (NSString *)toPath;

/**
 *  	请求参数
 */
+ (NSDictionary *)toParameter;
@end
