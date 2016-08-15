//
//  NSBKeyframeAnimation.m
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//

#import "HLNSBKeyframeAnimation.h"

#define kFPS 60

@interface HLNSBKeyframeAnimation ()
{
    NSBKeyframeAnimationFunction f;
}

@end

@implementation HLNSBKeyframeAnimation

@synthesize completionBlock = _completionBlock;

- (id)initWithKeyPath:(NSString *)keypath
             duration:(NSTimeInterval)duration
           startValue:(double)startValue
             endValue:(double)endValue
             function:(NSBKeyframeAnimationFunction)function
{
    if ((self = [super init]))
    {
        f = function;
        
        self.keyPath = keypath;
        self.duration = duration;
        self.values = [self generateValuesFrom:startValue to:endValue];
        
        // we're already generating values at 60fps
        self.calculationMode = kCAAnimationLinear;
    }
    
    return self;
}

+ (id)animationWithKeyPath:(NSString *)keypath
                  duration:(NSTimeInterval)duration
                startValue:(double)startValue
                  endValue:(double)endValue
                  function:(NSBKeyframeAnimationFunction)function
{
    return [[[self alloc] initWithKeyPath:keypath duration:duration startValue:startValue endValue:endValue function:function] autorelease];
}

- (void)dealloc
{
    [_completionBlock release];
    
    [super dealloc];
}

#pragma mark -

- (NSArray *)generateValuesFrom:(double)startValue to:(double)endValue
{
    NSUInteger steps = (NSUInteger)ceil(kFPS * self.duration) + 2;
	
	NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:steps];
    
    const double increment = 1.0 / (double)(steps - 1);
    
    double progress = 0.0,
           v = 0.0,
           value = 0.0;
    
    NSUInteger i;
    for (i = 0; i < steps; i++)
    {
        if (f != nil)
        {
            v = f(self.duration * progress * 1000, 0, 1, self.duration * 1000);
            if(isnan(v))
            {
                value = startValue + (endValue - startValue) * progress;
            }
            else
            {
                value = startValue + v * (endValue - startValue);
            }
        }
        else
        {
            value = startValue + (endValue - startValue) * progress;
        }
        
        [valueArray addObject:[NSNumber numberWithDouble:value]];
        
        progress += increment;
    }
    
    return [NSArray arrayWithArray:valueArray];
}

#pragma mark -

- (void)setCompletionBlock:(NSBKeyframeAnimationCompletionBlock)completionBlock
{
    if (_completionBlock != completionBlock)
    {
        [_completionBlock release];
        _completionBlock = [completionBlock copy];
        
        self.delegate = self;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (self.completionBlock != nil)
    {
        self.completionBlock(finished);
        self.completionBlock = nil;
    }
}

@end
