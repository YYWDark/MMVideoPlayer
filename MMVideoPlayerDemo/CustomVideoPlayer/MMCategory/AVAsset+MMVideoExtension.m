//
//  AVAsset+Extension.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/2.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "AVAsset+MMVideoExtension.h"
#import <UIKit/UIKit.h>
@implementation AVAsset (Extension)
- (NSString *)videoTitle {
    AVKeyValueStatus status = [self statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items = [AVMetadataItem metadataItemsFromArray:self.commonMetadata
                                                        withKey:AVMetadataCommonKeyTitle
                                                       keySpace:AVMetadataKeySpaceCommon];
        
        if (items.count > 0) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
        
    }
    return nil;
}

- (void)getThumbnailsCount:(NSUInteger)count
                  duration:(CMTime)duration
              maxImageSize:(CGSize)size
                   success:(void (^)(NSArray *responseObject))success
                   failure:(void (^)(NSError *error))failure {
    AVAssetImageGenerator * imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self];
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.maximumSize = size;
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
