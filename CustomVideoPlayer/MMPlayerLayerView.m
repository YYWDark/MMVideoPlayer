//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
#import "MMVideoHeader.h"
static CGFloat const HorizontalMargin = 20.0;
static CGFloat const VerticalMargin   = 20.0;
static CGFloat const IconSize = 40.0;
static CGFloat const SliderViewHeight = 30.0;
static CGFloat const DistanceBetweenHorizontalViews = 5.0f;
static CGFloat const TimeLableWidth = 40.0f;
static CGFloat const TimeLableHeight = 40.0f;

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
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.closeButton];
    [self addSubview:self.playButton];
    [self addSubview:self.sliderView];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.infoView];
}

- (void)layoutSubviews {
   [super layoutSubviews];
    self.closeButton.frame = CGRectMake(HorizontalMargin, VerticalMargin, IconSize, IconSize);
    self.playButton.frame  = CGRectMake(HorizontalMargin, kScreenHeigth - IconSize - VerticalMargin, IconSize, IconSize);
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + DistanceBetweenHorizontalViews, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.endTimeLabel.frame = CGRectMake(kScreenWidth - TimeLableWidth - HorizontalMargin, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.sliderView.frame = CGRectMake(self.currentTimeLabel.right + DistanceBetweenHorizontalViews, self.playButton.top, self.endTimeLabel.left - self.currentTimeLabel.right - 2*DistanceBetweenHorizontalViews, SliderViewHeight);
}

#pragma mark - action
- (void)respondToCloseAction:(UIButton *)button {
   NSLog(@"");
}

- (void)respondToPlayAction:(UIButton *)button {
    NSLog(@"");

}

- (void)respondToSliderAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
}

//touch up slider
- (void)respondToTouchUpAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
}

//touch down slider
- (void)respondToTouchDownAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
}

#pragma mark - get
- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Icon_Close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(respondToCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"Icon_Play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(respondToPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UISlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UISlider alloc] init];
        [_sliderView setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor =[UIColor redColor];
        _sliderView.maximumTrackTintColor =[UIColor lightGrayColor];
        [_sliderView addTarget:self action:@selector(respondToSliderAction:) forControlEvents:UIControlEventValueChanged];
        [_sliderView addTarget:self action:@selector(respondToTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderView addTarget:self action:@selector(respondToTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _sliderView;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.text =@"00:00";
        _currentTimeLabel.textColor =[UIColor whiteColor];
    }
    return _currentTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textColor =[UIColor grayColor];
        _endTimeLabel.text =@"00:00";
    }
    return _endTimeLabel;
}

- (UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}
@end
