//
//  ThumbnailsImage.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/8.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ThumbnailsImage.h"

@implementation ThumbnailsImage
+ (instancetype)thumbnailsImage:(UIImage *)image
                      photoTime:(NSTimeInterval)time {
    ThumbnailsImage *img = [[self alloc] initWiththumbnailsImage:image photoTime:time];
    return img;
}

- (instancetype)initWiththumbnailsImage:(UIImage *)image
                              photoTime:(NSTimeInterval)time {
    self = [super init];
    if (self) {
        _image = image;
        _photoTime = time;
    }
    return self;
}
@end
