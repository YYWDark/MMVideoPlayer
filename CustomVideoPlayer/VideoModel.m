//
//  VideoModel.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isPlaying = NO;
    }
    return self;
}

+ (instancetype)videomodelWithCover:(NSString *)cover
                           videoUrl:(NSString *)mp4_url
                         videoTitle:(NSString *)title {
    VideoModel *model = [[VideoModel alloc] init];
    model.cover = cover;
//    model.mp4_url = [[NSBundle mainBundle] URLForResource:@"b" withExtension:@"mp4"];
    model.mp4_url = [NSURL URLWithString:mp4_url];
    model.title = title;
    return model;
}

- (instancetype)initWithSourceDictionary:(NSDictionary *)sourceDic {
    self = [super init];
    if (self) {
        [self analysisSourceDictionary:sourceDic];
    }
    return self;
}



- (void)analysisSourceDictionary:(NSDictionary *)sourceDic {
    self.cover = sourceDic[@"cover"];
    self.title = sourceDic[@"title"];
    self.ptime = sourceDic[@"ptime"];
    self.topicName = sourceDic[@"topicName"];
    self.mp4_url = [NSURL URLWithString:sourceDic[@"mp4_url"]];
    
}
@end
