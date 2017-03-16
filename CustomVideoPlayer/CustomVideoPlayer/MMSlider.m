//
//  MMSlider.m
//  MMSliderView
//
//  Created by wyy on 2017/3/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMSlider.h"
//static const CGFloat SliderViewHeight = 30.0f;

@interface MMSlider ()
@property (nullable, nonatomic, strong) CAShapeLayer *sliderTrackLayer;
@property (nullable, nonatomic, strong) CAShapeLayer *cacheTrackLayer;
@property (nullable, nonatomic, strong) CAShapeLayer *thumbTintLayer;
@property (nonatomic, assign) CGFloat lastPointX;
@end

@implementation MMSlider
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initValues];
        [self _addGestureRecognizer];
        [self.layer addSublayer:self.thumbTintLayer];
        [self.layer addSublayer:self.cacheTrackLayer];
        [self.layer addSublayer:self.sliderTrackLayer];
    }
    return self;
}

#pragma mark - private method
- (void)_initValues {
    _value = 0.0;
    _cacheValue = 0.0;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    
    _cacheTrackColor = [UIColor greenColor];
    _thumbTintColor  = [UIColor blackColor];
    _sliderTrackColor = [UIColor redColor];
}

- (void)_addGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
}

- (void)_addObserver {
    
}

- (CGPathRef)_getLinePathWithPositionX:(CGFloat)positionX {
   UIBezierPath *path = [UIBezierPath bezierPath];
   CGPoint startPoint = CGPointMake(0, 10);
   CGPoint endPoint = CGPointMake(positionX * CGRectGetWidth(self.frame)/_maximumValue, 10);
   [path moveToPoint:startPoint];
   [path addLineToPoint:endPoint];
   [path closePath];
   return [path CGPath];
}

- (void)_updateLayer:(CAShapeLayer *)shapeLayer
           newValue:(float)value
        StrokeColor:(UIColor *)color {
    shapeLayer.path = [self _getLinePathWithPositionX:value];
    shapeLayer.strokeColor = color.CGColor;
}

#pragma mark - action
- (void)respondsToPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer translationInView:self];
    CGFloat moveDistance = point.x - _lastPointX;
    _lastPointX = point.x;
    CGFloat moveValue = moveDistance * _maximumValue/CGRectGetWidth(self.frame);
//    self.value = MIN(MAX(_value + moveValue, 0), _maximumValue);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if ([self.delegate respondsToSelector:@selector(sliderWillRespondsToPanGestureRecognizer:)]) {
                [self.delegate sliderWillRespondsToPanGestureRecognizer:self];
            }
        break;}
        case UIGestureRecognizerStateChanged:{
            if ([self.delegate respondsToSelector:@selector(sliderDidFinishedRespondsToPanGestureRecognizer:)]) {
                [self.delegate sliderPanGestureRecognizer:self value: MIN(MAX(_value + moveValue, 0), _maximumValue)];
            }
            break;}
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            if ([self.delegate respondsToSelector:@selector(sliderDidFinishedRespondsToPanGestureRecognizer:)]) {
                [self.delegate sliderDidFinishedRespondsToPanGestureRecognizer:self];
            }
            break;}
        default:
            break;
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
     CGPoint point = [gestureRecognizer locationInView:self];
     CGFloat tapValue =  point.x *_maximumValue/CGRectGetWidth(self.frame);
//     self.value = MIN(MAX(tapValue, 0), _maximumValue);
    
    if ([self.delegate respondsToSelector:@selector(sliderTapAction:value:)]) {
        [self.delegate sliderTapAction:self value:MIN(MAX(tapValue, 0), _maximumValue)];
    }
}
#pragma mark - set
- (void)setCacheValue:(float)cacheValue {
    _cacheValue = cacheValue;
    [self _updateLayer:_cacheTrackLayer newValue:_cacheValue StrokeColor:_cacheTrackColor];
}

- (void)setValue:(float)value {
    _value = value;
    [self _updateLayer:_sliderTrackLayer newValue:_value StrokeColor:_sliderTrackColor];
    
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    [self _updateLayer:_thumbTintLayer newValue:_maximumValue StrokeColor:_thumbTintColor];
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        _thumbTintLayer.strokeColor = [_thumbTintColor CGColor];
        [self _updateLayer:_thumbTintLayer newValue:_maximumValue StrokeColor:_thumbTintColor];
    }
}

- (void)setSliderTrackColor:(UIColor *)sliderTrackColor {
    if (_sliderTrackColor != sliderTrackColor) {
        _sliderTrackColor = sliderTrackColor;
        _sliderTrackLayer.strokeColor = [_sliderTrackColor CGColor];
        [self _updateLayer:_sliderTrackLayer newValue:_value StrokeColor:_sliderTrackColor];
    }
}

- (void)setCacheTrackColor:(UIColor *)cacheTrackColor {
    if (_cacheTrackColor != cacheTrackColor) {
        _cacheTrackColor = cacheTrackColor;
        _cacheTrackLayer.strokeColor = [_cacheTrackColor CGColor];
        [self _updateLayer:_cacheTrackLayer newValue:_cacheValue StrokeColor:_cacheTrackColor];
    }
}
#pragma mark - get
- (CAShapeLayer *)sliderTrackLayer{
    if (_sliderTrackLayer == nil) {
        _sliderTrackLayer = [CAShapeLayer layer];
        _sliderTrackLayer.strokeColor = [[UIColor redColor] CGColor];
        _sliderTrackLayer.lineWidth = 2.0;
    }
    return _sliderTrackLayer;
}

- (CAShapeLayer *)cacheTrackLayer{
    if (_cacheTrackLayer == nil) {
        _cacheTrackLayer = [CAShapeLayer layer];
        _cacheTrackLayer.strokeColor = [[UIColor greenColor] CGColor];
        _cacheTrackLayer.lineWidth = 2.0;
    }
    return _cacheTrackLayer;
}

- (CAShapeLayer *)thumbTintLayer{
    if (_thumbTintLayer == nil) {
        _thumbTintLayer = [CAShapeLayer layer];
        _thumbTintLayer.strokeColor = [[UIColor blackColor] CGColor];
        _thumbTintLayer.lineWidth = 2.0;
    }
    return _thumbTintLayer;
}

@end

