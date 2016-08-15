//
//  RotateMoveInAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RotateMoveInAnimation.h"
#import "HLNSBKeyframeAnimation.h"

@implementation RotateMoveInAnimation

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
        
		if (self.isRevser)
		{
			fromValue         = [rotation floatValue];
			toValue           = [[NSNumber numberWithFloat:((90.0f* M_PI / 180.0f)+[rotation floatValue])] floatValue];
            
		}
		else
		{
			fromValue        = [[NSNumber numberWithFloat:((90.0f* M_PI / 180.0f)+[rotation floatValue])] floatValue];
			toValue          = [rotation floatValue];
            
		}
		
        HLNSBKeyframeAnimation *animation = [HLNSBKeyframeAnimation animationWithKeyPath:@"transform.rotation" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];

        
        float sizeWidthfromValue = 0.0;
        float sizeWidthtoValue   = 0.0;
		if (self.isRevser)
		{
			sizeWidthfromValue         = [[NSNumber numberWithFloat:self.view.layer.bounds.size.width] floatValue];
			sizeWidthtoValue           = [[NSNumber numberWithFloat:1.0f] floatValue];
		}
		else
		{
			sizeWidthfromValue          = [[NSNumber numberWithFloat:1.0f] floatValue];
			sizeWidthtoValue            = [[NSNumber numberWithFloat:self.view.layer.bounds.size.width] floatValue];
		}
        
        HLNSBKeyframeAnimation *sizeWidth = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.width" duration:self.duration startValue:sizeWidthfromValue endValue:sizeWidthtoValue function:self.easeFunction];
    
        float sizeHeightfromValue = 0.0;
        float sizeHeighttoValue   = 0.0;
		
		if (self.isRevser)
		{
			sizeHeightfromValue         = [[NSNumber numberWithFloat:self.view.layer.bounds.size.height] floatValue];
			sizeHeighttoValue           = [[NSNumber numberWithFloat:1.0f] floatValue];
		}
		else
		{
			sizeHeightfromValue         = [[NSNumber numberWithFloat:1.0f] floatValue];
			sizeHeighttoValue           = [[NSNumber numberWithFloat:self.view.layer.bounds.size.height] floatValue];
		}
        HLNSBKeyframeAnimation *sizeHeight = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.height" duration:self.duration startValue:sizeHeightfromValue endValue:sizeHeighttoValue function:self.easeFunction];

        float fadeInfromValue = 0.0;
        float fadeIntoValue   = 0.0;
		if (self.isRevser) 
		{
			fadeInfromValue        = [[NSNumber numberWithFloat:[self.container.entity.alpha floatValue]] floatValue];
			fadeIntoValue          = [[NSNumber numberWithFloat:0.0f] floatValue];
		}
		else 
		{
			fadeInfromValue         = [[NSNumber numberWithFloat:0.0f] floatValue];
			fadeIntoValue           = [[NSNumber numberWithFloat:[self.container.entity.alpha floatValue]] floatValue];
		}
        HLNSBKeyframeAnimation *fadeIn = [HLNSBKeyframeAnimation animationWithKeyPath:@"opacity" duration:self.duration startValue:fadeInfromValue endValue:fadeIntoValue function:self.easeFunction];
		
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		group.delegate = self;
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		[group setDuration:self.duration]; 
		[group setAnimations: [NSArray arrayWithObjects:animation,sizeWidth,sizeHeight,fadeIn, nil]];
		if (self.times > 0 )
		{
			group.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			group.repeatCount = HUGE_VALF;
		}
        [group setBeginTime:CACurrentMediaTime()];
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
		[self.view.layer addAnimation:group forKey:@"rotateMoveAnimation"];
		
	}
}


-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *type = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    if ([type compare:@"ANIMATION_TURNIN"] == NSOrderedSame)
    {
        self.isRevser = NO;
    }
    else
    {
        self.isRevser = YES;
    }
    [pool release];
}

-(void)keep
{
    if (self.isRevser)
    {
        self.view.layer.opacity = 0.0;
    }
    else
    {
        self.view.layer.opacity = [self.container.entity.alpha floatValue];
    }
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
