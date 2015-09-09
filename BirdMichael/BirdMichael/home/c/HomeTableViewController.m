//
//  HomeTableViewController.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "HomeTableViewController.h"
#import "UILabel+TextHight.h"
#import "VideoTableViewCell.h"
#import "MJRefresh.h"
#import "HttpTools.h"
#import "Daily.h"
#import "MBProgressHUD+BM.h"
#import "MJExtension.h"
#import "Header.h"
#import "VideoTableHeaderView.h"
#import "NSDate+DateTools.h"

#import "Video.h"
#import "BMVideoPlayerViewController.h"

@interface HomeTableViewController()
@property (nonatomic, strong) NSMutableArray *dailys;
@end
@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置添加消息barBtnItem
    [self addNavigationItem];
    
    //添加刷新控件
    [self addRefresh];
    // 初始化数据,自动下拉刷新
    [self.tableView.header beginRefreshing];
    
    // 取消分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark 添加刷新控件
- (void)addRefresh
{
    // 添加下拉刷新
    self.tableView.header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerWithRefreshingDate:)];
    // 添加下拉刷新
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerWithRefreshingMore:)];
    footer.appearencePercentTriggerAutoRefresh = -5;
    self.tableView.footer = footer;
    
    
    
}
/**
 *  下拉刷新
 */
- (void)headerWithRefreshingDate:(MJRefreshComponent *)refresh
{
    Daily *d           = [[Daily alloc]init];
    NSDate *date       = [NSDate date];

    NSTimeZone *zone   = [NSTimeZone systemTimeZone];

    NSInteger interval = [zone secondsFromGMTForDate: date];

    NSDate *localDate  = [date  dateByAddingTimeInterval: interval];
    

    [HttpTools GET:d.toPath parameters:[d toParameterWith:localDate] success:^(id json) {
        // 获取数据
        NSArray * jsonArrary = [[NSArray alloc]init];
        jsonArrary = json[@"dailyList"];
        NSMutableArray *arrary = [NSMutableArray array];
        for (int i = 0; i < jsonArrary.count; i++) {
            Daily *daily = [Daily objectWithKeyValues:jsonArrary[i]];
            
            [arrary addObject:daily];
        }
        self.dailys = arrary;
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
        NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        [self.tableView.header endRefreshing];
    }];
}

/**
 *  上拉加载更多
 */
- (void)footerWithRefreshingMore:(MJRefreshComponent *)refresh
{
    Daily *daliy = [self.dailys lastObject];
    NSMutableDictionary *dict = (NSMutableDictionary *)[daliy toParameterWith:nil];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[daliy.date longLongValue]/1000];
    // 设置日期格式
    NSDate *lastDate =[currentDate dateBySubtractingDays:1];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:lastDate];

    dict[@"date"] = dateString;
    [HttpTools GET:daliy.toPath parameters:dict success:^(id json) {
        // 获取数据
        NSArray * jsonArrary = [[NSArray alloc]init];
        jsonArrary = json[@"dailyList"];
        for (int i = 0; i < jsonArrary.count; i++) {
            Daily *daily = [Daily objectWithKeyValues:jsonArrary[i]];
            
            [_dailys addObject:daily];
        }

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
    attributes[NSFontAttributeName] = Font_EnglishFont(20);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"BirdMichael" attributes:attributes];
    UILabel *titleView = [[UILabel alloc]init];
    titleView.attributedText = title;
    [titleView setBounds:CGRectMake(0, 0, title.size.width, title.size.height)];
    self.navigationItem.titleView = titleView;

}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dailys.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Daily *daily = self.dailys[section];
    return daily.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建模型
    VideoTableViewCell *cell = [VideoTableViewCell cellWithTableView:tableView];

    // 传递模型
    Daily *daliy             = self.dailys[indexPath.section];
    Video *video             = daliy.videoList[indexPath.row];
    cell.video               = video;
    
    return cell;
}

#pragma mark headView
/**
 *  tableView-HeaderView 高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001; // 最小值,隐藏Header,内部空间不切割
}
/**
 *  tableView-HeaderView
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 传入时间数据
    VideoTableHeaderView *headerView = [[VideoTableHeaderView alloc]init];
    Daily *daliy = self.dailys[section];
    headerView.date = daliy.date;
    return headerView;
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
    Daily *daliy = self.dailys[indexPath.section];
    Video *video = daliy.videoList[indexPath.row];
    Vc.video = video;
    
    [self presentViewController:Vc animated:YES completion:nil];
}


#pragma mark 懒加载

-(NSMutableArray *)dailys
{
    if(!_dailys){
        _dailys = [[NSMutableArray alloc]init];
    }
    return _dailys;
}

@end
