//
//  FadeInAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FadeInAnimation.h"
#import "HLNSBKeyframeAnimation.h"


@implementation FadeInAnimation

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}


-(void) playHandler
{

//    for (Container *item in self.container.pageController.objects) {
//        NSLog(@"%@",item.entity.animations);
//    }
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
	
		if (self.isRevser)
		{
            fromValue        = [self.container.entity.alpha floatValue];
            toValue          = 0.0;
		}
		else
		{
            fromValue        = 0.0;
            toValue          = [self.container.entity.alpha floatValue];
		}
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        self.animationRect = self.view.frame;
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
        
        HLNSBKeyframeAnimation *fadeIn = [HLNSBKeyframeAnimation animationWithKeyPath:@"opacity" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
        fadeIn.delegate = self;
		if (self.times > 0 )
		{
			fadeIn.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			fadeIn.repeatCount = HUGE_VALF;
		}
        [fadeIn setFillMode:kCAFillModeForwards];
        fadeIn.removedOnCompletion =NO;
        [fadeIn setBeginTime:CACurrentMediaTime()];
		[self.view.layer addAnimation:fadeIn forKey:@"fadein"];
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *type = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    if ([type compare:@"ANIMATION_FADEIN"] == NSOrderedSame)
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
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
    [self.view.layer removeAllAnimations];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

- (void)dealloc
{
    [super dealloc];
}

@end
