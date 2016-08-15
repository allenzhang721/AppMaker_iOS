//
//  CustomScaleAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomScaleAnimation.h"
#import "HLNSBKeyframeAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomScaleAnimation

@synthesize type;
@synthesize aspect;
@synthesize widthScale;
@synthesize heightScale;
@synthesize centernPoint;

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
        
		if ([self.aspect compare:@"BOTH"] == NSOrderedSame) 
		{
			widthScale  = 1.0f;
			heightScale = 1.0f;
		}
		else 
		{
			if ([self.aspect compare:@"WIDTH"] == NSOrderedSame) 
			{
				widthScale  = 1.0f;
				heightScale = -1.0f;
			}
			else 
			{
                widthScale  = -1.0f;
                heightScale = 1.0f;
			}
		}
		
		if ([self.type compare:@"MIN"] == NSOrderedSame)
		{
			if (widthScale > 0) 
			{
				widthScale = widthScale/3;
			}
			if (heightScale > 0 ) 
			{
				heightScale = heightScale/3;
			}
		}
		else 
		{
			if ([self.type compare:@"MINMAX"] == NSOrderedSame)
			{
				if (widthScale > 0) 
				{
					widthScale = widthScale/6;
				}
				if (heightScale > 0 ) 
				{
					heightScale = heightScale/6;
				}
			}
			else
			{
				if ([self.type compare:@"MAX"] == NSOrderedSame)
				{
					if (widthScale > 0) 
					{
						widthScale = widthScale*3;
					}
					if (heightScale > 0 ) 
					{
						heightScale = heightScale*3;
					}
				}
				else
				{
                    if ([self.type compare:@"MAXMAX"] == NSOrderedSame)
                    {
                        if (widthScale > 0) 
                        {
                            widthScale = widthScale*6;
                        }
                        if (heightScale > 0 ) 
                        {
                            heightScale = heightScale*6;
                        }
                    }
                    else
                    {
                        float fscale = [self.type floatValue];
                        if (widthScale > 0) 
                        {
                            widthScale = widthScale*fscale;
                        }
                        if (heightScale > 0 ) 
                        {
                            heightScale = heightScale*fscale;
                        }
                    }
					
				}
			}
            
		}
		if (widthScale < 0.0f) 
		{
			widthScale = 1.0f;
		}
		if (heightScale < 0.0f ) 
		{
			heightScale = 1.0f;
		}
        
        float sizeWidthfromValue = 0.0;
        float sizeWidthtoValue   = 0.0;
		sizeWidthfromValue         = [[NSNumber numberWithFloat:self.view.layer.bounds.size.width] floatValue];
		sizeWidthtoValue           = [[NSNumber numberWithFloat:self.view.layer.bounds.size.width*widthScale] floatValue];
        HLNSBKeyframeAnimation *sizeWidth = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.width" duration:self.duration startValue:sizeWidthfromValue endValue:sizeWidthtoValue function:self.easeFunction];
        
        float sizeHeightfromValue = 0.0;
        float sizeHeighttoValue   = 0.0;
		sizeHeightfromValue         = [[NSNumber numberWithFloat:self.view.layer.bounds.size.height] floatValue];
		sizeHeighttoValue           = [[NSNumber numberWithFloat:self.view.layer.bounds.size.height*heightScale] floatValue];
        HLNSBKeyframeAnimation *sizeHeight = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.height" duration:self.duration startValue:sizeHeightfromValue endValue:sizeHeighttoValue function:self.easeFunction];
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        self.containerRect = self.view.frame;
        self.animationRect = CGRectMake(self.animationRect.origin.x, self.animationRect.origin.y, sizeWidthtoValue, sizeHeighttoValue);
        self.centernPoint  = self.view.center;
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation]forKeyPath:@"transform.rotation"];
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
        fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
		fadeIn.duration  = self.duration;
        [fadeIn setFillMode:kCAFillModeForwards];
        fadeIn.removedOnCompletion =NO;
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		[group setDuration:self.duration]; 
		[group setAnimations: [NSArray arrayWithObjects:sizeWidth,sizeHeight,fadeIn,nil]];
		group.delegate = self;
		if (self.times > 0 )
		{
			group.repeatCount = self.times;
		}
		if (self.isLoop == YES) 
		{
			group.repeatCount = HUGE_VALF;
		}
        [group setBeginTime:CACurrentMediaTime()];
		[self.view.layer addAnimation:group forKey:@"custiomScaleAnimation"];
        
		
	}
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *typestr = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    if (([typestr compare:@"SCALE_HORZ"] == NSOrderedSame)||([typestr compare:@"SCALE_VERT"] == NSOrderedSame)||([typestr compare:@"SCALE_ALL"] == NSOrderedSame))
    {
        NSString *value     = [EMTBXML textForElement:[EMTBXML childElementNamed:@"CustomProperties" parentElement:data]];
        if ([value compare:@"Min"] == NSOrderedSame)
        {
            self.type = @"MIN";
        }
        else
        {
            if ([value compare:@"Max"] == NSOrderedSame)
            {
                self.type = @"MAX";
            }
            else
            {
                if ([value compare:@"MinMax"] == NSOrderedSame)
                {
                    self.type = @"MINMAX";
                }
                else
                {
                    if ([value compare:@"MaxMax"] == NSOrderedSame)
                    {
                        self.type = @"MAXMAX";
                    }
                    else
                    {
                        self.type = value;
                    }
                }
            }
        }
    }
    if ([typestr compare:@"SCALE_HORZ"] == NSOrderedSame)
    {
        self.aspect = @"WIDTH";
    }
    else
    {
        if ([typestr compare:@"SCALE_ALL"] == NSOrderedSame)
        {
            self.aspect = @"BOTH";
        }
        else
        {
            self.aspect = @"Height";
        }
    }
    [pool release];
}


-(void)reset//modified by Adward 13-12-27
{
    [self.view.layer removeAllAnimations];
    self.view.frame = self.containerRect;
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;

}

@end
