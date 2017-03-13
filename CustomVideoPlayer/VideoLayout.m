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
    self.videoPalyerViewHeight = 200.0f;
    self.titleLabelHeight = [NSObject heightFromString:model.title withFont:[UIFont systemFontOfSize:16] constraintToWidth:2000];
    self.totalHeight += self.videoPalyerViewHeight;
    self.totalHeight += self.titleLabelHeight;
}
@end
