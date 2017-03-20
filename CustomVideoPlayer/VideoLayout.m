//
//  VideoLayout.m
//  CustomVideoPlayer
//
//  Created by wyy on 17/3/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoLayout.h"
#import "MMVideoHeader.h"

@implementation VideoLayout
- (instancetype)initWithSourceData:(VideoModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        [self _calculateLayoutInformation:model];
    }
    return self;
}

- (void)_calculateLayoutInformation:(VideoModel *)model {
    self.horizontalMargin = 15.0f;
    self.verticalMargin = 15.0f;
    self.photoViewSide= 30.0;
    self.nameLabelHeight = 15.0f;
    self.timeLabelHeight = 15.0f;
    self.videoPalyerViewHeight = 200.0f;
    
    self.titleLabelHeight = [NSObject heightFromString:model.title withFont:[UIFont systemFontOfSize:14] constraintToWidth:kScreenWidth - 2*self.horizontalMargin];
    
    self.totalHeight += self.verticalMargin;
    self.totalHeight += self.photoViewSide;
    self.totalHeight += self.verticalMargin;
    self.totalHeight += self.videoPalyerViewHeight;
    self.totalHeight += self.verticalMargin;
    self.totalHeight += self.titleLabelHeight;
    self.totalHeight += self.verticalMargin;
}
@end
