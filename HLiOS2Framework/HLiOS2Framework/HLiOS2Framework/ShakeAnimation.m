//
//  ShakeAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShakeAnimation.h"
#import "HLNSBKeyframeAnimation.h"

@implementation ShakeAnimation

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
        
        float shakefromValue = 0.0;
        float shaketoValue   = 0.0;
		NSNumber *rotation = [self.view.layer valueForKeyPath:@"transform.rotation"];
		shakefromValue = [[NSNumber numberWithFloat:((5.0f* M_PI / 180.0f)+[rotation floatValue])] floatValue];
		shaketoValue   = [rotation floatValue] - (5.0f* M_PI / 180.0f);
        
        HLNSBKeyframeAnimation *animation = [HLNSBKeyframeAnimation animationWithKeyPath:@"transform.rotation.z" duration:self.duration/4 startValue:shakefromValue endValue:shaketoValue function:self.easeFunction];
        [animation setRepeatCount:MAXFLOAT];
        [animation setAutoreverses:YES];
		CABasicAnimation *shake2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		shake2.fromValue = [NSNumber numberWithFloat:shakefromValue];
		shake2.toValue   = [NSNumber numberWithFloat:shaketoValue];
		//shake2.beginTime = self.duration / 8;
        [shake2 setRepeatCount:MAXFLOAT];
		[shake2 setDuration:self.duration / 3];
        [shake2 setAutoreverses:YES];
//		CABasicAnimation *shake3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//		shake3.fromValue = [NSNumber numberWithFloat:((-5.0f* M_PI / 180.0f)+[rotation floatValue])];
//		shake3.toValue   = [NSNumber numberWithFloat:((5.0f* M_PI / 180.0f)+[rotation floatValue])];
//		[shake3 setDuration:self.duration/ 4];
//		shake3.beginTime = (self.duration/8)*3;
//		CABasicAnimation *shake4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//		shake4.fromValue = [NSNumber numberWithFloat:((5.0f* M_PI / 180.0f)+[rotation floatValue])];
//		shake4.toValue   = [NSNumber numberWithFloat:((-5.0f* M_PI / 180.0f)+[rotation floatValue])];
//		[shake4 setDuration:self.duration/4];
//		shake4.beginTime = (self.duration/8)*5;
//		CABasicAnimation *shake5 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//		shake5.fromValue = [NSNumber numberWithFloat:((-5.0f* M_PI / 180.0f)+[rotation floatValue])];
//		shake5.toValue   = [NSNumber numberWithFloat:((0.0f* M_PI / 180.0f)+[rotation floatValue])];
//		[shake5 setDuration:self.duration/8];
//		shake5.beginTime = (self.duration/8)*7;
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
        group.delegate = self;
		[group setDuration:self.duration]; 
		[group setAnimations: [NSArray arrayWithObjects:animation, nil]];
		if (self.times > 0 )
		{
			group.repeatCount = self.times;
		}
		if ((self.isLoop == YES) || (self.times == 0))
		{
			group.repeatCount = HUGE_VALF;
		}
        [group setBeginTime:CACurrentMediaTime()];
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
		[self.view.layer addAnimation:group forKey:@"shakeAnimation"];
        self.view.layer.opacity = 1.0;
	}
}

-(void)reset//modified by Adward 13-12-27
{
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    [self.view.layer removeAllAnimations];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

@end
