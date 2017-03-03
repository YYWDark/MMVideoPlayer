//
//  AVAsset+Extension.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/2.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "AVAsset+Extension.h"

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
@end
