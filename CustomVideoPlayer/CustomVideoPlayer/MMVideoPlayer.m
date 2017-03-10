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
        [self initVideoPlayerAndRelevantSetting];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)videoUrl {
    self.videoUrl = videoUrl;
    self = [self init];
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
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    [self _addObserver];
    //add Observer to observe the movie status
     self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self _initSubView];
    
}

- (void)dealloc {
  [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
}

#pragma mark - public methods
#pragma mark - private methods
- (void)_initSubView {
    self.videoPlayerView = [[MMVideoPlayerView alloc] initWithPlayer:self.player];
    self.interface = self.videoPlayerView.interface;
    self.interface.delegate = self;
}

- (void)_addObserver {
    [self.playerItem addObserver:self
                 forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus
                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:&kMMPlayerItemStatusContext];
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
        }
    };
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:mainQueue
                                                             usingBlock:callBack];
    
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
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // Only handle observations for the PlayerItemContext
    if (context != &kMMPlayerItemStatusContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [self.playerItem removeObserver:self forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus];
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
                break;
            case AVPlayerItemStatusUnknown:
                // Not ready
                break;
        }
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
#pragma mark - get
- (UIView *)view {
    return self.videoPlayerView;
}
@end
