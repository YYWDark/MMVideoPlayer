//
//  MMSlider.h
//  MMSliderView
//
//  Created by wyy on 2017/3/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSlider : UIControl
@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float cacheValue;                            // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nullable, nonatomic,strong) UIColor *sliderTrackColor;
@property(nullable, nonatomic,strong) UIColor *cacheTrackColor;
@property(nullable, nonatomic,strong) UIColor *thumbTintColor;
@end
