//
//  CategoriesTimeViewController.m
//  BirdMichael
//
//  Created by 李 阳 on 15/9/11.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "CategoriesTimeViewController.h"
#import "MJRefresh.h"
#import "VideoTableViewCell.h"
#import "Header.h"
#import "Video.h"
#import "Categorie.h"
#import "HttpTools.h"
#import "BMVideoPlayerViewController.h"
#import "MBProgressHUD+BM.h"
#import "MJExtension.h"

#import "UIView+XYWH.h"
#import "DIYAutoRefreshFooter.h"
@interface CategoriesTimeViewController()
@property (nonatomic, strong) NSMutableArray *videoList;

@end
@implementation CategoriesTimeViewController
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style]) {
        // Cell初始化代码

    }
    return self;
}


- (void)viewDidLoad
{
    
    [self addVideoDate];
    
    //添加刷新控件
    [self addRefresh];
    // 初始化数据,自动下拉刷新

    
    // 取消分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    
}
- (void)addVideoDate
{
    __weak typeof(self) weakSelf = self;
    [HttpTools GET:[Video toPathFromCategorie] parameters:[Video toParameterFromCategorie:self.categorie WithController:self Withlength:self.videoList.count] success:^(id json) {
        // 获取数据[Video objectArrayWithKeyValuesArray:json[@"videoList"]];
        NSArray *array = json[@"videoList"];
        
        weakSelf.videoList = [Video objectArrayWithKeyValuesArray:array];
        
        // 刷新表格
            [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}

#pragma mark  - 添加刷新相关

/**
 *  添加刷新
 */

- (void)addRefresh
{
    // 添加上拉刷新
    DIYAutoRefreshFooter *footer = [DIYAutoRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerWithRefreshingMore:)];
    footer.colseAutomaticallyAdjustsSuperViewInsets = YES;
    self.tableView.footer = footer;
    NSLog(@"%@",NSStringFromCGRect(footer.frame));
}

///**
// *  上拉加载更多
// */
- (void)footerWithRefreshingMore:(MJRefreshComponent *)refresh
{
    __weak typeof(self) weakSelf = self;
    [HttpTools GET:[Video toPathFromCategorie] parameters:[Video toParameterFromCategorie:self.categorie WithController:self Withlength:self.videoList.count] success:^(id json) {
         NSArray *array = json[@"videoList"];
        if(array.count == 0){
            [self.tableView.footer noticeNoMoreData];
        }else{
        // 获取数据
        [weakSelf.videoList addObjectsFromArray:[Video objectArrayWithKeyValuesArray:array]];

        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
            [self.tableView.footer endRefreshing];}
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark 数据源方法


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ;
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建模型
    VideoTableViewCell *cell = [VideoTableViewCell cellWithTableView:tableView];
    
    // 传递模型
    Video *video             = self.videoList[indexPath.row];
    cell.video               = video;
    
    return cell;
}

#pragma mark tableView代理方法
/**
 *  tableView行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建控制器
    BMVideoPlayerViewController *Vc = [[BMVideoPlayerViewController alloc]init];
    // 传递模型
    Video *video = self.videoList[indexPath.row];
    Vc.video = video;
    
    [self presentViewController:Vc animated:YES completion:nil];
}



#pragma mark 懒加载

-(NSMutableArray *)videoList
{
    if(!_videoList){
        _videoList = [[NSMutableArray alloc]init];
    }
    return _videoList;
}
@end
