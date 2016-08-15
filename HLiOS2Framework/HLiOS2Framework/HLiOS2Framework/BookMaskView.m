//
//  BookMaskView.m
//  HLiOS2Framework
//
//  Created by 星宇陈 on 14-2-7.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "BookMaskView.h"

static CGFloat const rectangleRectWith = 86;
static CGFloat const rectangleRectHeight = 66;
static CGFloat const attetionStringHeight = 16;

@interface BookMaskView ()

@property (retain , nonatomic) UIImage  *maskImage;
@property (retain , nonatomic) NSString *attentionContent;

@end

@implementation BookMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.maskImage = [UIImage imageNamed: @"water_stain"];
        _attentionContent = @"appMaker制作 禁止用于商业用途 宏乐（北京）科技有限责任公司 版权所有";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Image Declarations
    UIColor* imagePattern = [UIColor whiteColor];
    if (_maskImage) {
        
        imagePattern = [UIColor colorWithPatternImage:_maskImage];
    }
    
    
    //// Frames
    CGRect frame = rect;
    
    //// Abstracted Attributes
    CGRect rectangleRect = CGRectMake(CGRectGetMidX(frame) - rectangleRectWith/2.0, CGRectGetMidY(frame) - rectangleRectHeight / 2.0, rectangleRectWith, rectangleRectHeight);
    
    //// Group
    {
        //// //// Color Declarations
        UIColor *lineColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        
        //// Abstracted Attributes
        UIFont* attentionFont = [UIFont fontWithName: @"Helvetica" size: 9];
        
        //// attention Drawing
        CGRect attentionRect = CGRectMake(0, CGRectGetHeight(frame) - attetionStringHeight, CGRectGetWidth(frame), attetionStringHeight);
        [[UIColor whiteColor] setFill];
        [self.attentionContent drawInRect: attentionRect withFont:attentionFont lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
        CGContextSaveGState(context);
        CGContextSetPatternPhase(context, CGSizeMake(CGRectGetMinX(rectangleRect), CGRectGetMinY(rectangleRect)));
        [imagePattern setFill];
        [rectanglePath fill];
        CGContextRestoreGState(context);
//        [[UIColor clearColor] setStroke];
//        rectanglePath.lineWidth = 1;
//        [rectanglePath stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
        [bezier2Path addLineToPoint:CGPointMake(CGRectGetMinX(rectangleRect), CGRectGetMaxY(rectangleRect))];
        [lineColor setStroke];
        bezier2Path.lineWidth = 0.5;
        [bezier2Path stroke];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) , CGRectGetMaxY(frame))];
        [bezier3Path addLineToPoint: CGPointMake(CGRectGetMaxX(rectangleRect) , CGRectGetMaxY(rectangleRect))];
        [lineColor setStroke];
        bezier3Path.lineWidth = 0.5;
        [bezier3Path stroke];
        
        
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
        [bezier5Path moveToPoint: CGPointMake(CGRectGetMinX(frame) , CGRectGetMinY(frame))];
        [bezier5Path addLineToPoint: CGPointMake(CGRectGetMinX(rectangleRect) , CGRectGetMinY(rectangleRect))];
        bezier5Path.lineCapStyle = kCGLineCapRound;
        
        [lineColor setStroke];
        bezier5Path.lineWidth = 0.5;
        [bezier5Path stroke];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
        [bezier6Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) , CGRectGetMinY(frame))];
        [bezier6Path addLineToPoint: CGPointMake(CGRectGetMaxX(rectangleRect) , CGRectGetMinY(rectangleRect))];
        [lineColor setStroke];
        bezier6Path.lineWidth = 0.5;
        [bezier6Path stroke];
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

@end
