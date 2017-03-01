//
//  MMPlayerActionDelegate.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/1.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMPlayerActionDelegate <NSObject>
- (void)play;
- (void)pause;
- (void)stop;
@end
