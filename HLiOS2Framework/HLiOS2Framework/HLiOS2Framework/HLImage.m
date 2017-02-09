//
//  MoueeImage.m
//  MoueeTest
//
//  Created by Pi Yi on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HLImage.h"
#import "ImageComponent.h"
#import "HLContainer.h"
#import "ICponentResponderHandle.h"

#define KNOTIFICATION_PAGEVIEWTAP       @"PageViewTap"

#define gap 30 //浮动半径

@interface HLImage ()
{
    ICponentResponderHandle *_responder;     //陈星宇，11.5
    UIGestureRecognizer *PanGesture;
}

@end

@implementation HLImage
@synthesize isEnableMoveable;
@synthesize com;
@synthesize dw;
@synthesize dh;
@synthesize isMoveScale;
@synthesize isCanGotoPage;

#pragma mark -
#pragma mark - Base Method

- (void)didGesture{};

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}
-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.scaled = NO;
        //
        _responder = [[ICponentResponderHandle alloc] init];
        _responder.responderView = self;                        //陈星宇。11.5，responder统一管理
        
        // Emiaostein, 2017.1.16
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)];
        gesture.delegate             = (id <UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:gesture];
        gesture.cancelsTouchesInView = YES;
        [gesture release];
        
        UISwipeGestureRecognizer *upSwip = [[[UISwipeGestureRecognizer alloc] init] autorelease];
        upSwip.direction                 = UISwipeGestureRecognizerDirectionUp;
        [upSwip addTarget:self action:@selector(onSwipeUp)];
        [self addGestureRecognizer:upSwip];
    }
    return self;
}

-(void)setIsEnableMoveable:(Boolean)moveable
{
    isEnableMoveable = moveable;
    if (isEnableMoveable)
    {
        UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture)];
        gesture.delegate = (id <UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:gesture];
        gesture.cancelsTouchesInView = NO;      //deliver touch events
        [gesture release];
    }
}



#pragma mark -
#pragma mark - Touch Event

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.com onTouch];     //Mr.chen, 04.25.2014, 触摸开始时
    if (self.isEnableMoveable == YES)
    {
        [self.com onTouchBegin];//added by Adward 13-11-21 for 记录回置初始位置
        [_responder touchesBegan:touches withEvent:event];  //陈星宇，11.5
        if (isMoveScale == YES)
        {
            dw = 10;
            dh = 10;
            [_responder runLinkageContainerWidth:dw/2 Height:dh/2];     //点击放大
        }
    }
    else
    {
        //陈星宇，11.19，图片放大后可移动
        
        bool isByUserScale = self.com.isbyUserScale;
        if (isByUserScale == YES) {
            UITouch *touch      = [touches anyObject];
            p1                  = [touch locationInView:self.superview];

            PanGesture          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture)];
            PanGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
            [self addGestureRecognizer:PanGesture];
            PanGesture.cancelsTouchesInView = NO;// adward 13-12-30 deliver touch events
            //            [PanGesture release];
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEnableMoveable == YES)
    {
        [_responder touchesMoved:touches withEvent:event];      //陈星宇，11.5
    }
    else
    {
        bool isByUserScale = self.com.isbyUserScale;
        if (isByUserScale == YES)
        {
            UITouch *touch = [touches anyObject];
            p2             = [touch locationInView:self.superview];
            float dx       = p2.x - p1.x;
            float dy       = p2.y - p1.y;
            
            CGPoint curCenter           = self.com.uicomponent.center;
            curCenter                   = CGPointMake(curCenter.x + dx, curCenter.y + dy);
            self.com.uicomponent.center = curCenter;
        }   //陈星宇，11.19，图片缩放后移动
    }
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isCanGotoPage)//如果当前点击引发page change，当前对象release
    {
        return;
    }
    [super touchesEnded:touches withEvent:event];
    BOOL isTouchup = YES;
    if (self.isEnableMoveable == YES)//是否随手指移动
    {
        [_responder touchesEnded:touches withEvent:event];          //陈星宇，11.5
        
        if (isMoveScale == YES)
        {
            [_responder runLinkageContainerWidth:(-dw/2) Height:(-dh/2)];       //松手缩小
        }
    }
    else
    {
        //陈星宇，11.19，图片放大后可移动
        [self removeGestureRecognizer:PanGesture];
    }
    
    if ([self.com onTouchEnd])
    {
        isTouchup = NO;
    }
    
    if(isTouchup)
    {
        UITouch *th   = [touches anyObject];
        CGPoint point = [th locationInView:self];
        if ([self pointInside:point withEvent:event])
        {
            [self.com onTouchEndTouchUp];
        }
    }
}

#pragma mark -
#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
    return YES;
}

- (void)didTapGesture:(UITapGestureRecognizer *)gesture//因为ios7 上面在scrollview上滑动的时候会触发 touchesBegan: 所以 点击应该单独用手势写 而不能放在touchesBegan里面
{
    if (self.com != nil)
    {
        if (!self.com.container.entity.behaviors || [self.com.container.entity.behaviors count] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEVIEWTAP object:nil];
        }
        self.isCanGotoPage = [self.com onTapGesture];     //Mr.chen, 04.25.2014, 触摸结束时
    }
}

- (void)onSwipeUp
{
    [self.com onSwipeUp];
}

#pragma mark -
#pragma mark - Caculate

+ (UIImage *)scaledImage:(UIImage*)image width:(float)width height:(float)height
{
    if (!image)
    {
        return nil;
    }
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIImage *scaledImg = nil;
    CGSize size = CGSizeMake(width, height);
    size.width *= mainScreen.scale;
    size.height *= mainScreen.scale;
    if (size.width * 1.5 > image.size.width)
    {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImg;
}

- (id)initWithImage:(UIImage *)image width:(float)width height:(float)height
{
    UIImage *scaledImage = [HLImage scaledImage:image width:width height:height];
    return  [self initWithImage:scaledImage];
}





//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event   // default returns YES if point is in bounds
//{
//    CALayer *presentLayer = ((CALayer*)self.layer.presentationLayer);
//    if (!presentLayer)
//    {
//        return [super pointInside:point withEvent:event];
//    }
//
//
//    CGPoint superPoint = [self convertPoint:point toView:self.superview];
//
//    CALayer *layer = [presentLayer hitTest:superPoint];
//    if (layer == presentLayer)
//    {
//        return YES;
//    }
//    return NO;
//
////    CGRect rect = ((CALayer*)self.layer.presentationLayer).frame;
////    CGPoint offsetpos = CGPointMake(point.x + self.frame.origin.x, point.y + self.frame.origin.y);
////    if (CGRectContainsPoint(rect, offsetpos))
////    {
////        return YES;
////    }
////    return NO;
//}

//////遮罩模板所需逻辑
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event   // default returns YES if point is in bounds
//{
//    unsigned char pixel[1] = {0};
//    CGContextRef context = CGBitmapContextCreate(pixel,
//                                                 1, 1, 8, 1, NULL,
//                                                 kCGImageAlphaOnly);
//    UIGraphicsPushContext(context);
//    [self.image drawAtPoint:CGPointMake(-point.x, -point.y)];
//    UIGraphicsPopContext();
//    CGContextRelease(context);
//    CGFloat alpha = pixel[0]/255.0;
//    BOOL transparent = alpha < 0.01;
//    //    NSLog(@"%f,(%f,%f)", alpha,point.x,point.y);
//    if(transparent)
//    {
//        BOOL containt = CGRectContainsPoint(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), point);
//        if ([self.com.container.entity.behaviors count] > 0 && containt)
//        {
//            //            NSLog(@"透明有事件");
//            return YES;
//        }
//        //        NSLog(@"透明图片");
//        if (containt) {
//            self.userInteractionEnabled = NO;
//        }
//        return NO;
//    }
//    else
//    {
//        //        NSLog(@"不透明");
//        return YES;
//    }
//}
#pragma mark -
#pragma mark - Dealloc

- (void)dealloc
{
    if (PanGesture)
    {
        [PanGesture release];
    }
    if (_responder != nil) {
        [_responder release];
    }
    [super dealloc];
}

@end
