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
    
    // 设置添加消息barBtnItem
    [self addNavigationItem];
    
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
    
        weakSelf.videoList = [Video objectArrayWithKeyValuesArray:json[@"videoList"]];

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
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerWithRefreshingMore:)];
    footer.appearencePercentTriggerAutoRefresh = -5;
    self.tableView.footer = footer;
}

///**
// *  上拉加载更多
// */
- (void)footerWithRefreshingMore:(MJRefreshComponent *)refresh
{
    __weak typeof(self) weakSelf = self;
    [HttpTools GET:[Video toPathFromCategorie] parameters:[Video toParameterFromCategorie:self.categorie WithController:self Withlength:self.videoList.count] success:^(id json) {
        // 获取数据
        [weakSelf.videoList addObjectsFromArray:[Video objectArrayWithKeyValuesArray:json[@"videoList"]]];

        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark 设置Nav
/**
 *  设置Nav
 */
- (void)addNavigationItem
{
    
    //设置标题
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = Font_ChinaBold(17);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:self.categorie.name attributes:attributes];
    UILabel *titleView = [[UILabel alloc]init];
    titleView.attributedText = title;
    [titleView setBounds:CGRectMake(0, 0, title.size.width, title.size.height)];
    self.navigationItem.titleView = titleView;
    
    
    UIBarButtonItem *leftNav = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_back_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick)];
    leftNav.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftNav;
}
- (void)leftNavClick
{
    [self.navigationController popViewControllerAnimated:YES];
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