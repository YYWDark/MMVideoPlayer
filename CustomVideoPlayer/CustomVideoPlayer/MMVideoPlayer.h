//
//  MMVideoPlayer.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMVideoHeader.h"

@interface MMVideoPlayer : NSObject
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong) NSURL *videoUrl;

- (instancetype)initWithURL:(NSURL *)videoUrl;
@end
