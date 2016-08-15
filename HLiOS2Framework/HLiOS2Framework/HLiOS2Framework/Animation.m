//
//  Animation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Animation.h"
#import "EaseFunctionCreator.h"
#import <QuartzCore/QuartzCore.h>

@implementation Animation


@synthesize view;
@synthesize duration;
@synthesize times;
@synthesize delay;
@synthesize isLoop;
@synthesize isRevser;
@synthesize container;
@synthesize easeFunction;
@synthesize isReversPlay;
@synthesize containerRect;
@synthesize animationRect;
@synthesize containerRotation;
@synthesize animationRotation;
@synthesize isPlaying;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.duration = 1.0f;
		self.times    = -1.0;
        self.delay    = 0;
        self.isLoop   = NO;
		self.isRevser = NO;
        self.isReversPlay = NO;
        self.isFirstPlay = YES;
        self.isHidden = NO;
        self.isPaused = NO;
    }
    return self;
}

-(void) setView:(UIView *)view1
{
    view = view1;
}

-(void) play
{
    if (self.delay != 0  && !self.isPaused)
    {
        [self performSelector:@selector(playHandler) withObject:nil afterDelay:self.delay];
    }
    else
    {
        [self playHandler];
    }
    
}

-(void)playHandler//有keep时delay在动画开始前 2.26
{
    if (self.isPaused == NO)
    {
        if ((self.isKeep == YES)&&(self.isKeepEndStatus == NO) && (self.isFirstPlay == NO))
        {
            [self reset];
        }
        self.isFirstPlay = NO;
        //        self.view.hidden = self.isHidden;
        self.animationRect = self.view.frame;
        //        [self.view.layer removeAllAnimations];
        self.isPaused = NO;
        self.startTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    }
    else
    {
        //convert from parent time tp to active local time t: t = (tp - begin) * speed + offset.
        
        CFTimeInterval pausedTime = [self.view.layer timeOffset];
        self.view.layer.speed = 1.0;
        self.view.layer.timeOffset = 0.0;
        self.view.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.view.layer.beginTime = timeSincePause;
        self.isPaused = NO;
    }
    self.isPlaying = YES;
}

-(void)reset
{
    [self.view.layer removeAllAnimations];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
    [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
    self.view.frame = self.containerRect;
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
}

-(void)keep
{
    CALayer* layer = self.view.layer.presentationLayer;
    self.view.layer.transform = layer.transform;
    self.view.layer.bounds    = layer.bounds;
    if (!isnan(layer.position.x) && !isnan(layer.position.y))
    {
        self.view.layer.position  = layer.position;
    }
//    self.view.layer.opacity   = [self.container.entity.alpha floatValue];
}

-(void) stop
{
    if(self.isPlaying || self.isPaused)
    {
        [self.view.layer removeAllAnimations];
        self.view.layer.speed      = 1.0;
        self.view.layer.timeOffset = 0.0;
        self.view.layer.beginTime  = 0.0;
        self.isPaused = NO;
        self.isPlaying = NO;
        [self reset];
    }
	
}

-(void) pause
{
    if (self.isPaused == NO)
    {
        CFTimeInterval pausedTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.view.layer.speed = 0.0; 
        self.view.layer.timeOffset = pausedTime;
        self.isPaused  = YES;
        self.isPlaying = NO;
    }
}


- (void)animationDidStart:(CAAnimation *)theAnimation
{
    if (self.container != nil) 
    {
        self.view.hidden = NO;
        self.container.component.uicomponent.hidden = NO;
    }
	[self.container onAnimationStart];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == YES)
    {
        if(self.isKeep == YES)
        {
            [self keep];    //Mr.chen, 14.3.14
        }
        else
        {
            [self reset];
        }
        [self.view.layer removeAllAnimations];
        self.isPaused = NO;
        self.isPlaying = NO;
        [self.container onAnimationEnd];
    }
}

-(void) decode:(TBXMLElement *) data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *durationstr  = @"0";
    if ([EMTBXML childElementNamed:@"Duration" parentElement:data])
    {
        durationstr = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Duration" parentElement:data]];
    }
    
    TBXMLElement* timeElement =  [EMTBXML childElementNamed:@"Repeat" parentElement:data];
    if (timeElement != nil)
    {
        NSString *timesstr  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Repeat" parentElement:data]];
        self.times  = [timesstr floatValue];
        if (self.times < 0.1 && self.times > -0.1)
        {
            self.isLoop = YES;
        }
    }
    else
    {
        self.times  = 1;
    }
    NSString *delaystr    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Delay" parentElement:data]];
    self.duration = [durationstr floatValue] / 1000;
    self.delay    = [delaystr floatValue];
    TBXMLElement* etype =  [EMTBXML childElementNamed:@"EaseType" parentElement:data];
    if (etype != nil)
    {
        self.easeType = [EMTBXML textForElement:[EMTBXML childElementNamed:@"EaseType" parentElement:data]];
    }
    else
    {
        self.easeType = @"none";
    }
    TBXMLElement* tkeep =  [EMTBXML childElementNamed:@"IsKeep" parentElement:data];
    if (tkeep != nil)
    {
        self.isKeep = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"IsKeep" parentElement:data]] boolValue];
    }
    else
    {
        self.isKeep = YES;
    }
    TBXMLElement* tReverse =  [EMTBXML childElementNamed:@"IsReverse" parentElement:data];
    if (tReverse != nil)
    {
        self.isReversPlay = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"IsReverse" parentElement:data]] boolValue];
    }
    else
    {
        self.isReversPlay = NO;
    }
    TBXMLElement* tKeepEndStatus =  [EMTBXML childElementNamed:@"IsKeepEndStatus" parentElement:data];
    if (tKeepEndStatus != nil)
    {
        self.isKeepEndStatus =  [[EMTBXML textForElement:[EMTBXML childElementNamed:@"IsKeepEndStatus" parentElement:data]] boolValue];
    }
    else
    {
        self.isKeepEndStatus = NO;
    }
    [pool release];
    self.easeFunction = [EaseFunctionCreator animationFunctionForType:self.easeType];
}

- (void)dealloc
{
    [self.view.layer removeAllAnimations];
    self.container = nil;
    [super dealloc];
}


@end
