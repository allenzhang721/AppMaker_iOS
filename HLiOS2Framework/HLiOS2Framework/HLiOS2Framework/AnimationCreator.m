//
//  AnimationCreator.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-16.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "AnimationCreator.h"
#import "FadeInAnimation.h"
#import "MoveFromBottomFadeInAnimation.h"
#import "RotateMoveInAnimation.h"
#import "RotateAnimation.h"
#import "ScaleAnimation.h"
#import "RotateAnimation.h"
#import "ShakeAnimation.h"
#import "ClockRotateAnimation.h"
#import "CustomScaleAnimation.h"
#import "MoveFromTopFadeInAnimation.h"
#import "MoveFromLeftFadeInAnimation.h"
#import "MoveFromRightFadeInAnimation.h"
#import "MoveFromUp.h"
#import "MoveFromRight.h"
#import "WipeAnimation.h"
#import "AdvanceAnimation.h"


@implementation AnimationCreator
+(Animation *)  createAnimation:(NSString *) classType
{
    if (([classType compare:@"ANIMATION_FADEIN"] == NSOrderedSame)||([classType compare:@"ANIMATION_FADEOUT"] == NSOrderedSame))
    {
       return  [[FadeInAnimation alloc]init];
    }
    if (([classType compare:@"FLOATIN_UP"] == NSOrderedSame)||(([classType compare:@"FLOATOUT_UP"] == NSOrderedSame)))
    {
       return  [[MoveFromBottomFadeInAnimation alloc]init];
    }
    if (([classType compare:@"ANIMATION_TURNIN"] == NSOrderedSame) ||([classType compare:@"ANIMATION_TURNOUT"] == NSOrderedSame))
    {
        return  [[RotateMoveInAnimation alloc]init];
    }
    if (([classType compare:@"ANIMATION_ZOOMOUT"] == NSOrderedSame) ||([classType compare:@"ANIMATION_ZOOMIN"] == NSOrderedSame))
    {
       return   [[ScaleAnimation alloc]init];
    }
    if (([classType compare:@"ANIMATION_ROTATEIN"] == NSOrderedSame) ||([classType compare:@"ANIMATION_ROTATEOUT"] == NSOrderedSame))
    {
       return  [[RotateAnimation alloc]init];
    }
    if ([classType compare:@"ANIMATION_SEESAW"] == NSOrderedSame)
    {
        return  [[ShakeAnimation alloc]init];
    }
    if ([classType compare:@"ANIMATION_SPIN"] == NSOrderedSame)
    {
        return [[ClockRotateAnimation alloc]init];
    }
    if (([classType compare:@"SCALE_HORZ"] == NSOrderedSame)||([classType compare:@"SCALE_VERT"] == NSOrderedSame)||([classType compare:@"SCALE_ALL"] == NSOrderedSame))
    {
        return [[CustomScaleAnimation alloc]init];
    }
    if(([classType compare:@"FLOATIN_DOWN"]== NSOrderedSame)||([classType compare:@"FLOATOUT_DOWN"]== NSOrderedSame))
    {
        return [[MoveFromTopFadeInAnimation alloc]init];
    }
    if(([classType compare:@"FLOATIN_LEFT"]== NSOrderedSame)||([classType compare:@"FLOATOUT_LEFT"]== NSOrderedSame))
    {
        return [[MoveFromLeftFadeInAnimation alloc]init];
    }
    if(([classType compare:@"FLOATIN_RIGHT"]== NSOrderedSame)||([classType compare:@"FLOATOUT_RIGHT"]== NSOrderedSame))
    {
        return [[MoveFromRightFadeInAnimation alloc]init];
    }
    if(([classType compare:@"MOVE_DOWN"]== NSOrderedSame) || ([classType compare:@"MOVE_UP"]== NSOrderedSame))
    {
        return [[MoveFromUp alloc]init];
    }
    if(([classType compare:@"MOVE_LEFT"]== NSOrderedSame) || ([classType compare:@"MOVE_RIGHT"]== NSOrderedSame))
    {
       return  [[MoveFromRight alloc]init];
    }
    if([classType compare:@"ANIMATION_SENIOR"]== NSOrderedSame)
    {
        return  [[AdvanceAnimation alloc]init];
    }
    if(([classType compare:@"WIPEOUT_UP"]== NSOrderedSame)||([classType compare:@"WIPEOUT_DOWN"]== NSOrderedSame)|| ([classType compare:@"WIPEOUT_LEFT"]== NSOrderedSame)|| ([classType compare:@"WIPEOUT_RIGHT"]== NSOrderedSame) )
    {
       return [[WipeAnimation alloc] init];
    }
    return [[Animation alloc] init];
}
@end
