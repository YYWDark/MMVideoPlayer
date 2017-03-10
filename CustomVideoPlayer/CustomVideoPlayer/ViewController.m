//
//  ViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "MMVideoPlayer.h"

#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
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
//     NSURL *remoteUrl  =  [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1703/10/fzWKV7960/SD/fzWKV7960-mobile.mp4"];
//     NSURL *locationUrl  = [[NSBundle mainBundle] URLForResource:@"b" withExtension:@"mp4"];
//     self.player = [[MMVideoPlayer alloc] initWithURL:remoteUrl];
//     self.player.view.frame = self.view.frame;
//    [self.view addSubview:self.player.view];
    
    
    NSURL *url = [NSURL URLWithString:videoListUrl];
    //1request请求，向服务器请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //2建立网络连接，将请求（异步）发送给服务器
    //多线程的目的就是将耗时操作放在后台，所有网络请求都是耗时的
    //几乎所有的网络请求都应该是异步的
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@",httpURLResponse.allHeaderFields[@"Etag"]);
        NSLog(@"%@",response);
//        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",json);
        
    }];
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


- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Notification
- (void)didReceiveAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
    NSLog(@"播放结束了");
}

- (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
    
}

@end



 


 


