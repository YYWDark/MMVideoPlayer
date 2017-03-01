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
@interface MMVideoPlayer () <MMPlayerActionDelegate>
@property (nonatomic, strong) MMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, weak) id<MMUpdateUIInterface> interface;
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
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    //add Observer to observe the movie status
    [self _addObserver];
    [self _initSubView];
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

}

- (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification
{

}
#pragma mark - MMPlayerActionDelegate
- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause]; 
}

- (void)stop {
    
}
#pragma mark - get
- (UIView *)view {
    return self.videoPlayerView;
}
@end
