//
//  MMSlider.m
//  MMSliderView
//
//  Created by wyy on 2017/3/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMSlider.h"
static const CGFloat lineHeight = 2.0f;

@interface MMSlider ()
@property (nullable, nonatomic, strong) CAShapeLayer *sliderTrackLayer;
@property (nullable, nonatomic, strong) CAShapeLayer *cacheTrackLayer;
@property (nullable, nonatomic, strong) CAShapeLayer *thumbTintLayer;
@property (nullable, nonatomic, strong) CAShapeLayer *circleLayer;
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
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _updateLayer:self.thumbTintLayer newValue:_maximumValue StrokeColor:_thumbTintColor];
    [self _updateLayer:self.cacheTrackLayer newValue:_cacheValue StrokeColor:_cacheTrackColor];
    [self _updateLayer:self.sliderTrackLayer newValue:_value StrokeColor:_sliderTrackColor];
    [self _updateCircleLayer:self.circleLayer newValue:_value StrokeColor:_circleTintColor];
}

- (void)dealloc {
    NSLog(@"MMSlider is dealloc");
}
#pragma mark - private method
- (void)_initValues {
    _value = 0.0;
    _cacheValue = 0.0;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    
    _cacheTrackColor = [UIColor lightGrayColor];
    _thumbTintColor  = [UIColor whiteColor];
    _sliderTrackColor = [UIColor redColor];
    _circleTintColor  = [UIColor whiteColor];
}

- (void)_addGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
}


- (CGPathRef)_getLinePathWithPositionX:(CGFloat)positionX {
   UIBezierPath *path = [UIBezierPath bezierPath];
   CGPoint startPoint = CGPointMake(0, (CGRectGetHeight(self.frame) - lineHeight)/2);
   CGPoint endPoint = CGPointMake(positionX * CGRectGetWidth(self.frame)/_maximumValue, (CGRectGetHeight(self.frame) - lineHeight)/2);
   [path moveToPoint:startPoint];
   [path addLineToPoint:endPoint];
//   [path closePath];
   return [path CGPath];
}

- (CGPathRef)_getCirclePathWithPositionX:(CGFloat)positionX {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(positionX * CGRectGetWidth(self.frame)/_maximumValue, (CGRectGetHeight(self.frame) - lineHeight)/2) radius:5.0 startAngle:0.0 endAngle:180.0 clockwise:YES];
    return [path CGPath];
}

- (void)_updateCircleLayer:(CAShapeLayer *)shapeLayer
                  newValue:(float)value
               StrokeColor:(UIColor *)color {
    shapeLayer.path = [self _getCirclePathWithPositionX:value];
    shapeLayer.strokeColor = color.CGColor;
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
            _lastPointX = 0.0f;
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
    if ([self.delegate respondsToSelector:@selector(sliderTapAction:value:)]) {
        [self.delegate sliderTapAction:self value:MIN(MAX(tapValue, 0), _maximumValue)];
    }
}
#pragma mark - set
- (void)setCacheValue:(float)cacheValue {
    _cacheValue = cacheValue;
    [self _updateLayer:self.cacheTrackLayer newValue:_cacheValue StrokeColor:_cacheTrackColor];
}

- (void)setValue:(float)value {
    _value = value;
    [self _updateLayer:self.sliderTrackLayer newValue:_value StrokeColor:_sliderTrackColor];
    [self _updateCircleLayer:self.circleLayer newValue:_value StrokeColor:_circleTintColor];
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    [self _updateLayer:self.thumbTintLayer newValue:_maximumValue StrokeColor:_thumbTintColor];
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        _thumbTintLayer.strokeColor = [_thumbTintColor CGColor];
        [self _updateLayer:self.thumbTintLayer newValue:_maximumValue StrokeColor:_thumbTintColor];
    }
}

- (void)setSliderTrackColor:(UIColor *)sliderTrackColor {
    if (_sliderTrackColor != sliderTrackColor) {
        _sliderTrackColor = sliderTrackColor;
        _sliderTrackLayer.strokeColor = [_sliderTrackColor CGColor];
        [self _updateLayer:self.sliderTrackLayer newValue:_value StrokeColor:_sliderTrackColor];
        [self _updateCircleLayer:self.circleLayer newValue:_value StrokeColor:_circleTintColor];
    }
}

- (void)setCacheTrackColor:(UIColor *)cacheTrackColor {
    if (_cacheTrackColor != cacheTrackColor) {
        _cacheTrackColor = cacheTrackColor;
        _cacheTrackLayer.strokeColor = [_cacheTrackColor CGColor];
        [self _updateLayer:self.cacheTrackLayer newValue:_cacheValue StrokeColor:_cacheTrackColor];
    }
}
#pragma mark - get
- (CAShapeLayer *)sliderTrackLayer{
    if (_sliderTrackLayer == nil) {
        _sliderTrackLayer = [CAShapeLayer layer];
        _sliderTrackLayer.lineWidth = lineHeight;
    }
    return _sliderTrackLayer;
}

- (CAShapeLayer *)cacheTrackLayer{
    if (_cacheTrackLayer == nil) {
        _cacheTrackLayer = [CAShapeLayer layer];
        _cacheTrackLayer.lineWidth = lineHeight;
    }
    return _cacheTrackLayer;
}

- (CAShapeLayer *)thumbTintLayer{
    if (_thumbTintLayer == nil) {
        _thumbTintLayer = [CAShapeLayer layer];
        _thumbTintLayer.lineWidth = lineHeight;
    }
    return _thumbTintLayer;
}

- (CAShapeLayer *)circleLayer {
    if (_circleLayer == nil) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.fillColor = [[UIColor redColor] CGColor];
        _circleLayer.lineWidth = lineHeight;
    }
    return _circleLayer;
}
@end

