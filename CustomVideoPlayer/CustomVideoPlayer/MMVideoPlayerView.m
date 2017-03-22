//
//  MMVideoPlayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMVideoPlayerView.h"
#import "MMPlayerLayerView.h"

@interface MMVideoPlayerView ()
@property (nonatomic, strong) MMPlayerLayerView *playerLayerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation MMVideoPlayerView
//+ (Class)layerClass {
//    return [AVPlayerLayer class];
//}

- (instancetype)initWithPlayer:(AVPlayer *)player
                 topViewStatus:(MMTopViewStatus)status {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//        UIViewAutoresizingFlexibleWidth;
//        [(AVPlayerLayer *) [self layer] setPlayer:player];
        self.playerLayer =   [AVPlayerLayer playerLayerWithPlayer:player];
//        self.playerLayerView = [[MMPlayerLayerView alloc] initWithFrame:self.bounds topViewStatus:status];
//        self.playerLayerView.topViewStatus = status;
        [self.layer addSublayer:self.playerLayer];
        [self addSubview:self.playerLayerView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.frame;
    self.playerLayerView.frame = self.bounds;
}

- (id <MMUpdateUIInterface>)interface {
    return self.playerLayerView;
}

@end
