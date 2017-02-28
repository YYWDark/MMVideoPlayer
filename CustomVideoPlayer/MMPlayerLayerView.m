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

#pragma mark - action
- (void)respondToButtonAction:(UIButton *)button {
  
}

- (void)respondToSliderAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
}
#pragma mark - get
- (UIButton *)closeButton {
    if (_closeButton == nil) {
        
    }
    return _closeButton;
}


- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.selected = NO;
        _playButton.tag = 1;
        [_playButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_play_prs"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(respondToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UISlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UISlider alloc] init];
        [_sliderView setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor =[UIColor redColor];
        _sliderView.maximumTrackTintColor =[UIColor grayColor];
        [_sliderView addTarget:self action:@selector(respondToSliderAction:) forControlEvents:UIControlEventValueChanged];
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
