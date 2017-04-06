//
//  NSString+Format.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/6.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "NSString+MMVideoFormat.h"

@implementation NSString (Format)
+ (NSString *)formatSeconds:(NSInteger)value {
    NSInteger seconds = value % 60;
    NSInteger minutes = value / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long) minutes, (long) seconds];
}
@end
