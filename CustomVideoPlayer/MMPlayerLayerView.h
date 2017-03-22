//
//  MMPlayerLayerView.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMUpdateUIInterface.h"
#import "MMVideoHeader.h"
#import <AVFoundation/AVFoundation.h>
@interface MMPlayerLayerView : UIView <MMUpdateUIInterface>

@property (nonatomic, weak) id <MMPlayerActionDelegate> delegate;
@property (nonatomic, assign) BOOL isToolHidden;
@property (nonatomic, assign) MMTopViewStatus topViewStatus;
//- (instancetype)initWithFrame:(CGRect)frame
//                topViewStatus:(MMTopViewStatus)status;

- (instancetype)initWithFrame:(CGRect)frame
                topViewStatus:(MMTopViewStatus)status
                       player:(AVPlayer *)player;


- (void)setCurrentTime:(NSTimeInterval)time;

@end
