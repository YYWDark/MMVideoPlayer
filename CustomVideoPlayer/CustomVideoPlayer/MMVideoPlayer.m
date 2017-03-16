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
    self = [super init];
    if (self) {
         _videoUrl = videoUrl;
        _topViewStatus = status;
        [self initVideoPlayerAndRelevantSetting];
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
    [self _addNoyification];
    //add Observer to observe the movie status
     self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self _initSubView];
}



- (void)stopPlay {
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
    self.asset = nil;
    self.player = nil;
    
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
    
    [self.playerItem addObserver:self
                      forKeyPath:kMMVideoKVOKeyPathPlayerItemLoadedTimeRanges
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:&kMMPlayerItemStatusContext];
}

- (void)_addNoyification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    
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
        
        [self _getThumbnailsFormVideoFile];
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
            
          
            NSTimeInterval totalBuffer = [self availableDurationWithplayerItem:self.playerItem];
            NSLog(@"totalBuffer == %lf",totalBuffer);
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
         NSLog(@"the end of video");
        if ([weakSelf.interface respondsToSelector:@selector(callTheActionWiththeEndOfVideo)]) {
           [weakSelf.interface callTheActionWiththeEndOfVideo];
        }
    };
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                             object:self.playerItem
                                                                              queue:[NSOperationQueue mainQueue]
                                                                         usingBlock:callback];
}

#pragma mark - action

- (void)AVPlayerItemNewAccessLogEntryNotification:(NSNotification *)notification {
    NSLog(@"卡顿");
    
    [self.interface showActivityIndicatorView];
}

- (void)AVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
    NSLog(@"暂停");
    
    //    [self.interface showActivityIndicatorView];
}
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
        [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
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
                [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemLoadedTimeRanges];
                break;
            case AVPlayerItemStatusUnknown:
                // Not ready
                break;
        }
    }else if ([keyPath isEqualToString:kMMVideoKVOKeyPathPlayerItemLoadedTimeRanges]) {
      [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemLoadedTimeRanges];
        NSTimeInterval totalBuffer = [self availableDurationWithplayerItem:self.playerItem];
        NSLog(@"totalBuffer == %lf",totalBuffer);
    }
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

#pragma mark - set 
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self stopPlay];
    [self initVideoPlayerAndRelevantSetting];
}
#pragma mark - get
- (UIView *)view {
    return self.videoPlayerView;
}
@end
