////
////  SWFView.m
////  MoueeIOS2Core
////
////  Created by Pi Yi on 3/9/13.
////  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
////
//
//#import "SWFView.h"
//#import "Component.h"
//#import "Container.h"
//#import "PageController.h"
//
//@implementation SWFView
//
//@synthesize component;
//@synthesize dw;
//@synthesize dh;
//@synthesize isStoryTelling;
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        // Initialization code
//    }
//    return self;
//}
//
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    if (self.component != nil)
//    {
//        [self.component onTouch];
//    }
//    if (self.isStoryTelling == YES)
//    {
//        UITouch *th = [touches anyObject];
//        p1 = [th locationInView:self.superview];
//        dw = self.frame.size.width*0.2;
//        dh = self.frame.size.height*0.2;
//        [UIView beginAnimations:@"Scale" context:nil];
//        [UIView setAnimationDuration:0.50];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
//        [UIView commitAnimations];
//    }
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.isStoryTelling == YES)
//    {
//        UITouch *th = [touches anyObject];
//        p2 = [th locationInView:self.superview];
//        self.center = CGPointMake(self.center.x + p2.x - p1.x, self.center.y + p2.y-p1.y);
//        p1 = p2;
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    if (self.isStoryTelling == YES)
//    {
//        UITouch *th = [touches anyObject];
//        p2 = [th locationInView:self.superview];
//        self.center = CGPointMake(self.center.x + p2.x - p1.x, self.center.y + p2.y-p1.y);
//        p1 = p2;
//        [UIView beginAnimations:@"Scale" context:nil];
//        [UIView setAnimationDuration:0.50];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        self.transform = CGAffineTransformMakeScale(1.0,1.0);
//        [UIView commitAnimations];
//        [self.component onTouchEnd];
//    }
//    else
//    {
//        UITouch *th = [touches anyObject];
//        CGPoint point = [th locationInView:self];
//        if ([self pointInside:point withEvent:event])
//        {
//            [self.component onTouchEndTouchUp];
//        }
//    }
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
//{
//	return NO;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}
//*/
//
//@end
