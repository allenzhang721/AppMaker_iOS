//
//  EaseFunctionCreator.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/9/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "EaseFunctionCreator.h"


@implementation EaseFunctionCreator

+(NSBKeyframeAnimationFunction)animationFunctionForType:(NSString *) easeType
{
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInQuad"])
    {
         return NSBKeyframeAnimationFunctionEaseInQuad;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutQuad"])
    {
        return NSBKeyframeAnimationFunctionEaseOutQuad;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutQuad"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutQuad;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInCubic"])
    {
        return NSBKeyframeAnimationFunctionEaseInCubic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutCubic"])
    {
        return NSBKeyframeAnimationFunctionEaseOutCubic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutCubic"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutCubic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInQuart"])
    {
        return NSBKeyframeAnimationFunctionEaseInQuart;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutQuart"])
    {
        return NSBKeyframeAnimationFunctionEaseOutQuart;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutQuart"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutQuart;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInQuint"])
    {
        return NSBKeyframeAnimationFunctionEaseInQuint;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutQuint"])
    {
        return NSBKeyframeAnimationFunctionEaseOutQuint;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutQuint"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutQuint;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInSine"])
    {
        return NSBKeyframeAnimationFunctionEaseInSine;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutSine"])
    {
        return NSBKeyframeAnimationFunctionEaseOutSine;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutSine"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutSine;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInExpo"])
    {
        return NSBKeyframeAnimationFunctionEaseInExpo;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutExpo"])
    {
        return NSBKeyframeAnimationFunctionEaseOutExpo;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutExpo"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutExpo;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInCirc"])
    {
        return NSBKeyframeAnimationFunctionEaseInCirc;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutCirc"])
    {
        return NSBKeyframeAnimationFunctionEaseOutCirc;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutCirc"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutCirc;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInElastic"])
    {
        return NSBKeyframeAnimationFunctionEaseInElastic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutElastic"])
    {
        return NSBKeyframeAnimationFunctionEaseOutElastic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutElastic"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutElastic;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInBack"])
    {
        return NSBKeyframeAnimationFunctionEaseInBack;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutBack"])
    {
        return NSBKeyframeAnimationFunctionEaseOutBack;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutBack"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutBack;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInBounce"])
    {
        return NSBKeyframeAnimationFunctionEaseInBounce;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseOutBounce"])
    {
        return NSBKeyframeAnimationFunctionEaseOutBounce;
    }
    if ([easeType isEqualToString:@"AnimationEaseType_EaseInOutBounce"])
    {
        return NSBKeyframeAnimationFunctionEaseInOutBounce;
    }
    return nil;
}
@end































