//
//  CatgoriesTimeAndShareViewController.m
//  BirdMichael
//
//  Created by 李 阳 on 15/9/19.
//  Copyright © 2015年 BirdMIchael. All rights reserved.
//
#define segmentH (35)

#import "CatgoriesTimeAndShareViewController.h"
#import "CategoriesTimeViewController.h"
#import "CategoriesShareViewController.h"
#import "UIView+ConstraintHelper.h"
#import "Categorie.h"
#import "Header.h"


@interface CatgoriesTimeAndShareViewController ()
@property(nonatomic, weak) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) NSMutableArray *AllViews;
@property(nonatomic, weak) UIView *visibleView;

@end

@implementation CatgoriesTimeAndShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置添加消息barBtnItem
    [self addNavigationItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // 创建并初始化Segment
    [self addSegmentControl];
    
    CategoriesTimeViewController *timeVC = [[CategoriesTimeViewController alloc]init];
    timeVC.categorie = self.categorie;
    [self setupViewControl:timeVC AndSegmentControlWithName:@"按时间排序"]; // 初始化控制器,并设置对应segment名称
    
    
    CategoriesShareViewController *share = [[CategoriesShareViewController alloc]init];
    share.categorie = self.categorie;
    [self setupViewControl:share AndSegmentControlWithName:@"分享排名榜"];// 初始化控制器,并设置对应segment名称
    
   
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

#pragma mark 初始化控制器,并设置对应segment名称
- (void)setupViewControl:(UIViewController *)vc AndSegmentControlWithName:(NSString *)name
{
    // 添加View
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];

    //添加数组
    [self.AllViews addObject:vc.view];
    if (self.AllViews.count >1) {
        vc.view.hidden = YES;
    }else{  // 第一个View
        self.visibleView = vc.view;
    }
    //设置frame
    vc.view.frame = CGRectMake(0, 64+segmentH, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    // 设置对应segment名称
    [self.segmentedControl insertSegmentWithTitle:name atIndex:self.AllViews.count animated:YES];
    self.segmentedControl.selectedSegmentIndex = 0;
}
#pragma mark segment
- (void)addSegmentControl
{
    UISegmentedControl *seg = [[UISegmentedControl alloc]init];
    
    seg.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), segmentH);
    seg.tintColor = coverViewColor;
    
    [seg setBackgroundColor:BMcolorWithAlpha(255, 255, 255, 0.3)];
    
    //设置字体
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = Font_China(14);
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    [seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [seg setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    [self.view addSubview:seg];
    [seg addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    
    
    self.segmentedControl = seg;
}

- (void)segmentSelected {
    UIView *viewToShow = self.AllViews[self.segmentedControl.selectedSegmentIndex];
    if (self.visibleView == viewToShow) {
        return;
    }
    self.visibleView.hidden = YES;
    viewToShow.hidden = NO;
    self.visibleView = viewToShow;
}

#pragma mark 延时加载

-(NSMutableArray *)AllViews
{
    if(!_AllViews){
        self.AllViews = [[NSMutableArray alloc]init];
    }
    return _AllViews;
}

@end
