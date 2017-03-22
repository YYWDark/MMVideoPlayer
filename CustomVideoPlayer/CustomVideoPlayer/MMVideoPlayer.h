//
//  MMVideoPlayer.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMVideoHeader.h"
@protocol MMVideoPlayerDelegate;

@interface MMVideoPlayer : NSObject
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) MMTopViewStatus topViewStatus;
@property (nonatomic, weak) id<MMVideoPlayerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)videoUrl
              topViewStatus:(MMTopViewStatus)status;
- (instancetype)initWithURL:(NSURL *)videoUrl
              topViewStatus:(MMTopViewStatus)status
                 playerTime:(NSTimeInterval)seekTime;

- (void)stopPlaying;
- (void)pausePlaying;
- (void)startPlaying;
- (NSTimeInterval)currentTimeOfPlayerItem;
- (void)seekTime:(NSTimeInterval)seekTime;
- (void)removeNotification;
@end

@protocol MMVideoPlayerDelegate <NSObject>
@optional
- (void)videoPlayerFinished:(MMVideoPlayer *)videoPlayer;
- (void)videoPlayerViewWillDismiss:(MMVideoPlayer *)videoPlayer;

@end
