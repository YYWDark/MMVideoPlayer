//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
#import "ThumbnailsView.h"
#import "MMSlider.h"

#define SuperViewHeight CGRectGetHeight(self.superview.frame)
#define SuperViewWidth CGRectGetWidth(self.superview.frame)
static CGFloat const TopBarViewHeight = 44.0f;
static CGFloat const BottomBarViewHeight = 49.0f;
static CGFloat const HorizontalMargin = 20.0;
static CGFloat const IconSize = 40.0;
static CGFloat const SliderViewHeight = 30.0;
static CGFloat const DistanceBetweenHorizontalViews = 5.0f;
static CGFloat const TimeLableWidth = 40.0f;
static CGFloat const TimeLableHeight = 40.0f;
static CGFloat const ThumbnailsViewHeight = 75.0f;
static CGFloat const AnimationDuration = 0.35;

@interface MMPlayerLayerView ()<ThumbnailsViewDelegate, MMSliderDelegate>
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *showIndexImageUIButton;
@property (nonatomic, strong) UIButton *playButton;
//@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UILabel  *endTimeLabel;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) ThumbnailsView *thumbnailsView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isToolShown;
@property (nonatomic, strong) MMSlider *slider;
@end

@implementation MMPlayerLayerView
- (instancetype)initWithFrame:(CGRect)frame
                topViewStatus:(MMTopViewStatus)status {
    self = [super initWithFrame:frame];
    if (self) {
        self.topViewStatus = status;
        self.isToolShown = YES;
        [self initUI];
        [self _resetTimer];
    }
    return self;
}

- (void)initUI {
    if (self.topViewStatus == MMTopViewDisplayStatus) {
        [self addSubview:self.thumbnailsView];
        [self addSubview:self.topBarView];
        [self.topBarView addSubview:self.closeButton];
        [self.topBarView addSubview:self.titleLabel];
        [self.topBarView addSubview:self.showIndexImageUIButton];
    }
   
    [self addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:self.playButton];
    [self.bottomBarView addSubview:self.slider];
    [self.bottomBarView addSubview:self.currentTimeLabel];
    [self.bottomBarView addSubview:self.endTimeLabel];
    
    [self addSubview: self.indicatorView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.topViewStatus == MMTopViewDisplayStatus) {
        self.thumbnailsView.frame = CGRectMake(0, self.showIndexImageUIButton.selected?(SuperViewHeight - BottomBarViewHeight - ThumbnailsViewHeight): SuperViewHeight, SuperViewWidth,ThumbnailsViewHeight);
        self.topBarView.frame = CGRectMake(0, self.isToolShown?0:-TopBarViewHeight, SuperViewWidth, TopBarViewHeight);
        self.closeButton.frame = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
        self.showIndexImageUIButton.frame = CGRectMake(SuperViewWidth - HorizontalMargin - IconSize, 0, IconSize, IconSize);
        self.titleLabel.frame  = CGRectMake(self.closeButton.right, 0, self.showIndexImageUIButton.left - self.closeButton.right, TopBarViewHeight);
    }
    
    self.bottomBarView.frame = CGRectMake(0, self.isToolShown?SuperViewHeight - BottomBarViewHeight : SuperViewHeight , SuperViewWidth, BottomBarViewHeight);
    self.playButton.frame  = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + DistanceBetweenHorizontalViews, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.endTimeLabel.frame = CGRectMake(SuperViewWidth - TimeLableWidth - HorizontalMargin, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.slider.frame = CGRectMake(self.currentTimeLabel.right + DistanceBetweenHorizontalViews, self.playButton.top + 5, self.endTimeLabel.left - self.currentTimeLabel.right - 2*DistanceBetweenHorizontalViews, SliderViewHeight);
    self.indicatorView.size = CGSizeMake(30, 30);
    self.indicatorView.center = self.center;
}

- (void)setCurrentTime:(NSTimeInterval)time {
    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:time];
    }
}

#pragma mark - private method
- (void)_showToolView {
    [self _resetTimer];
    [UIView  animateWithDuration:.35 animations:^{
        self.topBarView.frame = CGRectMake(0, 0, SuperViewWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, SuperViewHeight - BottomBarViewHeight , SuperViewWidth, BottomBarViewHeight);
    } completion:^(BOOL finished) {
        self.isToolShown = YES;
    }];
}

- (void)_hideToolView {
    [UIView  animateWithDuration:.25 animations:^{
        self.topBarView.frame = CGRectMake(0, - TopBarViewHeight, SuperViewWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, SuperViewHeight , SuperViewWidth, BottomBarViewHeight);
        if (self.showIndexImageUIButton.selected == YES) {
           self.thumbnailsView.frame = CGRectMake(0, SuperViewHeight, SuperViewWidth,ThumbnailsViewHeight);
            self.showIndexImageUIButton.selected = NO;
        }
    } completion:^(BOOL finished) {
        self.isToolShown = NO;
    }];
    
}

- (void)_resetTimer {
    if (self.topViewStatus == MMTopViewHiddenStatus) return;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f firing:^{
        if (self.timer.isValid && self.isToolShown) {
             [self _hideToolView];
        }
    }];
}

#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.topViewStatus == MMTopViewHiddenStatus) return;
    if (self.isToolShown == NO) {
        [self _showToolView];
    }else {
        [self _hideToolView];
    }
}

- (void)respondToCloseAction:(UIButton *)button {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)respondToShowIndexImageAction:(UIButton *)button {
    [UIView animateWithDuration: AnimationDuration  animations:^{
        if (button.selected == YES) {
            [self _resetTimer];
            self.thumbnailsView.frame = CGRectMake(0, SuperViewHeight, SuperViewWidth,ThumbnailsViewHeight);
        }else {
            [self.timer invalidate];
            self.thumbnailsView.frame = CGRectMake(0, SuperViewHeight -  ThumbnailsViewHeight - BottomBarViewHeight, SuperViewWidth,ThumbnailsViewHeight);
        }
    } completion:^(BOOL finished) {
        button.selected = !button.selected;
    }];

}

- (void)respondToPlayAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == YES) {
        if ([self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate play];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
    }
}

- (void)respondToSliderValueChangedAction:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:slider.value];
    }
}

//touch up slider
- (void)respondToTouchUpAction:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self _resetTimer];
        [self.delegate didFinishedDragToChangeCurrentTime];
    }
}

//touch down slider
- (void)respondToTouchDownAction:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.timer invalidate];
        [self.delegate willDragToChangeCurrentTime];
    }
}
#pragma mark - MMSliderDelegate
- (void)sliderWillRespondsToPanGestureRecognizer:(MMSlider *)slider {
    if ([self.delegate respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.timer invalidate];
        [self.delegate willDragToChangeCurrentTime];
    }
}

- (void)sliderDidFinishedRespondsToPanGestureRecognizer:(MMSlider *)slider {
    if ([self.delegate respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self _resetTimer];
        [self.delegate didFinishedDragToChangeCurrentTime];
    }
}

- (void)sliderPanGestureRecognizer:(MMSlider *)slider value:(CGFloat)value {
    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:value];
    }
}

- (void)sliderTapAction:(MMSlider *)slider value:(CGFloat)value {
    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:value];
    }
}

#pragma mark - ThumbnailsViewDelegate
- (void)thumbnailsView:(ThumbnailsView *)view theImageTime:(NSTimeInterval)time {
    if ([self.delegate respondsToSelector:@selector(willDragToChangeCurrentTime)]) {
        [self.timer invalidate];
        [self.delegate willDragToChangeCurrentTime];
    }

    if ([self.delegate respondsToSelector:@selector(setVideoPlayerCurrentTime:)]) {
        [self.delegate setVideoPlayerCurrentTime:time];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishedDragToChangeCurrentTime)]) {
        [self _resetTimer];
        [self.delegate didFinishedDragToChangeCurrentTime];
    }
}
#pragma mark - MMUpdateUIInterface
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    [self.indicatorView stopAnimating];
    NSUInteger currentSeconds = time;
    self.currentTimeLabel.text = [NSString formatSeconds:currentSeconds];
    self.endTimeLabel.text = [NSString formatSeconds:duration];
    self.slider.value = time;
}

- (void)setCacheTime:(NSTimeInterval)time {
    self.slider.cacheValue = time;
}

- (void)setSliderMinimumValue:(NSTimeInterval)minTime maximumValue:(NSTimeInterval)maxTime {
    self.slider.minimumValue = (NSUInteger)minTime;
    self.slider.maximumValue = (NSUInteger)maxTime;
}

- (void)callTheActionWiththeEndOfVideo {
    self.slider.value = 0.0;
    self.playButton.selected = NO;
}


- (void)showActivityIndicatorView {
    if (self.playButton.selected == YES) {
     [self.indicatorView startAnimating];
    }
    
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
        _showIndexImageUIButton.selected = NO;
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

//- (UISlider *)sliderView {
//    if (_sliderView == nil) {
//        _sliderView = [[UISlider alloc] init];
//        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
//        _sliderView.maximumTrackTintColor = [UIColor lightGrayColor];
//        [_sliderView setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
//        [_sliderView addTarget:self action:@selector(respondToSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
//        [_sliderView addTarget:self action:@selector(respondToTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_sliderView addTarget:self action:@selector(respondToTouchDownAction:) forControlEvents:UIControlEventTouchDown];
//    }
//    return _sliderView;
//}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textColor =[UIColor whiteColor];
    }
    return _currentTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.text = @"00:00";
    }
    return _endTimeLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] init];
        _topBarView.backgroundColor = [UIColor clearColor];
    }
    return _topBarView;
}

- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] init];
        _bottomBarView.backgroundColor = [UIColor clearColor];
    }
    return _bottomBarView;
}

- (ThumbnailsView *)thumbnailsView {
    if (_thumbnailsView == nil) {
        _thumbnailsView = [[ThumbnailsView alloc] init];
        _thumbnailsView.delegate = self;
    }
    return _thumbnailsView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (MMSlider *)slider {
    if (_slider == nil) {
        _slider = [[MMSlider alloc] initWithFrame:CGRectZero];
        _slider.delegate = self;
    }
    return _slider;
}
@end
