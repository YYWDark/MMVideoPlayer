//
//  ViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "MMVideoPlayer.h"
NSString * const kCTVideoViewKVOKeyPathPlayerItemStatus = @"player.currentItem.status";
NSString * const kCTVideoViewKVOKeyPathPlayerItemDuration = @"player.currentItem.duration";
NSString * const kCTVideoViewKVOKeyPathLayerReadyForDisplay = @"layer.readyForDisplay";
@interface ViewController ()
//@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) MMVideoPlayer *player;
@end

@implementation ViewController
 static const NSString *PlayerItemStatusContext;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.player = [[MMVideoPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"中国合伙人" withExtension:@"mp4"]];
    self.player.view.frame = self.view.frame;
    [self.view addSubview:self.player.view];
    
//    NSArray *keys = @[
//                      @"tracks",
//                      @"duration",
//                      @"commonMetadata",
//                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
//                      ];
//
//    NSURL *assrtUrl = [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"mp4"];
//    AVAsset *asset = [AVAsset assetWithURL:assrtUrl];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
    //add kvo
//    [playerItem addObserver:self
//                 forKeyPath:@"status"
//                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                    context:&PlayerItemStatusContext];
    //notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    playerLayer.frame=CGRectMake(0, 100, self.view.frame.size.width, 300);
//    [self.view.layer addSublayer:playerLayer];
//    [self.player play];
    
}

//kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // Only handle observations for the PlayerItemContext
    if (context != &PlayerItemStatusContext) {
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



#pragma mark - Notification
- (void)didReceiveAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
    NSLog(@"播放结束了");
}

- (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
    
}

@end



 


 


