//
//  CatgorieCollectionViewCell.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CellID = @"UICollectionViewCell";
@class Categorie;
@interface CatgorieCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Categorie *categorie;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView ItemAtIndexPath:(NSIndexPath *)indexPath;
@end
