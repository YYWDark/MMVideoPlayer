//
//  AVPlayerItem+Extension.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "AVPlayerItem+Extension.h"
#import <UIKit/UIKit.h>

@implementation AVPlayerItem (Extension)
- (void)getThumbnailsCount:(NSUInteger)count
              maxImageSize:(CGSize)size
                   success:(void (^)(NSArray *responseObject))success
                   failure:(void (^)(NSError *error))failure {
    AVAssetImageGenerator * imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self];
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.maximumSize = size;
    CMTime duration = self.duration;
    NSMutableArray *times = [NSMutableArray array];
    CMTimeValue increment = duration.value / count;
    CMTimeValue currentValue = 0;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime,
                                                       CGImageRef imageRef,
                                                       CMTime actualTime,
                                                       AVAssetImageGeneratorResult result,
                                                       NSError *error) {
        
        if (result == AVAssetImageGeneratorSucceeded) {
            NSDictionary *dic = @{@"actualTime":@(CMTimeGetSeconds(actualTime)),
                                  @"image":[UIImage imageWithCGImage:imageRef]};
            [images addObject:dic];
        } else {
            if (failure) {
                failure(error);
            }
        }
        
        if (--imageCount == 0) {
            if (success) {
                success(images.copy);
            }
        }
    };
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                         completionHandler:handler];
}
@end
