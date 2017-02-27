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
static const NSString *kMMPlayerItemStatusContext;


NSString * const kMMVideoKVOKeyPathPlayerItemStatus = @"status";
/**********************************************************************/
typedef NS_ENUM(NSUInteger, MMVideoVideoUrlType) {
    MMVideoVideoUrlTypeLocation,
    MMVideoVideoUrlTypeLocationRemote,
};


#endif /* MMVideoHeader_h */
