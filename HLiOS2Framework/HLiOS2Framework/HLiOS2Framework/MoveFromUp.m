//
//  MoveFromUp.m
//  MoueeReleaseVertical
//
//  Created by user on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoveFromUp.h"
#import "HLNSBKeyframeAnimation.h"
#import "AnimationDecoder.h"

@implementation MoveFromUp
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
        float dy =  self.view.center.y - self.view.frame.origin.y;
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        self.containerRect = self.view.frame;     //Mr.chen, 06.11.2014, the frame is changed
        self.animationRect = self.view.frame;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        if (self.isRevser == YES)
        {
            fromValue = [[NSNumber numberWithFloat:self.view.layer.position.y] floatValue];
            toValue   = [[NSNumber numberWithFloat:(self.view.layer.position.y - [value floatValue])] floatValue];
            self.animationRect = CGRectMake(self.view.frame.origin.x , toValue - dy, self.view.frame.size.width , self.view.frame.size.height);
        }
        else
        {
            fromValue = [[NSNumber numberWithFloat:self.view.layer.position.y] floatValue];
            toValue   = [[NSNumber numberWithFloat:(self.view.layer.position.y + [value floatValue])] floatValue];
            self.animationRect = CGRectMake(self.view.frame.origin.x , toValue - dy, self.view.frame.size.width , self.view.frame.size.height);
        }
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
        
        HLNSBKeyframeAnimation *move = [HLNSBKeyframeAnimation animationWithKeyPath:@"position.y" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];

        
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
        fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
		fadeIn.duration  = self.duration;
        [fadeIn setFillMode:kCAFillModeForwards];
        fadeIn.removedOnCompletion =YES;
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		group.delegate = self;
		[group setDuration:self.duration]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		[group setAnimations: [NSArray arrayWithObjects:move,fadeIn,nil]];
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
		[self.view.layer addAnimation:group forKey:@"moveFromUp"];
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *typestr       = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    NSString *valuestr      = [EMTBXML textForElement:[EMTBXML childElementNamed:@"CustomProperties" parentElement:data]];
    float sx = [AnimationDecoder getSY];
    float fv = [valuestr floatValue] * sx;
    self.value  = [NSString stringWithFormat:@"%f",fv];
    if ([typestr compare:@"MOVE_DOWN"]== NSOrderedSame) 
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
