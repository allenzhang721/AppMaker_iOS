//
//  MoveFromRight.m
//  MoueeReleaseVertical
//
//  Created by user on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoveFromRight.h"
#import "HLNSBKeyframeAnimation.h"
#import "AnimationDecoder.h"

@implementation MoveFromRight
@synthesize value;
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
        float dx =  self.view.center.x - self.view.frame.origin.x;
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        self.containerRect = self.view.frame;
        self.animationRect = self.view.frame;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        if (self.isRevser == NO)
        {
            fromValue = [[NSNumber numberWithFloat:self.view.layer.position.x] floatValue];
            toValue = [[NSNumber numberWithFloat:(self.view.layer.position.x - [value floatValue])] floatValue];
            self.animationRect = CGRectMake(toValue - dx , self.view.frame.origin.y, self.view.frame.size.width , self.view.frame.size.height);
        }
        else
        {
            fromValue      = [[NSNumber numberWithFloat:self.view.layer.position.x] floatValue];
            toValue        = [[NSNumber numberWithFloat:(self.view.layer.position.x + [value floatValue])] floatValue];
            self.animationRect = CGRectMake(toValue - dx , self.view.frame.origin.y, self.view.frame.size.width , self.view.frame.size.height);
            
        }
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
        HLNSBKeyframeAnimation *animation = [HLNSBKeyframeAnimation animationWithKeyPath:@"position.x" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
       
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
        fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
		fadeIn.duration  = self.duration;
        [fadeIn setFillMode:kCAFillModeForwards];
        fadeIn.removedOnCompletion =NO;
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		group.delegate = self;
		[group setDuration:self.duration]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion = NO;
		[group setAnimations: [NSArray arrayWithObjects:animation,fadeIn, nil]];

		if (self.times > 0 )
		{
			group.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			group.repeatCount = HUGE_VALF;
		}
        [group setBeginTime:CACurrentMediaTime()];
		[self.view.layer addAnimation:group forKey:@"moveFromRight"];
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *typestr       = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    NSString *valuestr      = [EMTBXML textForElement:[EMTBXML childElementNamed:@"CustomProperties" parentElement:data]];
    float sx = [AnimationDecoder getSX];
    float fv = [valuestr floatValue] * sx;
    self.value  = [NSString stringWithFormat:@"%f",fv];
    if ([typestr compare:@"MOVE_LEFT"]== NSOrderedSame) 
    {
        self.isRevser = NO;
    }
    else
    {
        self.isRevser = YES;
    }
    [pool release];
}


-(void)reset//modified by Adward 13-12-27
{
    self.view.frame = self.containerRect;
    [self.view.layer removeAllAnimations];
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
    
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

@end
