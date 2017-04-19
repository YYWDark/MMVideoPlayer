//
//  MMPlayerLayerView.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMVideoHeader.h"
#import <AVFoundation/AVFoundation.h>


@protocol MMPlayerLayerViewDelegate;
@interface MMPlayerLayerView : UIView
@property (nonatomic, assign) MMTopViewStatus topViewStatus;
@property (nonatomic, assign, readonly) MMVideoVideoPlayerState playerState;    /** 播放状态*/
@property (nonatomic, assign) MMPlayerLayerViewDisplayType displayType; /** 展现的样式*/
@property (nonatomic, assign) id <MMPlayerLayerViewDelegate> layerViewDelegate;
@property (nonatomic, assign) BOOL isToolHidden;
@property (nonatomic, assign) BOOL isMute;                                      /** 是否静音模式*/
@property (nonatomic, strong) NSURL *videoUrl;

- (instancetype)initWithFrame:(CGRect)frame
                    sourceUrl:(NSURL *)url;

- (instancetype)initWithFrame:(CGRect)frame
                  displayType:(MMPlayerLayerViewDisplayType)type
                    sourceUrl:(NSURL *)url;

//- (void)setCurrentTime:(NSTimeInterval)time;
- (void)play;
- (void)pause;
- (void)stop;
- (void)autoToPlay;
@end


@protocol MMPlayerLayerViewDelegate <NSObject>
@optional
/** 播放结束*/
- (void)playerLayerViewFinishedPlay:(MMPlayerLayerView *)playerLayerView;
/** 点击了回退按钮  MMPlayerLayerViewDisplayWithOutTopBar 没有导航栏*/
- (void)videoPlayerViewRespondsToBackAction:(MMPlayerLayerView *)playerLayerView;
/** 点击了播放视图*/
- (void)videoPlayerViewRespondsToTapPlayerViewAction:(MMPlayerLayerView *)playerLayerView;
/** 当前的播放状态*/
- (void)playerLayerView:(MMPlayerLayerView *)playerLayerView currentPlayState:(MMVideoVideoPlayerState)State;
/** 当前视图的方向*/
- (void)playerLayerView:(MMPlayerLayerView *)playerLayerView currentViewOrientation:(MMPlayerLayerViewOrientation)viewOrientation;
/** switch当前的状态*/
- (void)playerLayerView:(MMPlayerLayerView *)playerLayerView currentStateOfSwitch:(BOOL)isOn;
@end
