//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation DACircularProgressView

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Frames
    CGRect frame = self.frame;
    
    //// Subframes
    CGRect group2 = CGRectMake(2, 2, CGRectGetWidth(frame)-4, CGRectGetWidth(frame)-4);
    
    
    //// Abstracted Attributes
    CGRect trackRect = CGRectMake(CGRectGetMinX(group2), CGRectGetMinY(group2), CGRectGetWidth(group2), CGRectGetWidth(group2));
    CGRect progressRect = CGRectMake(CGRectGetMinX(group2) + 3, CGRectGetMinY(group2) + 3, CGRectGetWidth(frame) - 10,  CGRectGetWidth(frame) - 10);
    CGFloat progressEndAngle =_progress * 360 - 90;
    if (progressEndAngle < 0.0) {
        progressEndAngle = 270 + _progress * 360;
    }else if (progressEndAngle >= 270) {
        progressEndAngle = 269.5;
    }
    
    NSString* textContent = [NSString stringWithFormat:@"%.0f%%",_progress * 100];
    
    
    //// Group
    {
        //// Group 2
        {
            //// track Drawing
            UIBezierPath* trackPath = [UIBezierPath bezierPathWithOvalInRect: trackRect];
            [color setFill];
            [trackPath fill];
            [color3 setStroke];
            trackPath.lineWidth = 2;
            [trackPath stroke];
            
            
            //// progress Drawing
            UIBezierPath* progressPath = [UIBezierPath bezierPath];
            [progressPath addArcWithCenter: CGPointMake(CGRectGetMidX(progressRect), CGRectGetMidY(progressRect)) radius: CGRectGetWidth(progressRect) / 2 startAngle: 270 * M_PI/180 endAngle: progressEndAngle * M_PI/180 clockwise: YES];
            
            [color setFill];
            [progressPath fill];
            [color3 setStroke];
            progressPath.lineWidth = 5;
            [progressPath stroke];
            
            //// Text Drawing
            CGRect textRect = CGRectMake(CGRectGetMinX(group2) + 2, CGRectGetMidY(group2) - 7, CGRectGetWidth(group2), 14);
            [color3 setFill];
            [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 14] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
        }
    }
//    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
//    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
//    
//    CGFloat pathWidth = radius * 0.3f;  //小球直径
//    
//    CGFloat radians = DEGREES_2_RADIANS((self.progress*359.9)-90);
//    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
//    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
//    CGPoint endPoint = CGPointMake(xOffset, yOffset);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    [self.trackTintColor setFill];
//    CGMutablePathRef trackPath = CGPathCreateMutable();
//    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
//    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
//    CGPathCloseSubpath(trackPath);
//    CGContextAddPath(context, trackPath);
//    CGContextFillPath(context);
//    CGPathRelease(trackPath);
//    
//    [self.progressTintColor setFill];
//    CGMutablePathRef progressPath = CGPathCreateMutable();
//    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
//    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
//    CGPathCloseSubpath(progressPath);
//    CGContextAddPath(context, progressPath);
//    CGContextFillPath(context);
//    CGPathRelease(progressPath);
    
//    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
//    CGContextFillPath(context);
//    
//    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
//    CGContextFillPath(context);
    
//    CGContextSetBlendMode(context, kCGBlendModeClear);;
//    CGFloat innerRadius = radius *0.0;
//	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);    
//	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
//	CGContextFillPath(context);
}

#pragma mark - Property Methods

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        _progressTintColor = [UIColor whiteColor];
    }
    return _progressTintColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
