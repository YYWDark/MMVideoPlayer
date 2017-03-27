//
//  AVAsset+Extension.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/2.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@interface AVAsset (Extension)
@property (nonatomic, strong, readonly) NSString *videoTitle;

- (void)getThumbnailsCount:(NSUInteger)count
                  duration:(CMTime)duration
              maxImageSize:(CGSize)size
                   success:(void (^)(NSArray *responseObject))success
                   failure:(void (^)(NSError *error))failure;
@end
