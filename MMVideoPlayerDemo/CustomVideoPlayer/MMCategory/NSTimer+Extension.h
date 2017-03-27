//
//  NSTimer+Extension.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimerCountingBlock)(void);
@interface NSTimer (Extension)
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                                     repeating:(BOOL)repeat
                                        firing:(TimerCountingBlock)fireBlock;

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                              firing:(TimerCountingBlock)fireBlock;
@end
