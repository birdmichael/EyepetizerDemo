//
//  VideoTableViewCell.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Video;
@interface VideoTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) Video *video;
@end


#define CellH ([[UIScreen mainScreen] bounds].size.width * 0.6)