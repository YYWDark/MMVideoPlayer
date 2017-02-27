//
//  MMVideoPlayer.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMVideoPlayer.h"
#import "MMVideoPlayerView.h"
@interface MMVideoPlayer ()
@property (nonatomic, strong) MMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;

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
    self.asset = [AVAsset assetWithURL:self.videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
}
#pragma mark - public methods
#pragma mark - private methods
- (void)_addObserver {
    [self.playerItem addObserver:self
                 forKeyPath:kMMVideoKVOKeyPathPlayerItemStatus
                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:&kMMPlayerItemStatusContext];
}

- (void)_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
}

#pragma mark - action
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // Only handle observations for the PlayerItemContext
    if (context != &kMMPlayerItemStatusContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        // Get the status change from the change dictionary
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        // Switch over the status
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                // Ready to Play
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

- (void)didReceiveAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification
{
//    if (notification.object == self.player.currentItem) {
//        if (self.shouldReplayWhenFinish) {
//            [self replay];
//        } else {
//            [self.player seekToTime:kCMTimeZero];
//            [self showPlayButton];
//        }
//        
//        if ([self.operationDelegate respondsToSelector:@selector(videoViewDidFinishPlaying:)]) {
//            [self.operationDelegate videoViewDidFinishPlaying:self];
//        }
//    }
}

- (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification
{
//    if (notification.object == self.player.currentItem) {
//        if (self.stalledStrategy == CTVideoViewStalledStrategyPlay) {
//            [self play];
//        }
//        if (self.stalledStrategy == CTVideoViewStalledStrategyDelegateCallback) {
//            if ([self.operationDelegate respondsToSelector:@selector(videoViewStalledWhilePlaying:)]) {
//                [self.operationDelegate videoViewStalledWhilePlaying:self];
//            }
//        }
//    }
}

#pragma mark - get
- (UIView *)view {
    return self.videoPlayerView;
}
@end
