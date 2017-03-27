//
//  NSTimer+Extension.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                                     repeating:(BOOL)repeat
                                        firing:(TimerCountingBlock)fireBlock {
    id block = [fireBlock copy];
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeTimerBlock:) userInfo:block repeats:repeat];
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                              firing:(TimerCountingBlock)fireBlock {
    return [self scheduledTimerWithTimeInterval:interval
                                      repeating:NO
                                         firing:fireBlock];
}

+ (void)executeTimerBlock:(NSTimer *)timer {
    TimerCountingBlock block = [timer userInfo];
    block();
}
@end
