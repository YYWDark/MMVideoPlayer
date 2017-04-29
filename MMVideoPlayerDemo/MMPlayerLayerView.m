//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
#import "ThumbnailsView.h"
#import "MMSlider.h"
//#define MMDEBUG 
#define SuperViewHeight CGRectGetHeight(self.frame)
#define SuperViewWidth CGRectGetWidth(self.frame)
#define kOrientation  [UIDevice currentDevice].orientation

static CGFloat const TopBarViewHeight = 44.0f;
static CGFloat const BottomBarViewHeight = 49.0f;
static CGFloat const HorizontalMargin = 10.0;
static CGFloat const IconSize = 40.0;
static CGFloat const SliderViewHeight = 30.0;
static CGFloat const DistanceBetweenHorizontalViews = 5.0f;
static CGFloat const TimeLableWidth = 40.0f;
static CGFloat const TimeLableHeight = 40.0f;
static CGFloat const ThumbnailsViewHeight = 75.0f;
static CGFloat const AnimationDuration = 0.35;


@interface MMPlayerLayerView ()<ThumbnailsViewDelegate, MMSliderDelegate>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, weak) id timeObserver;
@property (nonatomic, weak) id itemEndObserver;

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *showIndexImageUIButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UILabel  *endTimeLabel;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *alterLabel;
@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, strong) UIView *orginSuperView;
@property (nonatomic, assign) CGRect orginFrame;
@property (nonatomic, strong) ThumbnailsView *thumbnailsView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MMSlider *slider;
@property (nonatomic, assign) MMPlayerLayerViewOrientation viewOrientation;
@property (nonatomic, assign) BOOL isToolShown;                             /** 当前工具栏是否是出现的状态*/
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) BOOL isShowthumbnails;                            /** 是否显示缩略图*/
@property (nonatomic, assign) BOOL isAutoToPlay;                                /** 是否自动播放 默认不是*/
@end

@implementation MMPlayerLayerView

- (instancetype)initWithFrame:(CGRect)frame
                    sourceUrl:(NSURL *)url {
    return  [self initWithFrame:frame displayType:MMPlayerLayerViewDisplayWithDefectiveTopBar sourceUrl:url];
}

- (instancetype)initWithFrame:(CGRect)frame
                  displayType:(MMPlayerLayerViewDisplayType)type
                    sourceUrl:(NSURL *)url {
    self = [super initWithFrame:frame];
    if (self) {
        _isAutoToPlay = NO;
        _displayType = type;
//        if (_displayType == MMPlayerLayerViewDisplayNone) {
//            _isAutoToPlay = YES;
//        }
        self.backgroundColor = [UIColor blackColor];
        self.isToolShown = YES;
        self.viewOrientation = MMPlayerLayerViewOrientationLandscapePortrait;
        _videoUrl = url;
        
//        if (_isAutoToPlay == YES) {
//           [self autoToPlay];
//        }

        [self initUI];
        [self _resetTimer];
        [self _addNotification];
    }
    return self;
}

- (void)initUI {
    if (self.displayType == MMPlayerLayerViewDisplayNone) return;
    if (self.displayType != MMPlayerLayerViewDisplayWithOutTopBar) {
        [self addSubview:self.thumbnailsView];
        [self addSubview:self.topBarView];
        [self.topBarView addSubview:self.closeButton];
        [self.topBarView addSubview:self.titleLabel];
        [self.topBarView addSubview:self.showIndexImageUIButton];
        [self.topBarView addSubview:self.switchControl];
    }
    
    [self addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:self.playButton];
    [self.bottomBarView addSubview:self.slider];
    [self.bottomBarView addSubview:self.currentTimeLabel];
    [self.bottomBarView addSubview:self.endTimeLabel];
    [self.bottomBarView addSubview:self.fullScreenButton];
    
    
    [self addSubview: self.indicatorView];
    [self addSubview:self.alterLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalHeight = self.totalHeight;
    CGFloat totalWidth  = self.totalWidth;
    self.playerLayer.frame = self.bounds;
    if (self.displayType == MMPlayerLayerViewDisplayNone) return;
    
        if (self.displayType != MMPlayerLayerViewDisplayWithOutTopBar ) {
            self.thumbnailsView.frame = CGRectMake(0, self.showIndexImageUIButton.selected?(totalHeight - BottomBarViewHeight - ThumbnailsViewHeight): totalHeight, totalWidth,ThumbnailsViewHeight);
            self.topBarView.frame = CGRectMake(0, self.isToolShown?0:-TopBarViewHeight, totalWidth, TopBarViewHeight);
            self.closeButton.frame = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
            self.showIndexImageUIButton.frame = CGRectMake(self.topBarView.width - HorizontalMargin - IconSize, 0, IconSize, IconSize);
            self.switchControl.frame = CGRectMake(self.showIndexImageUIButton.left - HorizontalMargin - IconSize, 5, IconSize, IconSize - 10);
            self.titleLabel.frame  = CGRectMake(self.closeButton.right, 0, self.switchControl.left - self.closeButton.right, TopBarViewHeight);
        }
        self.bottomBarView.frame = CGRectMake(0, self.isToolShown?totalHeight - BottomBarViewHeight : totalHeight , totalWidth, BottomBarViewHeight);
        self.playButton.frame  = CGRectMake(HorizontalMargin, (BottomBarViewHeight - IconSize)/2, IconSize, IconSize);
        self.currentTimeLabel.frame = CGRectMake(self.playButton.right + DistanceBetweenHorizontalViews, self.playButton.top, TimeLableWidth, TimeLableHeight);
        self.fullScreenButton.frame = CGRectMake(totalWidth - HorizontalMargin - IconSize, self.playButton.top, IconSize, IconSize);
        self.endTimeLabel.frame = CGRectMake(self.fullScreenButton.left - DistanceBetweenHorizontalViews - TimeLableWidth, self.playButton.top, TimeLableWidth, TimeLableHeight);
        self.slider.frame = CGRectMake(self.currentTimeLabel.right + DistanceBetweenHorizontalViews, self.playButton.top + 5, self.endTimeLabel.left - self.currentTimeLabel.right - 2*DistanceBetweenHorizontalViews, SliderViewHeight);
        self.indicatorView.size = CGSizeMake(30, 30);
        self.indicatorView.center = self.center;
//        self.alterLabel.size = CGSizeMake(totalWidth, 50);
//        self.alterLabel.center = self.center;
        self.alterLabel.frame  = CGRectMake(0, (totalHeight - 50)/2, totalWidth, 50);
}

//- (void)setCurrentTime:(NSTimeInterval)time {
//    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
//        [self.delegate setVideoPlayerCurrentTime:time];
//    }
//}

- (void)dealloc {
    [self _setnil];
    NSLog(@"MMPlayerLayerView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private method
- (void)updatePlayerState:(MMVideoVideoPlayerState)state {
    _playerState = state;
}

- (void)showErrorMessage:(NSString *)error {
    self.alterLabel.text = error;
    self.alterLabel.hidden = NO;
    [self.indicatorView stopAnimating];
    self.playButton.selected = YES;
    [self respondToPlayAction:self.playButton];
}

- (void)autoToPlay {
    self.isAutoToPlay = YES;
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
    self.asset = [AVAsset assetWithURL:self.videoUrl];
    if ([self.videoUrl.absoluteString rangeOfString:@"http"].location != NSNotFound) {
        self.playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    }else {
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                               automaticallyLoadedAssetKeys:keys];
    }
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.muted = self.isMute;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
//    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    [self.indicatorView startAnimating];
    self.playButton.selected = YES;
    

}

- (void)_addNotification {
    if (self.displayType == MMPlayerLayerViewDisplayNone) return;
    if (self.displayType != MMPlayerLayerViewDisplayWithOutTopBar) {
    //屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //耳机插入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
  
}

- (void)_showToolView {
    [self _resetTimer];
    [UIView  animateWithDuration:.35 animations:^{
        self.topBarView.frame = CGRectMake(0, 0, self.totalWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, self.totalHeight - BottomBarViewHeight , self.totalWidth, BottomBarViewHeight);
    } completion:^(BOOL finished) {
        self.isToolShown = YES;
    }];
}

- (void)_hideToolView {
    [UIView  animateWithDuration:.35 animations:^{
        self.topBarView.frame = CGRectMake(0, - TopBarViewHeight, self.totalWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, self.totalHeight , self.totalWidth, BottomBarViewHeight);
        if (self.showIndexImageUIButton.selected == YES) {
           self.thumbnailsView.frame = CGRectMake(0, self.totalHeight, self.totalWidth,ThumbnailsViewHeight);
           self.showIndexImageUIButton.selected = NO;
        }
    } completion:^(BOOL finished) {
        self.isToolShown = NO;
    }];
}

- (void)_resetTimer {
    if (self.displayType == MMPlayerLayerViewDisplayNone) return;
    if (self.displayType == MMPlayerLayerViewDisplayWithOutTopBar) return;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f firing:^{
        if (self.timer.isValid && self.isToolShown) {
             [self _hideToolView];
        }
    }];
}

- (void)_initPlayerSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //set sliderView minValue and maxValue
        if ([self respondsToSelector:@selector(setSliderMinimumValue:maximumValue:)]) {
            [self setSliderMinimumValue:CMTimeGetSeconds(kCMTimeZero)
                                     maximumValue:CMTimeGetSeconds(self.asset.duration)];
        }
        
        //set videoTitle
        if ([self respondsToSelector:@selector(setTitle:)]) {
            [self setTitle:self.asset.videoTitle];
        }
        
        //callback currentTime per .5 second
        [self _timerObserveOfVedioPlayer];
        
        //callback when the video end
        [self _observeOfTheEndPointOfVedioPlayer];
        
        //play the video
        [self.player play];
        
        
#warning 是否从上次的播放点开始播放
//        [self seekTime:_seekTime];
            [self _getThumbnailsFormVideoFile];
        
    });
}

//每隔0.5秒更新slider
- (void)_timerObserveOfVedioPlayer {
    CMTime interval = CMTimeMakeWithSeconds(kMMVideoPlayerRefreshTime, NSEC_PER_SEC);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak MMPlayerLayerView *weakSelf = self;
    void (^callBack)(CMTime time) = ^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        if (isnan(duration)) return;
            //当前播放到的时间
            [weakSelf setCurrentTime:currentTime duration:duration];
            //当前的缓存
            NSTimeInterval totalBuffer = [weakSelf _availableDurationWithplayerItem:weakSelf.playerItem];
            [weakSelf setCacheTime:totalBuffer];
    };
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:mainQueue
                                                             usingBlock:callBack];
    
}



//获取到当前的总缓存
- (NSTimeInterval)_availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

//观察视频播放结束
- (void)_observeOfTheEndPointOfVedioPlayer {
    __weak MMPlayerLayerView *weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
            [weakSelf callTheActionWiththeEndOfVideo];
        if ([weakSelf.layerViewDelegate respondsToSelector:@selector(playerLayerViewFinishedPlay:)]) {
            [weakSelf.layerViewDelegate playerLayerViewFinishedPlay:weakSelf];
        }
    };
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                             object:self.playerItem
                                                                              queue:[NSOperationQueue mainQueue]
                                                                         usingBlock:callback];
}

- (void)_getThumbnailsFormVideoFile {
    [self.asset getThumbnailsCount:20
                          duration:self.playerItem.duration
                      maxImageSize:CGSizeMake(kMMThumbnailsImageWidth , 0) success:^(NSArray *responseObject) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              NSMutableArray *array = [NSMutableArray arrayWithCapacity:responseObject.count];
                              for (NSDictionary *dic in responseObject) {
                                  ThumbnailsImage *image =  [ThumbnailsImage thumbnailsImage:dic[@"image"] photoTime:[dic[@"actualTime"] floatValue]];
                                  [array addObject:image];
                              }
                              [[NSNotificationCenter defaultCenter] postNotificationName:kMMFinishedGeneratThumbnailsImageNotification object:array];
                          });
                      } failure:^(NSError *error) {
                          NSLog(@"error code == %@", [error localizedDescription]);
                      }];
}

- (void)_setnil {
    [self.timer invalidate];
    self.slider.value = 0.0f;
    self.slider.cacheValue = 0.0f;
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player setRate:0];
    self.asset = nil;
    self.playerItem = nil;
    self.player = nil;
    self.timer = nil;
    [self.playerLayer removeFromSuperlayer];
    self.endTimeLabel.text = @"--:--";
    self.currentTimeLabel.text = @"--:--";
}
#pragma mark - action
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self.indicatorView stopAnimating];
    // Only handle observations for the PlayerItemContext
    if (context != &kMMPlayerItemStatusContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:kMMVideoKVOKeyPathPlayerItemStatus]) {
        
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        // Get the status change from the change dictionary
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        // Switch over the status
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                [self _initPlayerSetting];
                break;
            case AVPlayerItemStatusFailed:
                // Failed. Examine AVPlayerItem.error
                NSLog(@"Examine AVPlayerItem.error remove loadedTimeRanges observe");
                [self showErrorMessage:self.playerItem.error.userInfo[@"NSLocalizedFailureReason"]];
                [self updatePlayerState:MMVideoVideoPlayerFailed];
                break;
            case AVPlayerItemStatusUnknown:
                [self showErrorMessage:@"not ready"];
                [self updatePlayerState:MMVideoVideoPlayerFailed];
                // Not ready
                break;
        }
    }else if ([keyPath isEqualToString:kMMVideoKVOKeyPathPlayerItemPlaybackBufferEmpty]) {
        NSLog(@"kMMVideoKVOKeyPathPlayerItemPlaybackBufferEmpty");
    }else if ([keyPath isEqualToString:kMMVideoKVOKeyPathPlayerItemPlaybackLikelyToKeepUp]){
        NSLog(@"kMMVideoKVOKeyPathPlayerItemPlaybackLikelyToKeepUp");
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.layerViewDelegate respondsToSelector:@selector(videoPlayerViewRespondsToTapPlayerViewAction:)]) {
        [self.layerViewDelegate videoPlayerViewRespondsToTapPlayerViewAction:self];
    }
    if (self.displayType == MMPlayerLayerViewDisplayWithOutTopBar) return;
    if (self.isToolShown == NO) {
        [self _showToolView];
    }else {
        [self _hideToolView];
    }
}

- (void)respondToCloseAction:(UIButton *)button {
    if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapeRight || self.viewOrientation == MMPlayerLayerViewOrientationLandscapeLeft) {
        [self _portraitOrientation];
        return;
    }
    if ([self.layerViewDelegate respondsToSelector:@selector(videoPlayerViewRespondsToBackAction:)]) {
        [self _setnil];
        [self.layerViewDelegate videoPlayerViewRespondsToBackAction:self];
    }
}

- (void)respondToFullScreenAction:(UIButton *)button {
    [self _resetTimer];
    if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapePortrait) {
       [self _leftOrientation];
      
    }else if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapeRight || self.viewOrientation == MMPlayerLayerViewOrientationLandscapeLeft){
        [self _portraitOrientation];
    }
    
}

- (void)respondToShowIndexImageAction:(UIButton *)button {
    [UIView animateWithDuration: AnimationDuration  animations:^{
        if (button.selected == YES) {
            [self _resetTimer];
            self.thumbnailsView.hidden = YES;
            self.thumbnailsView.frame = CGRectMake(0, self.totalHeight, self.totalWidth,ThumbnailsViewHeight);
            
        }else {
            [self.timer invalidate];
            self.thumbnailsView.hidden = NO;
            self.thumbnailsView.frame = CGRectMake(0, self.totalHeight -  ThumbnailsViewHeight - BottomBarViewHeight, self.totalWidth,ThumbnailsViewHeight);
        }
    } completion:^(BOOL finished) {
        button.selected = !button.selected;
    }];

}

- (void)respondToPlayAction:(UIButton *)button {
    [self _resetTimer];
    button.selected = !button.selected;
    if (button.selected == YES
        ) {
            [self play];
    }else {
            [self pause];
    }
}

- (void)respondsToSwitchAction:(UISwitch *)sender {
    [self _resetTimer];
    if ([self.layerViewDelegate respondsToSelector:@selector(playerLayerView:currentStateOfSwitch:)]) {
        [self.layerViewDelegate playerLayerView:self currentStateOfSwitch:sender.isOn];
    }
}
#pragma mark - NSNotification
- (void)orientationDidChangeNotification:(NSNotification *)notification {
    if (kOrientation == UIDeviceOrientationLandscapeLeft) {
        [self _leftOrientation];
    }else if (kOrientation == UIDeviceOrientationLandscapeRight) {
        [self _rightOrientation];
    }else if (kOrientation == UIDeviceOrientationPortrait) {
        [self _portraitOrientation];
    }
}

- (void)appDidEnterBackgroundNotification:(NSNotification *)notification {
    NSLog(@"退到后台");
    self.playButton.selected = YES;
    [self respondToPlayAction:self.playButton];
}

- (void)appDidBecomeActiveNotification:(NSNotification *)notification {
    NSLog(@"进到前台");
    self.playButton.selected = NO;
    [self respondToPlayAction:self.playButton];
}

- (void)handleRouteChangeNotification:(NSNotification *)notification {
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
    AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            self.playButton.selected = YES;
            [self respondToPlayAction:self.playButton];
        }
    }else if (changeReason==AVAudioSessionRouteChangeReasonNewDeviceAvailable ){
        //原设备为耳机则暂停
        self.playButton.selected = NO;
        [self respondToPlayAction:self.playButton];
    }
    
}

#pragma mark - MMPlayerActionDelegate
- (void)play {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    //if video is finished, replay!
    if (CMTimeGetSeconds(self.playerItem.currentTime) == CMTimeGetSeconds(self.playerItem.duration)) {
        [self.playerItem seekToTime:kCMTimeZero];
    }
    if (self.player == nil) {
        [self autoToPlay];
    }else {
        [self.player play];
    }
   
    [self updatePlayerState:MMVideoVideoPlayerPlaying];
    self.playButton.selected = YES;
}

- (void)pause {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    [self.player pause];
    [self updatePlayerState:MMVideoVideoPlayerPause];
    self.playButton.selected = NO;
}

- (void)stop {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    [self.player setRate:0];
    [self callTheActionWiththeEndOfVideo];
    [self updatePlayerState:MMVideoVideoPlayerStop];
    
}

- (void)setVideoPlayerCurrentTime:(NSTimeInterval)time {
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    if ([self respondsToSelector:@selector(setCurrentTime:duration:)]) {
        [self setCurrentTime:time duration:CMTimeGetSeconds(self.playerItem.duration)];
    }
}

- (void)willDragToChangeCurrentTime {
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)didFinishedDragToChangeCurrentTime {
    [self _timerObserveOfVedioPlayer];
    [self.player play];
}

#pragma mark - MMSliderDelegate
- (void)sliderWillRespondsToPanGestureRecognizer:(MMSlider *)slider {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    if ([self respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.timer invalidate];
        [self willDragToChangeCurrentTime];
    }
}

- (void)sliderDidFinishedRespondsToPanGestureRecognizer:(MMSlider *)slider {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    if ([self respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self _resetTimer];
        [self didFinishedDragToChangeCurrentTime];
    }
}

- (void)sliderPanGestureRecognizer:(MMSlider *)slider value:(CGFloat)value {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    if ([self respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self setVideoPlayerCurrentTime:value];
    }
}

- (void)sliderTapAction:(MMSlider *)slider value:(CGFloat)value {
    if (_playerState == MMVideoVideoPlayerFailed) return;
    if ([self respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self _resetTimer];
        [self setVideoPlayerCurrentTime:value];
    }
}

#pragma mark - ThumbnailsViewDelegate
- (void)thumbnailsView:(ThumbnailsView *)view theImageTime:(NSTimeInterval)time {
    if ([self respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.timer invalidate];
        [self willDragToChangeCurrentTime];
    }

    if ([self respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self setVideoPlayerCurrentTime:time];
    }
    
    if ([self respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self _resetTimer];
        [self didFinishedDragToChangeCurrentTime];
    }
}

#pragma mark - MMUpdateUIInterface
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    [self.indicatorView stopAnimating];
    NSUInteger currentSeconds = time;
    self.currentTimeLabel.text = [NSString formatSeconds:currentSeconds];
    self.endTimeLabel.text = [NSString formatSeconds:duration];
    self.slider.value = time;
}

- (void)setCacheTime:(NSTimeInterval)time {
    self.slider.cacheValue = time;
}

- (void)setSliderMinimumValue:(NSTimeInterval)minTime maximumValue:(NSTimeInterval)maxTime {
    self.slider.minimumValue = (NSUInteger)minTime;
    self.slider.maximumValue = (NSUInteger)maxTime;
}

- (void)callTheActionWiththeEndOfVideo {
    NSTimeInterval duration = CMTimeGetSeconds(self.playerItem.duration);
    //当前播放到的时间
    [self setCurrentTime:0.0 duration:duration];
    self.playButton.selected = NO;
}

- (void)showActivityIndicatorView {
    if (self.playButton.selected == YES) {
     [self.indicatorView startAnimating];
    }
}

- (void)_rightOrientation {
    if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapeRight) return;
    self.viewOrientation = MMPlayerLayerViewOrientationLandscapeRight;
    if ([self.layerViewDelegate respondsToSelector:@selector(playerLayerView:currentViewOrientation:)]) {
        [self.layerViewDelegate playerLayerView:self currentViewOrientation:MMPlayerLayerViewOrientationLandscapeRight];
    }
    self.fullScreenButton.selected = YES;
    self.thumbnailsView.hidden = YES;
    if (self.orginSuperView == nil) {
        self.orginSuperView = self.superview;
        self.orginFrame = self.frame;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.frame = [[UIApplication sharedApplication].keyWindow bounds];
    }completion:^(BOOL finished) {
        self.thumbnailsView.hidden = NO;
        self.switchControl.hidden = NO;
    }];
}

- (void)_leftOrientation {
    if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapeLeft) return;
    self.viewOrientation = MMPlayerLayerViewOrientationLandscapeLeft;
    if ([self.layerViewDelegate respondsToSelector:@selector(playerLayerView:currentViewOrientation:)]) {
        [self.layerViewDelegate playerLayerView:self currentViewOrientation:MMPlayerLayerViewOrientationLandscapeLeft];
    }
    self.fullScreenButton.selected = YES;
    self.thumbnailsView.hidden = YES;
   
    if (self.orginSuperView == nil) {
        self.orginSuperView = self.superview;
        self.orginFrame = self.frame;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
    
     [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = [[UIApplication sharedApplication].keyWindow bounds];
    }completion:^(BOOL finished) {
        self.thumbnailsView.hidden = NO;
         self.switchControl.hidden = NO;
    }];
}

- (void)_portraitOrientation {
    if (self.viewOrientation == MMPlayerLayerViewOrientationLandscapePortrait) return;
    self.viewOrientation = MMPlayerLayerViewOrientationLandscapePortrait;
    if ([self.layerViewDelegate respondsToSelector:@selector(playerLayerView:currentViewOrientation:)]) {
        [self.layerViewDelegate playerLayerView:self currentViewOrientation:MMPlayerLayerViewOrientationLandscapePortrait];
    }
    self.fullScreenButton.selected = NO;
    self.thumbnailsView.hidden = YES;
    self.switchControl.hidden = YES;
    
    [self.orginSuperView addSubview:self];
    self.orginSuperView = nil;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = self.orginFrame;
        
    }completion:^(BOOL finished) {
        self.thumbnailsView.hidden = NO;
    }];
}

#pragma mark - setter
- (void)setIsMute:(BOOL)isMute {
    if (_isMute != isMute) {
        _isMute = isMute;
        _player.muted = _isMute;
    }
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if (_videoUrl != videoUrl) {
        _videoUrl = videoUrl;
        [self _setnil];
        [self autoToPlay];
        [self _resetTimer];
    }
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {return;}
    if (_playerItem ) {
        [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
        [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemPlaybackBufferEmpty];
        [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemPlaybackLikelyToKeepUp];
    }
     _playerItem = playerItem;
    if (playerItem) {
        [playerItem addObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&kMMPlayerItemStatusContext];
        [playerItem addObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemPlaybackBufferEmpty options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&kMMPlayerItemStatusContext];
        [playerItem addObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&kMMPlayerItemStatusContext];
    }
}

- (void)setIsAutoToPlay:(BOOL)isAutoToPlay {
    if (_isAutoToPlay != isAutoToPlay) {
        _isAutoToPlay = isAutoToPlay;
//        _playButton.selected = _isAutoToPlay;
//        [self respondToPlayAction:_playButton];
        
    }
}
#pragma mark - getter
- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Icon_Close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(respondToCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)showIndexImageUIButton {
    if (_showIndexImageUIButton == nil) {
        _showIndexImageUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showIndexImageUIButton.selected = NO;
        [_showIndexImageUIButton setImage:[UIImage imageNamed:@"Icon_showImage"] forState:UIControlStateNormal];
        [_showIndexImageUIButton addTarget:self action:@selector(respondToShowIndexImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showIndexImageUIButton;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playButton.selected = _isAutoToPlay;
        [_playButton setImage:[UIImage imageNamed:@"Icon_Play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Icon_Pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(respondToPlayAction:) forControlEvents:UIControlEventTouchUpInside];
#ifdef MMDEBUG
        _playButton.backgroundColor = [UIColor greenColor];
#endif
    }
    return _playButton;
}

- (UIButton *)fullScreenButton {
    if (_fullScreenButton == nil) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Icon_zoomIn"] forState:UIControlStateSelected];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Icon_zoomOut"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(respondToFullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
#ifdef MMDEBUG
        _fullScreenButton.backgroundColor = [UIColor greenColor];
#endif
    }
    return _fullScreenButton;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.text = @"--:--";
        _currentTimeLabel.textColor =[UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
#ifdef MMDEBUG
        _currentTimeLabel.backgroundColor = [UIColor redColor];
#endif
    }
    return _currentTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.text = @"--:--";
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
#ifdef MMDEBUG
        _endTimeLabel.backgroundColor = [UIColor redColor];
#endif
    }
    return _endTimeLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)alterLabel {
    if (_alterLabel == nil) {
        _alterLabel = [[UILabel alloc] init];
        _alterLabel.font = [UIFont systemFontOfSize:15];
        _alterLabel.backgroundColor = [UIColor blackColor];
        _alterLabel.textColor = [UIColor whiteColor];
        _alterLabel.hidden = YES;
        _alterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alterLabel;
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] init];
        _topBarView.backgroundColor = [UIColor lightGrayColor];
#ifdef MMDEBUG
        _topBarView.backgroundColor = [UIColor redColor];
#endif
    }
    return _topBarView;
}

- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] init];
        _bottomBarView.backgroundColor = [UIColor clearColor];
#ifdef MMDEBUG
        _bottomBarView.backgroundColor = [UIColor yellowColor];
#endif
    }
    return _bottomBarView;
}

- (ThumbnailsView *)thumbnailsView {
    if (_thumbnailsView == nil) {
        _thumbnailsView = [[ThumbnailsView alloc] init];
        _thumbnailsView.hidden = YES;
        _thumbnailsView.delegate = self;
    }
    return _thumbnailsView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        if (_isAutoToPlay == YES) {
            [_indicatorView startAnimating];}
    }
    return _indicatorView;
}

- (MMSlider *)slider {
    if (_slider == nil) {
        _slider = [[MMSlider alloc] initWithFrame:CGRectZero];
        _slider.delegate = self;
#ifdef MMDEBUG
        _slider.backgroundColor = [UIColor purpleColor];
#endif
    }
    return _slider;
}

- (UISwitch *)switchControl {
    if (_switchControl == nil) {
        _switchControl = [[UISwitch alloc] init];
        _switchControl.hidden = YES;
       [_switchControl addTarget:self action:@selector(respondsToSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

- (CGFloat)totalWidth {
    return (self.viewOrientation == MMPlayerLayerViewOrientationLandscapePortrait)?SuperViewWidth:SuperViewHeight;
}

- (CGFloat)totalHeight {
    return (self.viewOrientation == MMPlayerLayerViewOrientationLandscapePortrait)?SuperViewHeight:SuperViewWidth;
}

@end
