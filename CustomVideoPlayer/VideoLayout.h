//
//  VideoLayout.h
//  CustomVideoPlayer
//
//  Created by wyy on 17/3/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoLayout : NSObject
@property (nonatomic, assign) CGFloat videoPalyerViewHeight;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat nameLabelHeight;
@property (nonatomic, assign) CGFloat timeLabelHeight;
@property (nonatomic, assign) CGFloat photoViewSide;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat verticalMargin;

@property (nonatomic, strong) VideoModel *model;
- (instancetype)initWithSourceData:(VideoModel *)model;
@end
