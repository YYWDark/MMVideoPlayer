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
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "AVAsset+Extension.h"
#import "NSString+Format.h"
/**********************************************************************/
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
static const NSString *kMMPlayerItemStatusContext;
static NSString * const kMMVideoKVOKeyPathPlayerItemStatus = @"status";
static CGFloat  const kMMVideoPlayerRefreshTime = 0.5f;
/**********************************************************************/
typedef NS_ENUM(NSUInteger, MMVideoVideoUrlType) {
    MMVideoVideoUrlTypeLocation,
    MMVideoVideoUrlTypeLocationRemote,
};
#endif /* MMVideoHeader_h */
