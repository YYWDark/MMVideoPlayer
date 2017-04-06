//
//  MMVideoHeader.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#ifndef MMVideoHeader_h
#define MMVideoHeader_h
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "MMStatusHeader.h"
#import "UIView+MMVideoExtension.h"
#import "UIColor+MMVideoExtension.h"
#import "AVAsset+MMVideoExtension.h"
#import "NSString+MMVideoFormat.h"
#import "UIImage+MMVideoThumabnails.h"
#import "NSTimer+MMVideoExtension.h"
#import "NSObject+Calculate.h"
/**********************************************************************/
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
static const NSString *kMMPlayerItemStatusContext;
static CGFloat const kMMThumbnailsImageWidth   = 120.0f;
static CGFloat const kMMVideoPlayerRefreshTime = 0.5f;
static NSString * const kMMVideoKVOKeyPathPlayerItemStatus = @"status";
static NSString * const kMMVideoKVOKeyPathPlayerItemLoadedTimeRanges = @"loadedTimeRanges";
static NSString * const kMMFinishedGeneratThumbnailsImageNotification = @"kMMFinishedGeneratThumbnailsImageNotification";

static NSString * const kErrorMessage = @"播放出现问题";
/**********************************************************************/

#endif /* MMVideoHeader_h */
