//
//  MoviewPlayer.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "MoviewPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Play.h"
@interface MoviewPlayer()
/**
 *  视频播放控制器
 */
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerVc;

@property (nonatomic, assign) BOOL exit;

@end

@implementation MoviewPlayer
#pragma mark - 控制器视图方法
- (void)viewDidLoad {
    [super viewDidLoad];
    _exit = NO;
    
    //播放
    [self.moviePlayerVc.moviePlayer play];
    
    //添加通知
    [self addNotification];


    
}

#pragma mark 设置两种横竖屏方式
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return toInterfaceOrientation = (UIDeviceOrientationLandscapeLeft| UIDeviceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
// 关闭屏幕默认旋转,在指定控制器添加
- (BOOL)shouldAutorotate
{
    if (_exit == YES) { // 如果是这个 vc 则支持自动旋转
        return NO;
    }
    return YES;
}


#pragma mark - 私有方法
/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSURL *url=[NSURL URLWithString:self.play.url];
    return url;
}
- (void)setPlay:(Play *)play
{
    _play = play;
}
/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerViewController *)moviePlayerVc{
    if (!_moviePlayerVc) {
        NSURL *url = [self getNetworkUrl];
        _moviePlayerVc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
        _moviePlayerVc.view.frame = self.view.bounds;
        _moviePlayerVc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayerVc.view];
    }
    return _moviePlayerVc;
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerDidExitFullscreen:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerVc.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:self.moviePlayerVc.moviePlayer];
    
}

/**
 *  播放完成,或其他退出
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerDidExitFullscreen:(NSNotification *)notification{

    _exit = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
