//
//  MoueeScrollView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-21.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLScrollView.h"
#import "HLContainer.h"
#import "ICponentResponderHandle.h"
#define KNOTIFICATION_PAGEVIEWTAP       @"PageViewTap"

@interface HLScrollView ()
{
    ICponentResponderHandle *_responder;
}

@end

@implementation HLScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _responder = [[ICponentResponderHandle alloc] init];
        _responder.responderView = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.minimumZoomScale= 1.0;
        self.maximumZoomScale= 1.0;
        self.bouncesZoom = NO;
        
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)] autorelease];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEVIEWTAP object:nil];   //
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            //            NSLog(@"UIGestureRecognizerStateBegan");
            //            [self.com onTouch];
            break;
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"UIGestureRecognizerStateEnded");
            [self.com onTouchEndTouchUp];
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    self.scrollEnabled = NO;      //陈星宇，11.4
    //    [super touchesBegan:touches withEvent:event];
    if (self.com != nil)
    {
        [self.com onTouch];
    }
    
    [_responder touchesBegan:touches withEvent:event];      //陈星宇，11.5
//    
//    UITouch *th = [touches anyObject];
//    p1 = [th locationInView:self.superview];
    
}
//
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //判断是否关联元素 并且遍历所有container 找到对应id。
    if (self.isEnableMoveable == YES)
    {
    [_responder touchesMoved:touches withEvent:event];  //陈星宇，11.5
    
//        UITouch *th = [touches anyObject];
//        p2 = [th locationInView:self.superview];
//    self.frame = CGRectMake(self.frame.origin.x+p2.x - p1.x, self.frame.origin.y+p2.y-p1.y, self.frame.size.width, self.frame.size.height);
//    CGFloat xChange = p2.x - p1.x;
//    CGFloat yChange = p2.y - p1.y;
//    //        self.center = CGPointMake(self.center.x + xChange, self.center.y + yChange);
//    [self.com.container runLinkageContainerXY:xChange :yChange];
//    p1 = p2;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //    self.scrollEnabled = YES;     //陈星宇，11.4
    [_responder touchesEnded:touches withEvent:event];  //陈星宇，11.5
    
    UITouch *th = [touches anyObject];
    CGPoint point = [th locationInView:self];
    if ([self pointInside:point withEvent:event])
    {
        [self.com onTouchEndTouchUp];
    }
}

- (void)dealloc
{
    if (_responder != nil) {
        [_responder release];
    }
    
    [super dealloc];
}

@end
