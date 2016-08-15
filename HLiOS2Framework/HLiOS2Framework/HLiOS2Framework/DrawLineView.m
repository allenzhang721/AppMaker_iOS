//
//  DrawLineView.m
//  DrawLineTest
//
//  Created by Mouee-iMac on 13-5-7.
//  Copyright (c) 2013年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "DrawLineView.h"

@implementation DrawLineView
@synthesize lineColor;
@synthesize lineAlpha;
@synthesize lineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueRecognizer:)] autorelease];
        [self addGestureRecognizer:recognizer];
        self.beginPoint = CGPointMake(-100, -100);//起始点在屏幕上没划线时有显示 added by Adaward 13-12-04
        self.endPoint = CGPointMake(-100, -100);
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
//    NSLog(@"drawing");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLine:context];
}

- (void)drawLine:(CGContextRef)context
{
    CGContextMoveToPoint(context, _beginPoint.x, _beginPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);//设置线为圆角矩形
    
    //十六进制转化为RGB颜色 Adward 13-11-22
    unsigned int red = 0, green = 0, blue = 0;
    NSRange range;
    range.length =2;
    
    if (self.lineColor.length >= 8)
    {
        range.location = 2;
        [[NSScanner scannerWithString:[self.lineColor substringWithRange:range]]scanHexInt:&red];
        range.location = 4;
        [[NSScanner scannerWithString:[self.lineColor substringWithRange:range]]scanHexInt:&green];
        range.location = 6;
        [[NSScanner scannerWithString:[self.lineColor substringWithRange:range]]scanHexInt:&blue];
    }
    
    CGContextSetRGBStrokeColor(context, red / 255.0, green / 255.0, blue / 255.0, 1);
    CGContextSetAlpha(context, self.lineAlpha);  
    CGContextStrokePath(context);
}

- (void)panGestrueRecognizer:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            if ([_delegate respondsToSelector:@selector(curTouchMoving:drawView:)]) {
                [_delegate curTouchMoving:CGPointMake([gesture locationInView:self].x, [gesture locationInView:self].y) drawView:self];
            }
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if ([_delegate respondsToSelector:@selector(curTouchUp:)]) {
                [_delegate curTouchUp:CGPointMake([gesture locationInView:self].x, [gesture locationInView:self].y)];
            }
            break;
        }
        default:
            break;
    }
}


@end
