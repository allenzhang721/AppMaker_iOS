//
//  RotateAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RotateAnimation.h"
#import "HLNSBKeyframeAnimation.h"

@implementation RotateAnimation

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
        
        CATransform3D transform = CATransform3DIdentity;    //陈星宇，12.19， 透视效果
        float fromValue = 0.0;
        float toValue   = 0.0;
        if (self.isRevser)
        {
            fromValue = [[NSNumber numberWithFloat:M_PI*2] floatValue];
            toValue   = [[NSNumber numberWithFloat:-M_PI] floatValue];
            transform.m34 = -0.002; //陈星宇，12.19， 透视效果
        }
        else
        {
            fromValue = [[NSNumber numberWithFloat:M_PI] floatValue];
            toValue   = [[NSNumber numberWithFloat:-M_PI * 2] floatValue];
            transform.m34 = 0.002; //陈星宇，12.19， 透视效果
        }
       
        HLNSBKeyframeAnimation *animation = [HLNSBKeyframeAnimation animationWithKeyPath:@"transform.rotation.y" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
        float fadeInfromValue = 0.0;
        float fadeIntoValue   = 0.0;
	
		if (self.isRevser)
		{
			fadeInfromValue         = [[NSNumber numberWithFloat:[self.container.entity.alpha floatValue]] floatValue];
			fadeIntoValue           = [[NSNumber numberWithFloat:0.0f] floatValue];
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
        transform = CATransform3DRotate(transform, [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue], 0, 0, 1);   //陈星宇，12.19， 旋转角度
        self.view.layer.transform = transform;  //陈星宇，12.19， 透视效果
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
		[self.view.layer addAnimation:group forKey:@"rotateAnimation"];
        self.view.layer.zPosition = 250000;
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *type = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    if ([type compare:@"ANIMATION_ROTATEIN"] == NSOrderedSame) 
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
//    self.container.component.uicomponent.layer.opacity = [self.container.entity.alpha floatValue];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

@end
