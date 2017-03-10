//
//  VideoModel.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+ (instancetype)videomodelWithCover:(NSString *)cover
                           videoUrl:(NSString *)mp4_url
                         videoTitle:(NSString *)title {
    VideoModel *model = [[VideoModel alloc] init];
    model.cover = cover;
    model.mp4_url = mp4_url;
    model.title = title;
    return model;
}
@end
