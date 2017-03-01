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
@property (strong, nonatomic) MMPlayerLayerView *playerLayerView;
@end

@implementation MMVideoPlayerView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer *) [self layer] setPlayer:player];
        self.playerLayerView = [[MMPlayerLayerView alloc] init];
        [self addSubview:self.playerLayerView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayerView.frame = self.bounds;
}

- (id <MMUpdateUIInterface>)interface {
    return self.playerLayerView;
}
@end
