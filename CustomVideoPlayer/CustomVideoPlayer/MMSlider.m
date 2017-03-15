//
//  MMSlider.m
//  MMSliderView
//
//  Created by wyy on 2017/3/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMSlider.h"
static const CGFloat SliderViewHeight = 30.0f;
@implementation MMSlider
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initValues];
        [self _addGestureRecognizer];
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
}
#pragma mark - private method
- (void)_initValues {
    self.value = 0.0;
    self.cacheValue = 0.0;
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
}

- (void)_addGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
}

- (void)_drawLineWithOrginX:(CGFloat)orginX
                     OrginY:(CGFloat)orginY
                 lineHeight:(CGFloat)height
                  lineWidth:(CGFloat)width{
    CGMutablePathRef maxPath = CGPathCreateMutable();
}
#pragma mark - action
- (void)respondsToPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    
}

- (void)respondsToTapGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    
}

@end

