//
//  MMUpdateUIInterface.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPlayerActionDelegate.h"

@protocol MMUpdateUIInterface <NSObject>
@property (nonatomic, weak) id<MMPlayerActionDelegate> delegate;
- (void)setTitle:(NSString *)title;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)setSliderMinimumValue:(NSTimeInterval)minTime maximumValue:(NSTimeInterval)maxTime;
- (void)callTheActionWiththeEndOfVideo;
@end
