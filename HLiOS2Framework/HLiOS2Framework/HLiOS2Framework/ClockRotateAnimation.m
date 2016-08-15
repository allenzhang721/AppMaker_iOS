//
//  ClockRotateAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClockRotateAnimation.h"
#import "HLNSBKeyframeAnimation.h"

@implementation ClockRotateAnimation

@synthesize angle;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) playHandler
{
    if (self.isPaused == YES)
    {
        [super playHandler];
        return;
    }
    [super playHandler];
	if (self.view != nil) 
	{
        
        float fromValue = 0.0;
        float toValue   = 0.0;
		NSNumber *rotation       = [self.view.layer valueForKeyPath:@"transform.rotation"];
		fromValue         = [rotation floatValue];
		toValue           = [[NSNumber numberWithFloat:((angle* M_PI / 180.0f)+[rotation floatValue])] floatValue];
        
        HLNSBKeyframeAnimation *rotate = [HLNSBKeyframeAnimation animationWithKeyPath:@"transform.rotation" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = toValue;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];

		rotate.fillMode          = kCAFillModeForwards;
		rotate.delegate          = self;
		if (self.times > 0 )
		{
			rotate.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			rotate.repeatCount = HUGE_VALF;
		}
        [rotate setFillMode:kCAFillModeForwards];
        rotate.removedOnCompletion =NO;
       
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]];
        fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
		fadeIn.duration  = self.duration;
        [fadeIn setFillMode:kCAFillModeForwards];
        fadeIn.removedOnCompletion =NO;

        CAAnimationGroup *group = [CAAnimationGroup animation]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		group.delegate = self;
		[group setDuration:self.duration]; 
		[group setAnimations: [NSArray arrayWithObjects:rotate,fadeIn, nil]];
		if (self.times > 0 )
		{
			group.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			group.repeatCount = HUGE_VALF;
		}
        [group setBeginTime:CACurrentMediaTime()];
		[self.view.layer addAnimation:group forKey:@"scaleAnimation"];
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *value     = [EMTBXML textForElement:[EMTBXML childElementNamed:@"CustomProperties" parentElement:data]];
    self.angle          = [value floatValue];
    [pool release];
}

-(void)reset//modified by Adward 13-12-27
{
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    [self.view.layer removeAllAnimations];
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

@end
