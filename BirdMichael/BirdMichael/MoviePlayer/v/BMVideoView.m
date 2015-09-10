//
//  BMVideoView.m
//  kaiyan
//
//  Created by 李 阳 on 15/9/7.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#import "BMVideoView.h"
#import "UIView+ConstraintHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Header.h"
#import "PlayerSlider.h"
#import "UIView+XYWH.h"

#define ToolsHudH 50.0
#define PlayHudH 30.0


@interface BMVideoView ()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) id playbackObserver;

@property (assign, nonatomic) BOOL isViewShowing;
@property (assign, nonatomic) BOOL isPlaying;




/**
 *  整页蒙版
 */
@property (strong, nonatomic) UIView *overHudView;

/**
 *  工具条蒙版
 */
@property (strong, nonatomic) UIView *toolsHudView;
/** 页面回退Btn */
@property (strong, nonatomic) UIButton *pageBackButton;
/** 视频名label */
@property (strong, nonatomic) UILabel *titleLabel;

/**
 *  play/Pause 按钮
 */
@property (strong, nonatomic) UIButton *playPauseButton;

/**
 *  播放器蒙版
 */
@property (strong, nonatomic) UIView *playerHudView;
/** 播放条滑块 */
@property (strong, nonatomic) UISlider *progressBar;
/** 已播放时间 */
@property (strong, nonatomic) UILabel *playBackTime;
/** 视频总时长 */
@property (strong, nonatomic) UILabel *playBackTotalTime;
@end

@implementation BMVideoView

#pragma mark - AVPlayerLayer setup

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player {
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

- (void)setVideoFillMode:(NSString *)fillMode {
    AVPlayerLayer *playLayer = (AVPlayerLayer*)[self layer];
    playLayer.videoGravity = fillMode;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.shouldShowHideParentNavigationBar) {
        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
        }
    }
}

#pragma mark - Initializers/deallocator

- (instancetype)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)aPlayerItem {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupPlayerWithPlayerItem:aPlayerItem forFrame:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlayerWithURL:contentURL forFrame:frame];
    }
    return self;
}



#pragma mark - 播放器初始化方法

- (void)setupPlayerWithURL:(NSURL*)theURL forFrame:(CGRect)aFrame {
    
    if (self.contentURL) {
        self.contentURL = nil;
    }
    
    AVPlayerItem *aPlayerItem = [AVPlayerItem playerItemWithURL:theURL];
    self.contentURL = theURL;
    [self setupPlayerWithPlayerItem:aPlayerItem forFrame:aFrame];
}

- (void)setupPlayerWithPlayerItem:(AVPlayerItem*)aPlayerItem forFrame:(CGRect)aFrame{
    
    // defensively remote observers, notifications
    [self unregisterObservers];
    
    if (self.moviePlayer) {
        self.moviePlayer = nil;
    }
    if (self.playerLayer) {
        self.playerLayer = nil;
    }
    if (self.playerItem) {
        self.playerItem = nil;
    }
    
    _playerItem = aPlayerItem;
    self.moviePlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    [self.playerLayer setFrame:aFrame];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self setPlayer:self.moviePlayer];
    [self setVideoFillMode:AVLayerVideoGravityResizeAspect];
    self.contentURL = nil;
    
    [self registerObservers];
    [self initializePlayerAtFrame:aFrame];
    
}

-(void) setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    
}


#pragma mark - 播放器 UI定制

-(void)initializePlayerAtFrame:(CGRect)frame {
    
    self.backgroundColor = [UIColor blackColor];
    self.isViewShowing =  NO;
    [self.layer setMasksToBounds:YES];
    
    
    // 整夜蒙版
    self.overHudView       = [[UIView alloc] init];
    [self.overHudView setBackgroundColor:coverViewColor];
    [self addSubview:self.overHudView];
    
    // ========== 顶部工具栏HUB
    self.toolsHudView        = [[UIView alloc] init];
    [self addSubview:self.toolsHudView];

    // 页面返回按钮
    
    self.pageBackButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pageBackButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [self.pageBackButton addTarget:self action:@selector(pageBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsHudView addSubview:self.pageBackButton];
    
    //  视频名称标题 label
    self.titleLabel               = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor     = [UIColor whiteColor];
    self.titleLabel.font          = Font_ChinaBold(15);
    [self.titleLabel sizeToFit];
    [self.toolsHudView addSubview:self.titleLabel];
    
    
    // ========== 开始暂停按钮
    self.playPauseButton                           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playPauseButton.showsTouchWhenHighlighted = YES;//  选中光晕
    self.playPauseButton.layer.opacity             = 0;
    self.playPauseButton.selected                  = NO;
    self.playPauseButton.tintColor                 = [UIColor clearColor];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateHighlighted];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateSelected];
    [self.playPauseButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playPauseButton];
    
    // ========== 播放底部
    self.playerHudView        = [[UIView alloc] init];
    [self addSubview:self.playerHudView];
    

    //  Progress bar = scrubber  时间进度条
    self.progressBar            = [[UISlider alloc] init];
    [self.progressBar setThumbImage:[UIImage imageNamed:@"player_handle"]
                           forState:UIControlStateNormal];
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressBar addTarget:self action:@selector(progressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerHudView addSubview:self.progressBar];

    // Calculate appropriately sized font
    UIFont *timeFont            = Font_ChinaBold(12);

    //  当前时长 label
    self.playBackTime               = [[UILabel alloc] init];
    self.playBackTime.text          = [self getStringFromCMTime:self.moviePlayer.currentTime];
    self.playBackTime.textAlignment = NSTextAlignmentLeft;
    self.playBackTime.textColor     = [UIColor whiteColor];
    self.playBackTime.font          = timeFont;
    [self.playBackTime sizeToFit];
    [self.playerHudView addSubview:self.playBackTime];

    //  总时长 label
    self.playBackTotalTime               = [[UILabel alloc] init];
    self.playBackTotalTime.text          = [self getStringFromCMTime:self.moviePlayer.currentItem.asset.duration];
    self.playBackTotalTime.textAlignment = NSTextAlignmentRight;
    self.playBackTotalTime.textColor     = [UIColor whiteColor];
    self.playBackTotalTime.font          = timeFont;
         [self.playBackTotalTime sizeToFit];
    [self.playerHudView addSubview:self.playBackTotalTime];

    
    CMTime interval = CMTimeMake(33, 1000);
    __weak __typeof(self) weakself = self;
    _playbackObserver = [self.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (weakself.moviePlayer.currentItem.asset.duration, weakself.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            double normalizedTime = (double) weakself.moviePlayer.currentTime.value / (double) endTime.value;
            weakself.progressBar.value = normalizedTime;
        }
        weakself.playBackTime.text = [weakself getStringFromCMTime:weakself.moviePlayer.currentTime];
    }];
    
    [self setupConstraints];
    [self showHUD:NO];
    [self showLoader:NO];
    

}

#pragma mark - AutoLayout setup


-(void) setupConstraints {
    
    // 禁用Autoresizing
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerHudView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.playBackTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.playBackTotalTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.overHudView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.toolsHudView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // over HUD
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[overHudView(>=300@1000)]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"overHudView": self.overHudView }]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[overHudView]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"overHudView": self.overHudView }]];
    
    // Tools HUD
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolsHudView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolsHudView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.superview
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:ToolsHudH]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[toolsHudView(>=300@1000)]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"toolsHudView": self.toolsHudView }]];
    
    // 页面返回,标题,其他功能
    NSDictionary *toolsHudMetrics = @{@"maxWidth":[NSNumber numberWithFloat:MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]};
    NSDictionary *toolsHudViews = @{@"pageBackButton": self.pageBackButton,
                               @"titleLabel": self.titleLabel};
    [self.toolsHudView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-10-[pageBackButton]-10-[titleLabel]"
                                        options:0
                                        metrics:toolsHudMetrics
                                        views:toolsHudViews]];
    
    [self.pageBackButton centerVerticallyInSuperview];
    [self.titleLabel centerVerticallyInSuperview];

    
    DLog(@"%s: Auto Layout constraints = %@ %@", __func__, self.constraints, self.playerHudView.constraints);
    
    // Player HUD
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playerHudView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playerHudView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.superview
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:PlayHudH]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[HudView(>=300@1000)]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"HudView": self.playerHudView }]];
    
    // Play button
    [self.playPauseButton centerInSuperview];
    
    // currentTime, progress bar, totalTime
    NSDictionary *hudMetrics = @{@"maxWidth":[NSNumber numberWithFloat:MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]};
    NSDictionary *hudViews = @{@"progressBar": self.progressBar,
                               @"playBackTime": self.playBackTime,
                               @"playBackTotal": self.playBackTotalTime};
    [self.playerHudView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-20-[playBackTime]-[progressBar(<=maxWidth)]-[playBackTotal]-20-|"
                                          options:0
                                          metrics:hudMetrics
                                          views:hudViews]];
    
    [self.playBackTotalTime centerVerticallyInSuperview];
    [self.playBackTime centerVerticallyInSuperview];
    [self.progressBar centerVerticallyInSuperview];
    
        DLog(@"%s: Auto Layout constraints = %@ %@", __func__, self.constraints, self.playerHudView.constraints);
    
}


#pragma mark  页面点击时间
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [(UITouch*)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.playerLayer.frame, point)) {
        [self showHUD:!self.isViewShowing];
    }
}

-(void) showHUD:(BOOL)show {
    
    __weak __typeof(self) weakself = self;
    if (show) {
        self.overHudView.hidden = NO; // 隐藏蒙版
        
        CGRect frame = self.playerHudView.frame;
        frame.origin.y = self.bounds.size.height - self.playerHudView.frame.size.height;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudView.frame = frame;
            weakself.toolsHudView.y = weakself.y;
            
            weakself.playPauseButton.layer.opacity = 1;
            self.isViewShowing = show;
        }];
    } else {
        self.overHudView.hidden = YES;
        CGRect frame = self.playerHudView.frame;
        frame.origin.y = self.bounds.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.toolsHudView.y = weakself.y - weakself.toolsHudView.height;
            
            weakself.playerHudView.frame = frame;
            weakself.playPauseButton.layer.opacity = 0;
            self.isViewShowing = show;
        }];
        
    }
    
    // show/hide parentViewController's navigationBar alongside HUD
    
    if (self.shouldShowHideParentNavigationBar) {
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [[self superviewNavigationController] setNavigationBarHidden:_isViewShowing animated:YES];
        }
    }
}

-(void)playerFinishedPlaying {
    
    [self.moviePlayer pause];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.playPauseButton setSelected:NO];
    self.isPlaying = NO;
    if ([self.delegate respondsToSelector:@selector(playerFinishedPlayback:)]) {
        [self.delegate playerFinishedPlayback:self];
    }
}

- (UINavigationController*)superviewNavigationController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController*)nextResponder;
        }
        
    }
    
    return nil;
}

#pragma mark - 时间遍历方法

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}
#pragma mark - pageBack 按钮动作

-(void)pageBackButtonAction:(UIButton*)sender {
    
    NSLog(@"页面返回");
    if ([self.delegate respondsToSelector:@selector(pageBackButtonAction)]) {
        [self.delegate pageBackButtonAction];
    }
}


#pragma mark - Play/pause 按钮动作

-(void)playButtonAction:(UIButton*)sender {
    
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

#pragma mark - ProgressBar change handling

-(void)progressBarChanged:(UISlider*)sender {
    
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value * (double)self.moviePlayer.currentItem.asset.duration.value/(double)self.moviePlayer.currentItem.asset.duration.timescale, self.moviePlayer.currentTime.timescale);
    [self.moviePlayer seekToTime:seekTime];
}

-(void)progressBarChangeEnded:(UISlider*)sender {
    
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}

-(void)play {
    
    [self.moviePlayer play];
    self.isPlaying = YES;
    [self.playPauseButton setSelected:YES];
    [self showHUD:!self.isViewShowing]; // 播放自动隐藏VIew
}

-(void)pause {
    
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [self.playPauseButton setSelected:NO];
}

- (void)endPlayer {
    
    [self.moviePlayer pause];
    self.moviePlayer.rate = 0.0;
    self.isPlaying = NO;
    [self.playerLayer removeFromSuperlayer];
    self.moviePlayer = nil;
}

#pragma mark - Audio/vibrate override

- (void)setShouldPlayAudioOnVibrate:(BOOL)shouldPlayAudioOnVibrate {
    _shouldPlayAudioOnVibrate = shouldPlayAudioOnVibrate;
    
    NSError *error = nil;
    
    if (shouldPlayAudioOnVibrate) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        
    }
    
    // error handling
    if (error) {
        DLog(@"%s: error while setting audio vibrate overwrite - %@", __func__, [error localizedDescription]);
    }
}

#pragma mark - ActivityIndicator show/hide

- (void)showLoader:(BOOL)wasInterrupted {
    
    if (!self.activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndicator startAnimating];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.activityIndicator];
        
        if (!wasInterrupted) {
            self.playPauseButton.alpha = 0.0;
        }
        [self.activityIndicator centerInSuperview];
        
    }
}

- (void)removeLoader {
    [UIView animateWithDuration:0.5 animations:^{
        self.playPauseButton.alpha = 1.0;
        self.activityIndicator.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }];
    
}



#pragma mark - Observer handling for player, playerItem

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]])
    {
        AVPlayerItem *item = (AVPlayerItem *)object;
        
        //playerItem status value changed?
        if ([keyPath isEqualToString:@"status"])
        {
            // if yes, determine it...
            switch(item.status)
            {
                case AVPlayerItemStatusFailed:
                    DLog(@"%s: player item status failed", __func__);
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    DLog(@"%s: player item status is ready to play", __func__);
                    [self removeLoader];
                    if (self.isPlaying) {
                        [self play];  // 监听到状态为准备播放就立马播放
                    };
                    break;
                case AVPlayerItemStatusUnknown:
                    DLog(@"%s: player item status is unknown", __func__);
                    break;
            }
        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
        {
            if (item.playbackBufferEmpty)
            {
                if (!item.isPlaybackLikelyToKeepUp && !item.isPlaybackBufferFull) {
                    
                    // perform secondary check that player has actually stopped
                    if (self.moviePlayer.rate == 0.0) {
                        [self showLoader:YES];
                    }
                }
                DLog(@"%s: player item playback buffer is empty", __func__);
            }
        }
    }
    if ([object isKindOfClass:[AVPlayer class]]) {
        
        // secondary check on activityIndicator, remove shown && framerate > 0.0
        if ([keyPath isEqual:@"rate"]) {
            CGFloat frameRate = [(AVPlayer*)object rate];
            if (frameRate > 0.0 && self.activityIndicator) {
                [self removeLoader];
            }
            DLog(@"%s: player rate is %f", __func__, [(AVPlayer*)object rate]);
        }
    }
}

#pragma mark - KVO of Player notifications, setup/teardown

- (void)registerObservers {
    
    // monitor playhead position if reached end
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    // monitor playerItem status (ready to play, failed; buffer)
    for (NSString *keyPath in [self observablePlayerItemKeypaths]) {
        [self.playerItem addObserver:self forKeyPath:keyPath options:0 context:NULL];
    }
    
    // monitor player frame rate
    [self.player addObserver:self forKeyPath:@"rate" options:0 context:NULL];
    
}

- (void)unregisterObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (NSString *keyPath in [self observablePlayerItemKeypaths]) {
        [self.playerItem removeObserver:self forKeyPath:keyPath];
    }
    
    [self.player removeObserver:self forKeyPath:@"rate"];
}

- (NSArray *)observablePlayerItemKeypaths {
    return [NSArray arrayWithObjects:@"playbackBufferEmpty", @"status", nil];
}


-(void)setTitleName:(NSString *)titleName
{
    if (titleName){
    _titleName = titleName;
    self.titleLabel.text = titleName;
//    [self setNeedsDisplay];
    }
}

#pragma mark - 销毁.

-(void)dealloc {
    
    [self.moviePlayer removeTimeObserver:self.playbackObserver];
    [self unregisterObservers];
    
    self.playerItem = nil;
    self.playerLayer= nil;
    self.activityIndicator= nil;
    self.playbackObserver= nil;
    
}
@end
