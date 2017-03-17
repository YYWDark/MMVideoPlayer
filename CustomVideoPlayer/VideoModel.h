//
//  VideoModel.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *cover;       //覆盖图
@property (nonatomic, copy) NSString *title;       //内容
@property (nonatomic, copy) NSString *ptime;       //时间
@property (nonatomic, copy) NSString *topicName;   //名字

@property (nonatomic, strong) NSURL *mp4_url;      //视频url
@property (nonatomic, assign) BOOL isPlaying;

+ (instancetype)videomodelWithCover:(NSString *)cover
                           videoUrl:(NSString *)mp4_url
                         videoTitle:(NSString *)title;

- (instancetype)initWithSourceDictionary:(NSDictionary *)sourceDic;
@end
