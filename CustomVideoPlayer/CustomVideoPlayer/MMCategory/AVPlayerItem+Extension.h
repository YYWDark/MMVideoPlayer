//
//  AVPlayerItem+Extension.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerItem (Extension)
- (void)getThumbnailsCount:(NSUInteger)count
              maxImageSize:(CGSize)size
                   success:(void (^)(NSArray *responseObject))success
                   failure:(void (^)(NSError *error))failure;
@end
