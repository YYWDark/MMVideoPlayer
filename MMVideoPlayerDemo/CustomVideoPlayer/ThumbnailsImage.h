//
//  ThumbnailsImage.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/8.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>
@interface ThumbnailsImage : NSObject
@property (nonatomic, assign, readonly) NSTimeInterval photoTime;
@property (nonatomic, strong, readonly) UIImage *image;

+ (instancetype)thumbnailsImage:(UIImage *)image
                      photoTime:(NSTimeInterval)time;
@end
