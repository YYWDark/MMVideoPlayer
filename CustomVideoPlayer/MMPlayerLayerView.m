//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
#import "MMVideoHeader.h"
static CGFloat const TopBarViewHeight = 44.0f;
static CGFloat const BottomBarViewHeight = 49.0f;

static CGFloat const HorizontalMargin = 20.0;
static CGFloat const VerticalMargin   = 20.0;
static CGFloat const IconSize = 40.0;
static CGFloat const SliderViewHeight = 30.0;
static CGFloat const DistanceBetweenHorizontalViews = 5.0f;
static CGFloat const TimeLableWidth = 40.0f;
static CGFloat const TimeLableHeight = 40.0f;

@interface MMPlayerLayerView ()
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *showIndexImageUIButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UILabel  *endTimeLabel;
@property (nonatomic, strong) UILabel  *titleLabel;
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
    [self addSubview:self.topBarView];
    [self.topBarView addSubview:self.closeButton];
    [self.topBarView addSubview:self.titleLabel];
    [self.topBarView addSubview:self.showIndexImageUIButton];
    
    [self addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:self.playButton];
    [self.bottomBarView addSubview:self.sliderView];
    [self.bottomBarView addSubview:self.currentTimeLabel];
    [self.bottomBarView addSubview:self.endTimeLabel];
}

- (void)layoutSubviews {
   [super layoutSubviews];
    self.topBarView.frame  = CGRectMake(0, 0, kScreenWidth, TopBarViewHeight);
    self.closeButton.frame = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
    
    self.bottomBarView.frame = CGRectMake(0, kScreenHeigth - BottomBarViewHeight , kScreenWidth, BottomBarViewHeight);
    self.playButton.frame  = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + DistanceBetweenHorizontalViews, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.endTimeLabel.frame = CGRectMake(kScreenWidth - TimeLableWidth - HorizontalMargin, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.sliderView.frame = CGRectMake(self.currentTimeLabel.right + DistanceBetweenHorizontalViews, self.playButton.top + 5, self.endTimeLabel.left - self.currentTimeLabel.right - 2*DistanceBetweenHorizontalViews, SliderViewHeight);
}

#pragma mark - action
- (void)respondToCloseAction:(UIButton *)button {
   NSLog(@"");
}

- (void)respondToShowIndexImageAction:(UIButton *)button {
    
}

- (void)respondToPlayAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == YES) {//播放
        if ([self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate play];
        }
    }else {//暂停
        if ([self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
    }
}

- (void)respondToSliderValueChangedAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:slider.value];
    }
}

//touch up slider
- (void)respondToTouchUpAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
    if ([self.delegate respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self.delegate didFinishedDragToChangeCurrentTime];
    }
}

//touch down slider
- (void)respondToTouchDownAction:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.delegate willDragToChangeCurrentTime];
    }
}

#pragma mark - MMUpdateUIInterface
- (void)setTitle:(NSString *)title {
    
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    NSUInteger currentSeconds = time;
    self.currentTimeLabel.text = [NSString formatSeconds:currentSeconds];
    self.endTimeLabel.text = [NSString formatSeconds:duration];
    self.sliderView.value = time;
}

- (void)setSliderMinimumValue:(NSTimeInterval)minTime maximumValue:(NSTimeInterval)maxTime {
    self.sliderView.minimumValue = (NSUInteger)minTime;
    self.sliderView.maximumValue = (NSUInteger)maxTime;
}

- (void)callTheActionWiththeEndOfVideo {
    self.sliderView.value = 0.0;
    self.playButton.selected = NO;
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

- (UIButton *)showIndexImageUIButton {
    if (_showIndexImageUIButton == nil) {
        _showIndexImageUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showIndexImageUIButton setImage:[UIImage imageNamed:@"Icon_showImage"] forState:UIControlStateNormal];
        [_showIndexImageUIButton addTarget:self action:@selector(respondToShowIndexImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showIndexImageUIButton;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.selected = YES;
        [_playButton setImage:[UIImage imageNamed:@"Icon_Play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Icon_Pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(respondToPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UISlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumTrackTintColor = [UIColor redColor];
        _sliderView.maximumTrackTintColor = [UIColor blackColor];
        [_sliderView setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        [_sliderView addTarget:self action:@selector(respondToSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
        [_sliderView addTarget:self action:@selector(respondToTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderView addTarget:self action:@selector(respondToTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _sliderView;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.text = @"-- : --";
        _currentTimeLabel.textColor =[UIColor blackColor];
    }
    return _currentTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textColor = [UIColor blackColor];
        _endTimeLabel.text = @"-- : --";
    }
    return _endTimeLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blueColor];
    }
    return _titleLabel;
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] init];
        _topBarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topBarView;
}

- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] init];
        _bottomBarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomBarView;
}
@end
