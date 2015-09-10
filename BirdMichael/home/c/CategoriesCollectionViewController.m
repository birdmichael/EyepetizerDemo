//
//  CategoriesCollectionViewController.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/6.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "CategoriesCollectionViewController.h"
#import "Header.h"
#import "HttpTools.h"
#import "Categorie.h"
#import "MBProgressHUD+BM.h"
#import "MJExtension.h"
#import "CatgorieCollectionViewCell.h"
@interface CategoriesCollectionViewController()
@property (nonatomic ,strong) NSArray *categories;
@end

@implementation CategoriesCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // 加载数据
    [self addViewData];
    
    // 注册cell
    [self.collectionView registerClass:[CatgorieCollectionViewCell class] forCellWithReuseIdentifier:CellID];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    self.collectionView.backgroundColor = BMcolorWithAlpha(240, 240, 240, 0.9);
}


/**
 *  初始化
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [self settingLayout];
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self addNavigationItem];
        
    }
    return self;
}

/**
 *  加载数据
 */
- (void)addViewData
{
    [HttpTools GET:[Categorie toPath] parameters:[Categorie toParameter] success:^(id json) {
        // 保存数据
        _categories = [Categorie objectArrayWithKeyValuesArray:json];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 提示网络故障
        [MBProgressHUD showError:@"网络故障"];
    }];
}

#pragma mark 设置布局
- (UICollectionViewFlowLayout *)settingLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置间距
    CGFloat spacing = 3;
    layout.minimumLineSpacing = spacing;
    layout.minimumInteritemSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, 0, spacing); // 上部内边距
    
    // 设置Item的Size
    CGFloat ItemW = (ScreenSize.width - spacing) / 2 - spacing;
    CGFloat ItemH = ItemW;
    layout.itemSize = CGSizeMake(ItemW, ItemH);
    
    return layout;
    
}

#pragma mark 设置Nav
/**
 *  设置Nav
 */
- (void)addNavigationItem
{
    //设置标题
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = Font_EnglishFont(20);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"BirdMichael" attributes:attributes];
    UILabel *titleView = [[UILabel alloc]init];
    titleView.attributedText = title;
    [titleView setBounds:CGRectMake(0, 0, title.size.width, title.size.height)];
    self.navigationItem.titleView = titleView;
    
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categories.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    CatgorieCollectionViewCell *cell = [CatgorieCollectionViewCell cellWithCollectionView:collectionView ItemAtIndexPath:indexPath];
    
    Categorie *categorie = self.categories[indexPath.row];
        // 传输数据
    cell.categorie = categorie;

    return cell;
}
#pragma mark -- UICollectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
}
#pragma mark -- 懒加载
-(NSArray *)categories
{
    if(!_categories){
        self.categories = [[NSArray alloc]init];
    }
    return _categories;
}
@end
