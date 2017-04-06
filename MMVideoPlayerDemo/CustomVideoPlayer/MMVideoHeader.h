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
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "AVAsset+Extension.h"
#import "NSString+Format.h"
#import "UIImage+Thumabnails.h"
#import "NSTimer+Extension.h"
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
/**********************************************************************/

#endif /* MMVideoHeader_h */
