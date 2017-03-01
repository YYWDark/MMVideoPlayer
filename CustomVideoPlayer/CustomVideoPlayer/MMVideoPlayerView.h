//
//  MMVideoPlayerView.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MMUpdateUIInterface.h"

@interface MMVideoPlayerView : UIView
@property (nonatomic, weak) id<MMUpdateUIInterface> interface;
- (instancetype)initWithPlayer:(AVPlayer *)player;

@end
