//
//  MoveFromBottomFadeInAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoveFromBottomFadeInAnimation.h"
#import "HLNSBKeyframeAnimation.h"
#import "AnimationDecoder.h"

@implementation MoveFromBottomFadeInAnimation
@synthesize value;

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
        self.containerRect = self.view.frame;
        self.animationRect = self.view.frame;
        if (self.isRevser)
        {
            fromValue = [[NSNumber numberWithFloat:self.view.layer.position.y] floatValue];
            toValue   = [[NSNumber numberWithFloat:(self.view.layer.position.y - [value floatValue])] floatValue];
        }
        else
        {
            fromValue = [[NSNumber numberWithFloat:(self.view.layer.position.y + [value floatValue])] floatValue];
            toValue   = [[NSNumber numberWithFloat:self.view.layer.position.y] floatValue];
        }
      
        HLNSBKeyframeAnimation *animation = [HLNSBKeyframeAnimation animationWithKeyPath:@"position.y" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
        
        float fadeInfromValue = 0.0;
        float fadeIntoValue   = 0.0;
        
		if (self.isRevser)
		{
			fadeInfromValue = [[NSNumber numberWithFloat:[self.container.entity.alpha floatValue]] floatValue];
			fadeIntoValue   = [[NSNumber numberWithFloat:0.0f] floatValue];
		}
		else
		{
			fadeInfromValue  = [[NSNumber numberWithFloat:0.0f] floatValue];
			fadeIntoValue    = [[NSNumber numberWithFloat:[self.container.entity.alpha floatValue]] floatValue];
		}
        
        HLNSBKeyframeAnimation *fadeIn = [HLNSBKeyframeAnimation animationWithKeyPath:@"opacity" duration:self.duration startValue:fadeInfromValue endValue:fadeIntoValue function:self.easeFunction];

		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		group.delegate = self;
		[group setDuration:self.duration]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		[group setAnimations: [NSArray arrayWithObjects:animation,fadeIn,nil]];
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
        self.containerRect = self.view.frame;
        self.animationRect = self.view.frame;
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
		[self.view.layer addAnimation:group forKey:@"moveFromBottomFadeIn"];
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    float sy = [AnimationDecoder getSY];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *valuestr     = [EMTBXML textForElement:[EMTBXML childElementNamed:@"CustomProperties" parentElement:data]];
    float fv = [valuestr floatValue] * sy;
    self.value  = [NSString stringWithFormat:@"%f",fv];
    NSString *type = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    if ([type compare:@"FLOATIN_UP"] == NSOrderedSame)
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
    self.view.frame = self.containerRect;
    [self.view.layer removeAllAnimations];
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;

}

-(void)dealloc
{
    [self.view.layer removeAnimationForKey:@"moveFromBottomFadeIn"];//modified by Adward 13-12-25 有浮入和浮出时 浮出不播放
    [super dealloc];
}


@end
