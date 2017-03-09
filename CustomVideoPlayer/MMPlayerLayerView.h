//
//  MMPlayerLayerView.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMUpdateUIInterface.h"

@interface MMPlayerLayerView : UIView <MMUpdateUIInterface>
@property (nonatomic, weak) id <MMPlayerActionDelegate> delegate;
@property (nonatomic, assign) BOOL isToolHidden;
- (void)setCurrentTime:(NSTimeInterval)time;
@end
