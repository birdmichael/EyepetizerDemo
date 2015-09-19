//
//  BMVideoPlayerViewController.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "BMVideoPlayerViewController.h"
#import "BMVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+ConstraintHelper.h"
#import "Play.h"
#import "Video.h"
#import "MBProgressHUD+BM.h"
@interface BMVideoPlayerViewController () <videoViewDelegate>
@property (nonatomic, strong) BMVideoView *player;
@end

@implementation BMVideoPlayerViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    Play *play = [self.video.playInfo firstObject];
    [self preparePlayerWithURL:[NSURL URLWithString:play.url]];
//    [self setupAndStartPlaying:nil];
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

    return YES;
}

#pragma mark - PHIVideoPlayerView preparation and setup

- (void)preparePlayerWithURL:(NSURL*)url {
    // 设置菊花
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:activityView];
    [activityView centerInSuperview];
    
    
    // 视频时长
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"duration"] completionHandler:^{
        NSError *error = nil;
        switch ([asset statusOfValueForKey:@"duration" error:&error]) {
            case AVKeyValueStatusLoaded:
                [activityView stopAnimating];
                [activityView removeFromSuperview];
                [self setupAndStartPlaying:asset.URL];
                break;
            default:
                NSLog(@"%s: %@", __func__, [error localizedDescription]);
                break;
        }
        
    }];
    
}

- (void)setupAndStartPlaying:(NSURL*)url {
    dispatch_async(dispatch_get_main_queue(), ^{ //asset是子线程,返回主线程
        // 创建播放View
        [self setupPlayer:url];
        // 开始播放
        [self.player play];
    });
}

- (void)setupPlayer:(NSURL*)url {
    
    // Create video player
    BMVideoView *aPlayer;
    aPlayer = [[BMVideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:url];
    aPlayer.shouldShowHideParentNavigationBar = NO;
    aPlayer.tintColor = [UIColor whiteColor];
    aPlayer.titleName = self.video.title;
    [self.view addSubview:aPlayer];
    aPlayer.translatesAutoresizingMaskIntoConstraints = NO;
    
    //成为代理
    aPlayer.delegate = self;
    
    // 是否启动AudioSession
    aPlayer.shouldPlayAudioOnVibrate = NO;
    
    // Add constraints  设置autoLayout
    CGFloat maxDimension = MAX(self.view.frame.size.width, self.view.frame.size.height);
    [aPlayer constrainWithinSuperviewBounds];
    [aPlayer addConstraint:[aPlayer aspectConstraint:(16.0f / 9.0f)]];
    [aPlayer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[aPlayer(>=theWidth@750)]" options:0 metrics:@{@"theWidth":[NSNumber numberWithFloat:maxDimension]} views:NSDictionaryOfVariableBindings(aPlayer)]];
    [aPlayer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[aPlayer(>=theHeight@750)]" options:0 metrics:@{@"theHeight":[NSNumber numberWithFloat:maxDimension]} views:NSDictionaryOfVariableBindings(aPlayer)]];
    [aPlayer centerInSuperview];
    
    self.player = aPlayer;
    
}

#pragma mark - 代理方法
/**
 *  退出控制器
 */
- (void)pageBackButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
