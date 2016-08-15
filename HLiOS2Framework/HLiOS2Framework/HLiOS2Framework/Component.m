//
//  Component.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "HLContainer.h"
#import "HLContainerEntity.h"
@implementation Component


@synthesize uicomponent;
@synthesize container;
@synthesize hidden;
@synthesize containerEntity;
@synthesize neeedCallStop;
- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.hidden = NO;
        self.neeedCallStop = YES;
    }
    return self;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.hidden = NO;
        self.containerEntity = entity;
        self.isbyUserScale = NO;            //陈星宇，11.19，图片放大可以移动
    }
    return self;
}

-(void) beginView
{
    if (self.containerEntity.isPlayAnimationAtBegining == YES)
    {
        [self.container playAnimation:YES];
    }
    if (self.containerEntity.isPlayAudioOrVideoAtBegining == YES)
    {
        [self play];
    }
}

-(void) playAll
{
    [self.container playAnimation:YES];
    [self play];
}
-(void) show{}
-(void) hide{}
-(void) pause{}
-(void) play{}
-(void) stop{}
-(void) change:(int)index{}
-(void) clean{}

-(BOOL) onTouch
{
    BOOL isTouchup = YES;
    if (![self.container runBehavior:@"BEHAVIOR_ON_CLICK"])
    {
        isTouchup = NO;
    }
    return isTouchup;
}

-(void)onTouchBegin//added by Adward 13-11-21 for 记录回置初始位置
{
    [self.container setSpotInContainer];//modified by Adward 13-11-21 
    [self.container getComStartPoint];
}

-(BOOL) onTouchEnd
{
    self.container.isSpotTrigger = NO;
    BOOL isTouchup = YES;
    if (![self.container runBehavior:@"BEHAVIOR_ON_ENTER_SPOT"])
    {
        if(![self.container runBehavior:@"BEHAVIOR_ON_OUT_SPOT"])
        {
            isTouchup = NO;
        }
    }
    
    if ((self.container.isSpotTrigger == NO) && (self.container.entity.isStroyTelling == YES) && (self.container.entity.isPushBack == YES))//isStroyTelling 可以随手指移动
    {
        NSLog(@"bouchBack");
        [self.container bounceBack];
    }
    return isTouchup;
}

-(void) onTouchEndTouchUp   //触摸结束时
{
    [self.container runBehavior:@"BEHAVIOR_ON_MOUSE_UP"];
}

-(void) onSwipeUp
{
    [self.container runBehavior:@"BEHAVIOR_ON_SLIDER_UP"];
}

- (BOOL)onTapGesture
{
    BOOL onTap = YES;
    if (![self.container runBehavior:@"BEHAVIOR_ON_CLICK"])      //Mr.chen, 04.19.2014, 触摸开始时
    {
        onTap = NO;
        [self.container runBehavior:@"BEHAVIOR_ON_MOUSE_UP"];  // 触摸结束时
    }

    return onTap;
    
//    BOOL onTap = YES;
//    if (![self.container runBehavior:@"BEHAVIOR_ON_MOUSE_UP"])     //Mr.chen, 04.25.2014, 触摸结束时
//    {
//        onTap = NO;
//    }
//    
//    return onTap;
    
    // >>>>>  Mr.chen, 04.19.2014, case Crash
//    [self.container runBehavior:@"BEHAVIOR_ON_CLICK"];
//    [self.container runBehavior:@"BEHAVIOR_ON_MOUSE_UP"];
//    
//    return YES;
    // <<<<<
}



-(Boolean) isBusy
{
    return NO;
}

- (void)unloadView
{
    
}

- (void)dealloc 
{
//    NSLog(@"Component dealloc");
//    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
//    [self.uicomponent release];                 //陈星宇，11.4          
//    self.container = nil;                     //陈星宇，11.4
    [super dealloc];
}

@end
