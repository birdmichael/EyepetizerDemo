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
    
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]init];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    CategoriesTimeViewController *timeVC = [[CategoriesTimeViewController alloc]init];
    timeVC.categorie = self.categorie;
    [self setupViewControl:timeVC];  // 添加控制器
    [self addSegmentControlWithSegment:seg Name:@"按时间排序" andViewControl:timeVC]; // 通过控制器创建Segment
    
    
    CategoriesShareViewController *share = [[CategoriesShareViewController alloc]init];
    share.categorie = self.categorie;
    [self setupViewControl:share];  // 添加控制器
    [self addSegmentControlWithSegment:seg Name:@"分享排名榜" andViewControl:share];// 通过控制器创建Segment
    
   
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


- (void)setupViewControl:(UIViewController *)Vc
{
    
    [self addChildViewController:Vc];
    [self.view addSubview:Vc.view];
    Vc.edgesForExtendedLayout = UIRectEdgeNone;
    //添加数组
    [self.AllViews addObject:Vc.view];
    if (self.AllViews.count >1) {
        Vc.view.hidden = YES;
    }else{
        self.visibleView = Vc.view;
    }
    //设置frame
    Vc.view.frame = CGRectMake(0, 64+segmentH, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    NSLog(@"%@",Vc);
    
}
#pragma mark segment
- (void)addSegmentControlWithSegment:(UISegmentedControl *)seg Name:(NSString *)name andViewControl:(UIViewController *)vc
{
    seg.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), segmentH);
    seg.tintColor = coverViewColor;
    [seg setBackgroundColor:BMcolorWithAlpha(255, 255, 255, 0.3)];
    
    //设置字体
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = Font_China(14);
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    [seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [seg setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    
    [seg insertSegmentWithTitle:name atIndex:self.AllViews.count animated:YES];
    [seg addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    self.segmentedControl = seg;
}
- (void)segmentSelected {
    UIView *viewToShow = self.AllViews[self.segmentedControl.selectedSegmentIndex];
    if (self.visibleView == viewToShow) {
        return;
    }
    NSLog(@"%@",NSStringFromCGRect(viewToShow.frame));
    self.visibleView.hidden = YES;
    viewToShow.hidden = NO;
    self.visibleView = viewToShow;
}


-(NSMutableArray *)AllViews
{
    if(!_AllViews){
        self.AllViews = [[NSMutableArray alloc]init];
    }
    return _AllViews;
}

@end
