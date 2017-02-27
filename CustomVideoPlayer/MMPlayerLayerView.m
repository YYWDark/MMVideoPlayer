//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
@interface MMPlayerLayerView ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UILabel  *endTimeLabel;
@property (nonatomic, strong) UIView   *infoView;
@end
@implementation MMPlayerLayerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.closeButton];
    [self addSubview:self.playButton];
    [self addSubview:self.sliderView];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.infoView];
}

#pragma mark - get

@end
