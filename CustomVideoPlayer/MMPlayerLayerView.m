//
//  MMPlayerLayerView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/27.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMPlayerLayerView.h"
#import "MMVideoHeader.h"
#import "ThumbnailsView.h"

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
@property (nonatomic, strong) ThumbnailsView *thumbnailsView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isToolShown;
@end

@implementation MMPlayerLayerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isToolShown = YES;
        [self initUI];
        [self _resetTimer];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.thumbnailsView];
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
    self.thumbnailsView.frame = CGRectMake(0, self.showIndexImageUIButton.selected?(kScreenHeigth - BottomBarViewHeight - ThumbnailsViewHeight): kScreenHeigth, kScreenWidth,ThumbnailsViewHeight);
    self.topBarView.frame = CGRectMake(0, self.isToolShown?0:-TopBarViewHeight, kScreenWidth, TopBarViewHeight);
    self.closeButton.frame = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
    self.showIndexImageUIButton.frame = CGRectMake(kScreenWidth - HorizontalMargin - IconSize, 0, IconSize, IconSize);
    self.titleLabel.frame  = CGRectMake(self.closeButton.right, 0, self.showIndexImageUIButton.left - self.closeButton.right, TopBarViewHeight);
    
    
    self.bottomBarView.frame = CGRectMake(0, self.isToolShown?kScreenHeigth - BottomBarViewHeight : kScreenHeigth , kScreenWidth, BottomBarViewHeight);
    self.playButton.frame  = CGRectMake(HorizontalMargin, 0, IconSize, IconSize);
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + DistanceBetweenHorizontalViews, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.endTimeLabel.frame = CGRectMake(kScreenWidth - TimeLableWidth - HorizontalMargin, self.playButton.top, TimeLableWidth, TimeLableHeight);
    self.sliderView.frame = CGRectMake(self.currentTimeLabel.right + DistanceBetweenHorizontalViews, self.playButton.top + 5, self.endTimeLabel.left - self.currentTimeLabel.right - 2*DistanceBetweenHorizontalViews, SliderViewHeight);
    
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
        self.topBarView.frame = CGRectMake(0, 0, kScreenWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, kScreenHeigth - BottomBarViewHeight , kScreenWidth, BottomBarViewHeight);
    } completion:^(BOOL finished) {
        self.isToolShown = YES;
    }];
}

- (void)_hideToolView {
    [UIView  animateWithDuration:.25 animations:^{
        self.topBarView.frame = CGRectMake(0, - TopBarViewHeight, kScreenWidth, TopBarViewHeight);
        self.bottomBarView.frame = CGRectMake(0, kScreenHeigth , kScreenWidth, BottomBarViewHeight);
        if (self.showIndexImageUIButton.selected == YES) {
           self.thumbnailsView.frame = CGRectMake(0, kScreenHeigth, kScreenWidth,ThumbnailsViewHeight);
            self.showIndexImageUIButton.selected = NO;
        }
    } completion:^(BOOL finished) {
        self.isToolShown = NO;
    }];
    
}

- (void)_resetTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f firing:^{
        if (self.timer.isValid && self.isToolShown) {
             [self _hideToolView];
        }
       
    }];
}
#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
            self.thumbnailsView.frame = CGRectMake(0, kScreenHeigth, kScreenWidth,ThumbnailsViewHeight);
        }else {
            [self.timer invalidate];
            self.thumbnailsView.frame = CGRectMake(0, kScreenHeigth -  ThumbnailsViewHeight - BottomBarViewHeight, kScreenWidth,ThumbnailsViewHeight);
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

#pragma mark - MMUpdateUIInterface
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
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

- (UISlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.maximumTrackTintColor = [UIColor lightGrayColor];
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
    }
    return _thumbnailsView;
}
@end
