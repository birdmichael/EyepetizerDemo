//
//  VideoTableHeaderView.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/4.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "VideoTableHeaderView.h"
#import "Header.h"
#import "UIView+XYWH.h"
#import "NSString+SizeWithString.h"
#import "NSString+FormatterDate.h"

@interface VideoTableHeaderView()
@property (nonatomic ,weak) UILabel *dateLabel;
@end
@implementation VideoTableHeaderView

/**
 *  初始化
 */
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.font = Font_EnglishFont(15);
        dateLabel.backgroundColor = BMcolorWithAlpha(255, 255, 255, 0.6);
        
        // 设置圆角边框,并裁减
        dateLabel.layer.borderWidth  = 1.5f;
        dateLabel.clipsToBounds = YES;
        dateLabel.layer.cornerRadius = 5.0f;
        _dateLabel = dateLabel;
        [self addSubview:dateLabel];
    }
    return self;
}
/**
 *  子控件布局
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    _dateLabel.size = [[self.date formatterDateToMMMdd] sizeWithFont:Font_EnglishFont(15)];
    _dateLabel.height += 6; // 避免边框与文字重叠,高度在文字宽度基础上添加6

    _dateLabel.y = 5; //  向下偏移量
    _dateLabel.centerX = self.centerX;
}

/**
 *  赋值
 */
- (void)setDate:(NSString *)date {
    if (!date) {
        return;
    }
    _date = date;
    _dateLabel.text = date.formatterDateToMMMdd;
    
}






@end
