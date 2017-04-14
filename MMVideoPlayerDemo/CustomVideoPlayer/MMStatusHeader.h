//
//  MMStatusHeader.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/13.
//  Copyright © 2017年 wyy. All rights reserved.
//

#ifndef MMStatusHeader_h
#define MMStatusHeader_h
//MMTopViewDisplayStatus
typedef NS_ENUM(NSUInteger, MMTopViewStatus) {   //是否显示topBar
    MMTopViewHiddenStatus,   //default
    MMTopViewDisplayStatus,
};

typedef NS_ENUM(NSUInteger, MMPlayerLayerViewDisplayType) {   //是否显示topBar
    MMPlayerLayerViewDisplayNone,
    MMPlayerLayerViewDisplayWithOutTopBar,            //类型微博没有tapBar
    MMPlayerLayerViewDisplayWithDefectiveTopBar,      //类似爱奇艺小屏幕,topBar没有完整的工具 default
    MMPlayerLayerViewDisplayFullScreen,               //满屏
};

typedef NS_ENUM(NSUInteger, MMVideoVideoUrlType) {
    MMVideoVideoUrlTypeLocation,                                
    MMVideoVideoUrlTypeLocationRemote,
};

typedef NS_ENUM(NSUInteger, MMVideoVideoPlayerState) {
    MMVideoVideoPlayerFailed,
    MMVideoVideoPlayerPlaying,
    MMVideoVideoPlayerPause,
    MMVideoVideoPlayerBuffering,
    MMVideoVideoPlayerStop,
};

typedef NS_ENUM(NSUInteger, MMPlayerLayerViewOrientation) {
    MMPlayerLayerViewOrientationLandscapeLeft,
    MMPlayerLayerViewOrientationLandscapeRight,
    MMPlayerLayerViewOrientationLandscapePortrait, //default
};
#endif /* MMStatusHeader_h */
