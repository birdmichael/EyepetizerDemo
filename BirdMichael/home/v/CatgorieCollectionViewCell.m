//
//  CatgorieCollectionViewCell.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "CatgorieCollectionViewCell.h"
#import "Categorie.h"
#import "Header.h"
#import "UIView+XYWH.h"
#import "NSString+SizeWithString.h"
#import "UIImageView+WebCache.h"
@interface CatgorieCollectionViewCell()
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
@end

@implementation CatgorieCollectionViewCell
/**
 *  创建cell(从缓存池中取)
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView ItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatgorieCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor redColor];

    return (CatgorieCollectionViewCell *)cell;
}

#pragma mark 初始化子控件
/**
 *  初始化cell
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // 添加子控件
        [self setupCatgorieCell];
        
    }
    return self;
}
/**
 *  初始化子控件
 */
- (void)setupCatgorieCell
{
    // 背景大图
    UIImageView *bgView = [[UIImageView alloc]init];
    _bgView = bgView;
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 设置圆角边框,并裁减
//    _bgView.layer.borderWidth  = 0.5f;
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 5.0f;
    
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
    _centerTitleLabel.font = Font_ChinaBold(18);
    _centerTitleLabel.textColor = [UIColor whiteColor];
    [self.coverView addSubview:centerTitleLabel];

}

/**
 *  子控件布局
 */
- (void)layoutSubviews
{
    // 背景大图
    CGFloat bgViewW = self.contentView.width;
    CGFloat bgViewH = bgViewW;
    _bgView.width = bgViewW;
    _bgView.height = bgViewH;
    
    // 中间蒙版
    _coverView.frame = _bgView.frame;
    
    // 中间标题
    CGFloat centerTitleLabelW = [[self formatterStr:_categorie.name] sizeWithFont:_centerTitleLabel.font].width;
    CGFloat centerTitleLabelH = [[self formatterStr:_categorie.name] sizeWithFont:_centerTitleLabel.font].height;
    CGFloat centerTitleLabelX = (self.bgView.width - centerTitleLabelW) / 2;
    CGFloat centerTitleLabelY = (self.bgView.height - centerTitleLabelH) / 2;
    _centerTitleLabel.frame = CGRectMake(centerTitleLabelX, centerTitleLabelY, centerTitleLabelW, centerTitleLabelH);
}

#pragma mark - 数据相关
/**
 *  赋值
 */
- (void)setCategorie:(Categorie *)categorie
{
    _categorie = categorie;
    // 背景大图
    NSURL *url = [NSURL URLWithString:categorie.bgPicture];
    [self.bgView sd_setImageWithURL:url];
    
    // 中间标题
    self.centerTitleLabel.text = [self formatterStr:categorie.name];
}



#pragma mark - 数据相关
/**x
 *  格式工具
 */
- (NSString *)formatterStr:(NSString *)str
{
    return [NSString stringWithFormat:@"#%@",str];
}

@end
