//
//  MMVideoPlayer.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMVideoPlayer.h"
#import "MMVideoPlayerView.h"
#import "MMUpdateUIInterface.h"
#import "ThumbnailsImage.h"

@interface MMVideoPlayer () <MMPlayerActionDelegate>
@property (nonatomic, strong) MMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, weak) id<MMUpdateUIInterface> interface;
@property (nonatomic, weak) id timeObserver;
@property (nonatomic, weak) id itemEndObserver;
@property (nonatomic, assign) BOOL isObserverRemoved;
@property (nonatomic, assign) NSTimeInterval seekTime;
@end
@implementation MMVideoPlayer
#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.topViewStatus = MMTopViewHiddenStatus;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)videoUrl
              topViewStatus:(MMTopViewStatus)status{
    self = [self init];
    if (self) {
         _videoUrl = videoUrl;
        _topViewStatus = status;
        _seekTime = 0.0;
        [self initVideoPlayerAndRelevantSetting];
        [self _addNoyification];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)videoUrl
              topViewStatus:(MMTopViewStatus)status
                 playerTime:(NSTimeInterval)seekTime {
    self = [self initWithURL:videoUrl topViewStatus:status];
    if (self) {
        _seekTime = seekTime;
    }
    return self;
}

- (void)initVideoPlayerAndRelevantSetting {
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
    
    [self _addObserver];
   
    //add Observer to observe the movie status
     self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self _initSubView];
}

- (void)dealloc {
    [self removeNotification];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    if (self.topViewStatus== MMTopViewDisplayStatus) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    }
}
#pragma mark - public method
- (NSTimeInterval)currentTimeOfPlayerItem {
    return CMTimeGetSeconds(self.playerItem.currentTime);
}

- (void)seekTime:(NSTimeInterval)seekTime {
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)pausePlaying {
    [self pause];
}

- (void)startPlaying {
    [self play];
}

- (void)stopPlaying {
    if (self.isObserverRemoved == NO) {
        [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
        self.isObserverRemoved = YES;
    }
//    [self.videoPlayerView removeFromSuperview];
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    self.playerItem = nil;
    self.asset = nil;
    self.player = nil;
    self.videoPlayerView = nil;
}
#pragma mark - private methods
- (void)_initSubView {
    self.videoPlayerView = [[MMVideoPlayerView alloc] initWithPlayer:self.player topViewStatus:self.topViewStatus];
    self.interface = self.videoPlayerView.interface;
    self.interface.delegate = self;
}

- (void)_addObserver {
    [self.playerItem addObserver:self
                 forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus
                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:&kMMPlayerItemStatusContext];
    self.isObserverRemoved = NO;
}

- (void)_addNoyification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    if (self.topViewStatus== MMTopViewDisplayStatus) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
   
}

- (void)_initPlayerSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //set sliderView minValue and maxValue
        if ([self.interface respondsToSelector:@selector(setSliderMinimumValue:maximumValue:)]) {
            [self.interface setSliderMinimumValue:CMTimeGetSeconds(kCMTimeZero)
                                     maximumValue:CMTimeGetSeconds(self.asset.duration)];
        }
        
        //set videoTitle
        if ([self.interface respondsToSelector:@selector(setTitle:)]) {
          [self.interface setTitle:self.asset.videoTitle];
        }
        
        //callback currentTime per .5 second
        [self _timerObserveOfVedioPlayer];
        
        //callback when the video end
        [self _observeOfTheEndPointOfVedioPlayer];
        
        //play the video
        [self.player play];
//        [self.player seekToTime:CMTimeMakeWithSeconds(_seekTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self seekTime:_seekTime];
        if(self.topViewStatus == MMTopViewDisplayStatus){
           [self _getThumbnailsFormVideoFile]; 
        }
        
    });
}

- (void)_timerObserveOfVedioPlayer {
    CMTime interval = CMTimeMakeWithSeconds(kMMVideoPlayerRefreshTime, NSEC_PER_SEC);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak MMVideoPlayer *weakSelf = self;
    void (^callBack)(CMTime time) = ^(CMTime time) {
         NSTimeInterval currentTime = CMTimeGetSeconds(time);
         NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        if ([weakSelf.interface respondsToSelector:@selector(setCurrentTime:duration:)]) {
            [weakSelf.interface setCurrentTime:currentTime duration:duration];
        }
        if ([weakSelf.interface respondsToSelector:@selector(setCacheTime:)]) {
            NSTimeInterval totalBuffer = [self availableDurationWithplayerItem:self.playerItem];
//            NSLog(@"totalBuffer == %lf",totalBuffer);
            [weakSelf.interface setCacheTime:totalBuffer];
        }
    };
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:mainQueue
                                                             usingBlock:callBack];
    
}

- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)_observeOfTheEndPointOfVedioPlayer {
    __weak MMVideoPlayer *weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        if ([weakSelf.interface respondsToSelector:@selector(callTheActionWiththeEndOfVideo)]) {
           [weakSelf.interface callTheActionWiththeEndOfVideo];
        }
        
        if ([self.delegate respondsToSelector:@selector(videoPlayerFinished:)]) {
            [self.delegate videoPlayerFinished:self];
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

#pragma mark - notification
- (void)playerItemNewAccessLogEntryNotification:(NSNotification *)notification {
    [self.interface showActivityIndicatorView];
}

- (void)orientationDidChangeNotification:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (orientation == UIDeviceOrientationLandscapeLeft) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//        NSLog(@"UIDeviceOrientationLandscapeLeft");
//    }else if (orientation == UIDeviceOrientationLandscapeRight) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
//        NSLog(@"UIDeviceOrientationLandscapeRight");
//    }else if (orientation == UIDeviceOrientationPortrait) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
    
//    [self.interface changeTheViewOrientation:orientation];
    
//    if ([self.delegate respondsToSelector:@selector(videoPlayerViewWillChangeTheOrientation:)]) {
//        [self.delegate videoPlayerViewWillChangeTheOrientation:self];
//    }
}

#pragma mark - action
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
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
                 [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
                self.isObserverRemoved = YES;
                break;
            case AVPlayerItemStatusUnknown:
                [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
                self.isObserverRemoved = YES;
                // Not ready
                break;
        }
    }
}

#pragma mark - MMPlayerActionDelegate
- (void)play {
    //if video is finished, replay!
    if (CMTimeGetSeconds(self.playerItem.currentTime) == CMTimeGetSeconds(self.playerItem.duration)) {
        [self.playerItem seekToTime:kCMTimeZero];
    }
   [self.player play];
}

- (void)pause {
    [self.player pause]; 
}

- (void)stop {
    [self.player setRate:0];
    [self.interface callTheActionWiththeEndOfVideo];
}

- (void)setVideoPlayerCurrentTime:(NSTimeInterval)time {
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    if ([self.interface respondsToSelector:@selector(setCurrentTime:duration:)]) {
        [self.interface setCurrentTime:time duration:CMTimeGetSeconds(self.playerItem.duration)];
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

- (void)didTapCloseButton {
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewWillDismiss:)]) {
        [self.delegate videoPlayerViewWillDismiss:self];
    }
}
#pragma mark - set 
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self stopPlaying];
    [self initVideoPlayerAndRelevantSetting];
}
#pragma mark - get
- (UIView *)view {
    return self.videoPlayerView;
}
@end
