//
//  YSLoopView.m
//  CinemaForiPad
//
//  Created by william on 16/4/1.
//  Copyright © 2016年 2345. All rights reserved.
//

#import "YSLoopView.h"
#import "ZYAppHeaderForiPad.h"


static NSString *kMMRingStrokeAnimationKey = @"mmmaterialdesignspinner.stroke";
static NSString *kMMRingRotationAnimationKey = @"mmmaterialdesignspinner.rotation";

@interface YSLoopView ()

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readonly) CAShapeLayer *progressLayerBackGround;
@property (nonatomic, readwrite) BOOL isPrivateAnimating;
@end

@implementation YSLoopView

@synthesize progressLayer=_progressLayer;
@synthesize progressLayerBackGround=_progressLayerBackGround;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.opaque = NO;
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addSublayer:self.progressLayerBackGround];
    [self.layer addSublayer:self.progressLayer];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                   radius:radius
                               startAngle:-M_PI_2
                                 endAngle:-M_PI_2 + M_PI *2
                                clockwise:YES];
    self.progressLayer.path = path.CGPath;
    self.progressLayer.strokeStart = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayerBackGround.path = self.progressLayer.path;

    
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}
- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.progressLayer.strokeColor = self.tintColor.CGColor;
}


- (void)startLoopAnimating {
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animation forKey:kMMRingRotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:1.5f];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animations forKey:kMMRingStrokeAnimationKey];
    
    self.isPrivateAnimating = true;
    self.hidden = NO;
}

- (void)stopLoopAnimating {
    if (!self.isAnimating)
        return;
    [self.progressLayer removeAnimationForKey:kMMRingRotationAnimationKey];
    [self.progressLayer removeAnimationForKey:kMMRingStrokeAnimationKey];
    self.isPrivateAnimating = false;
}
#pragma mark - Properties
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = RGBCOLORV(0x2ac7fe).CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 3.f;
    }
    return _progressLayer;
}
- (CAShapeLayer *)progressLayerBackGround {
    if (!_progressLayerBackGround) {
        _progressLayerBackGround = [CAShapeLayer layer];
        _progressLayerBackGround.strokeColor = RGBCOLORVA(0x404040, 0.3).CGColor;
        _progressLayerBackGround.fillColor = [UIColor clearColor].CGColor;
        _progressLayerBackGround.lineWidth = 3.f;
    }
    return _progressLayerBackGround;
}

- (BOOL)isAnimating {
    return self.isPrivateAnimating;
}


@end
