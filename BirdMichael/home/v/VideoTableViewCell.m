//
//  VideoTableViewCell.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "UIView+XYWH.h"
#import "UIImageView+WebCache.h"
#import "Video.h"
#import "Header.h"
#import "NSString+SizeWithString.h"

@interface VideoTableViewCell ()
/**
 *  背景大图
 */
@property (nonatomic ,weak) UIImageView *bgView;

/**
 *  蒙版
 */
@property (nonatomic ,weak) UIView *coverView;
/**
 *  中间标题
 */
@property (nonatomic ,weak) UILabel *centerTitleLabel;
/**
 *  类型及时长
 */
@property (nonatomic ,weak) UILabel *typeAndTimeLabel;


/**
 *  类型及时长
 */
@property (nonatomic ,copy) NSString *TypeAndTime;

@end
@implementation VideoTableViewCell

#pragma mark 创建Cell
- (instancetype)initWithTableView:(UITableView *)tableView
{
    VideoTableViewCell *cell = [VideoTableViewCell cellWithTableView:tableView];
    // code..
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"VideoTableViewCell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.clipsToBounds = YES;
        
    }
    
    // code..
    return cell;
}

#pragma mark 初始化VideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Cell初始化代码
        // 初始化微博
        [self setupVideoCell];
    }
    return self;
}

- (void)setupVideoCell
{
    // 背景大图
    UIImageView *bgView = [[UIImageView alloc]init];
    _bgView = bgView;
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:bgView];
    
    /**
     *  蒙版
     */
    UIView *coverView = [[UIView alloc]init];
    _coverView = coverView;
    _coverView.backgroundColor = coverViewColor;
    [self.bgView addSubview:coverView];
    
    // 中间标题
    UILabel *centerTitleLabel = [[UILabel alloc]init];
    _centerTitleLabel = centerTitleLabel;
    _centerTitleLabel.font = Font_ChinaBold(16);
    _centerTitleLabel.textColor = [UIColor whiteColor];
    [self.coverView addSubview:centerTitleLabel];
    
    // 类型及时长
    UILabel *typeAndTimeLabel = [[UILabel alloc]init];
    _typeAndTimeLabel = typeAndTimeLabel;
    _typeAndTimeLabel.font = Font_China(14);
    _typeAndTimeLabel.textColor = [UIColor whiteColor];
    [self.coverView addSubview:typeAndTimeLabel];
    
}

#pragma mark 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 背景大图
    CGFloat bgViewW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat bgViewH = CellH;
    _bgView.width = bgViewW;
    _bgView.height = bgViewH;
    
    // 中间View
    _coverView.frame = _bgView.frame;

    
    
    // 中间标题
    CGFloat centerTitleLabelW = [self.video.title sizeWithFont:_centerTitleLabel.font].width;
    CGFloat centerTitleLabelH = [self.video.title sizeWithFont:_centerTitleLabel.font].height;
    CGFloat centerTitleLabelX = (self.bgView.width - centerTitleLabelW) / 2;
    CGFloat centerTitleLabelY = (self.bgView.height / 2)  - centerTitleLabelH;
    _centerTitleLabel.frame = CGRectMake(centerTitleLabelX, centerTitleLabelY, centerTitleLabelW, centerTitleLabelH);

    
    // 类型及时长
    CGFloat typeAndTimeLabelW = [_TypeAndTime sizeWithFont:_typeAndTimeLabel.font].width;
    CGFloat typeAndTimeLabelH = [_TypeAndTime sizeWithFont:_typeAndTimeLabel.font].height;
    CGFloat typeAndTimeLabelX = (self.bgView.width - typeAndTimeLabelW) / 2;
    CGFloat typeAndTimeLabelY = (self.bgView.height / 2)  + typeAndTimeLabelH;
    _typeAndTimeLabel.frame = CGRectMake(typeAndTimeLabelX, typeAndTimeLabelY, typeAndTimeLabelW, typeAndTimeLabelH);
    
    
    
}


#pragma mark 传值
-(void)setVideo:(Video *)video
{
    
    _video = video;
    // 背景大图
    NSURL *url = [NSURL URLWithString:video.coverForDetail];
    [self.bgView sd_setImageWithURL:url];
    
    // 中间标题
    self.centerTitleLabel.text = video.title;
    
    // 赋值TypeAndTime
    NSString *time = [self timeWithSecondsToString:video.duration];
    _TypeAndTime = [NSString stringWithFormat:@"#%@ / %@",video.category , time];
    
    
    // 类型及时长
    self.typeAndTimeLabel.text = _TypeAndTime;
    
}
#pragma mark 懒加载
-(NSString *)TypeAndTime
{
    if(!_TypeAndTime){
        self.TypeAndTime = [[NSString alloc]init];
    }
    return _TypeAndTime;
}

#pragma mark 工具方法
/**
 *  序列化时间
 */
- (NSString *)timeWithSecondsToString:(NSInteger)time
{
    NSInteger min = time / 60;
    NSInteger Second = time % 60;
    if (min<10) {
        return [NSString stringWithFormat:@"0%ld' %ld''",(long)min ,(long)Second];  // 一位分钟0占位
    }
    return [NSString stringWithFormat:@"%ld' %ld''",(long)min ,(long)Second];
    
    
}



@end