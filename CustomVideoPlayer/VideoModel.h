//
//  VideoModel.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *mp4_url;
@property (nonatomic, copy) NSString *title;

+ (instancetype)videomodelWithCover:(NSString *)cover
                           videoUrl:(NSString *)mp4_url
                         videoTitle:(NSString *)title;
@end
