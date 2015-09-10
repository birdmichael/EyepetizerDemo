//
//  BMVideoView.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//
//-----------------显示视频的view-----------------------

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#ifdef DEBUG
#    define DLog(...) /* NSLog(__VA_ARGS__) */
#else
#    define DLog(...) /* */
#endif

@class BMVideoView;

@protocol videoViewDelegate <NSObject>
@optional
- (void)playerViewZoomButtonClicked:(BMVideoView*)view;
- (void)playerFinishedPlayback:(BMVideoView*)view;
- (void)pageBackButtonAction;
@end

@interface BMVideoView : UIView

@property (assign, nonatomic) id <videoViewDelegate> delegate;
@property (strong, nonatomic) NSURL *contentURL;
@property (strong, nonatomic) AVPlayer *moviePlayer;


@property (assign, nonatomic) BOOL shouldShowHideParentNavigationBar;
@property (assign, nonatomic) BOOL shouldPlayAudioOnVibrate;

@property (nonatomic, copy) NSString *titleName;

-(instancetype)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL;
-(instancetype)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem;
-(void)play;
-(void)pause;
-(void) setupConstraints;


@end

