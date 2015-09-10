//
//  video.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Video : NSObject
/**
 *  	string	标题。
 */
@property (nonatomic, copy  ) NSString           *title;
/**
 *  	string	文字详情介绍。
 */
@property (nonatomic, copy  ) NSString           *videoDescription;
/**
 *  	string	分类。
 */
@property (nonatomic, copy  ) NSString           *category;
/**
 *  	string	图片。
 */
@property (nonatomic, copy  ) NSString           *coverForDetail;
/**
 *  	string	视频>play数组。
 */
@property (nonatomic, strong) NSArray            *playInfo;
/**
 *  	NSInteger	时长(秒)
 */
@property (nonatomic, assign) NSInteger          duration;

@end
