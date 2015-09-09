//
//  Play.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Play : NSObject
/**
 *  	string	清晰度
 */
@property (nonatomic, copy) NSString *name;
/**
 *  	string	清晰度类型。
 */
@property (nonatomic, copy) NSString *type;
/**
 *  	string	视频地址。
 */
@property (nonatomic, copy) NSString *url;

@end
