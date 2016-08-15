//
//  WipeAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WipeAnimation.h"

@implementation WipeAnimation
@synthesize aspect;
@synthesize isWipeOut;
@synthesize lastPlayDate;

-(void) playHandler
{
    //added by Adward 13-11-22
    self.lastPlayDate = [NSDate date];
    
    if (self.isPaused == YES)
    {
        [super playHandler];
        return;
    }
    [super playHandler];
    
    if (self.view != nil) 
    {
        
        self.containerRect = self.view.frame;
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        self.animationRotation = self.containerRotation;
        self.animationRect = self.view.frame;
        if (([self.aspect compare:@"UP"] == NSOrderedSame) )
        {
            if (self.isWipeOut == YES) 
            {
                CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.y"];
                move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.y+self.view.layer.frame.size.height];
                move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.y )];
                move.duration  =self.duration;
                CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.y"];
                contentMove.fromValue = [NSNumber numberWithFloat:1.0f]; 
                contentMove.toValue   = [NSNumber numberWithFloat:0.0f]; 
                contentMove.duration  = self.duration;
                CAAnimationGroup *group = [CAAnimationGroup animation]; 
                group.delegate = self;
                [group setDuration:self.duration]; 
                [group setFillMode:kCAFillModeForwards];
                group.removedOnCompletion =NO;
                [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                if (self.times > 0 )
                {
                    group.repeatCount = self.times;
                }
                if (self.isLoop == YES) 
                {
                    group.repeatCount = HUGE_VALF;
                }
                [group setBeginTime:CACurrentMediaTime()];
                [self.view.layer addAnimation:group forKey:@"Wipe"];
            }
            else
            {
                CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.y"];
                move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.y];
                move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.y +self.view.layer.frame.size.height)];
                move.duration  = self.duration;
                CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.y"];
                contentMove.fromValue = [NSNumber numberWithFloat:0.0f]; 
                contentMove.toValue   = [NSNumber numberWithFloat:1.0f]; 
                contentMove.duration  = self.duration;
                CAAnimationGroup *group = [CAAnimationGroup animation]; 
                group.delegate = self;
                [group setDuration:self.duration]; 
                [group setFillMode:kCAFillModeForwards];
                group.removedOnCompletion = NO;
                [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                if (self.times > 0 )
                {
                    group.repeatCount = self.times;
                }
                if (self.isLoop == YES)
                {
                    group.repeatCount = HUGE_VALF;
                }
                [group setBeginTime:CACurrentMediaTime()];
                [self.view.layer addAnimation:group forKey:@"Wipe"];
            }
            
        }
        else
        {
            if (([self.aspect compare:@"DOWN"] == NSOrderedSame))
            {
                if (self.isWipeOut == YES) 
                {
                    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.y"];
                    move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.y-self.view.layer.frame.size.height];
                    move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.y )];
                    move.duration  =self.duration;
                    CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.y"];
                    contentMove.fromValue = [NSNumber numberWithFloat:-1.0f]; 
                    contentMove.toValue   = [NSNumber numberWithFloat:0.0f]; 
                    contentMove.duration  = self.duration;
                    CAAnimationGroup *group = [CAAnimationGroup animation]; 
                    group.delegate = self;
                    [group setDuration:self.duration]; 
                    [group setFillMode:kCAFillModeForwards];
                    group.removedOnCompletion =NO;
                    [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                    if (self.times > 0 )
                    {
                        group.repeatCount = self.times;
                    }
                    if (self.isLoop == YES) 
                    {
                        group.repeatCount = HUGE_VALF;
                    }
                    [group setBeginTime:CACurrentMediaTime()];
                    [self.view.layer addAnimation:group forKey:@"Wipe"];
                }
                else
                {
                    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.y"];
                    move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.y];
                    move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.y -self.view.layer.frame.size.height)];
                    move.duration  =self.duration;
                    CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.y"];
                    contentMove.fromValue = [NSNumber numberWithFloat:0.0f]; 
                    contentMove.toValue   = [NSNumber numberWithFloat:-1.0f]; 
                    contentMove.duration  = self.duration;
                    CAAnimationGroup *group = [CAAnimationGroup animation]; 
                    group.delegate = self;
                    [group setDuration:self.duration]; 
                    [group setFillMode:kCAFillModeForwards];
                    group.removedOnCompletion =NO;
                    [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                    if (self.times > 0 )
                    {
                        group.repeatCount = self.times;
                    }
                    if (self.isLoop == YES) 
                    {
                        group.repeatCount = HUGE_VALF;
                    }
                    [group setBeginTime:CACurrentMediaTime()];
                    [self.view.layer addAnimation:group forKey:@"Wipe"];
                }
                
            }
            else
            {
                if (([self.aspect compare:@"LEFT"] == NSOrderedSame))
                {
                    if(self.isWipeOut == YES)
                    {
                        CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
                        move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x+ self.view.layer.frame.size.width];
                        move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x )];
                        move.duration  = self.duration;
                        CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.x"];
                        contentMove.fromValue = [NSNumber numberWithFloat:1.0f]; 
                        contentMove.toValue   = [NSNumber numberWithFloat:0.0f]; 
                        contentMove.duration  = self.duration;
                        CAAnimationGroup *group = [CAAnimationGroup animation]; 
                        group.delegate = self;
                        [group setDuration:self.duration]; 
                        [group setFillMode:kCAFillModeForwards];
                        group.removedOnCompletion =NO;
                        [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                        if (self.times > 0 )
                        {
                            group.repeatCount = self.times;
                        }
                        if (self.isLoop == YES) 
                        {
                            group.repeatCount = HUGE_VALF;
                        }
                        [group setBeginTime:CACurrentMediaTime()];
                        [self.view.layer addAnimation:group forKey:@"Wipe"];
                    }
                    else
                    {
                        CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
                        move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x];
                        move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x + self.view.layer.frame.size.width)];
                        move.duration  = self.duration;
                        CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.x"];
                        contentMove.fromValue = [NSNumber numberWithFloat:0.0f]; 
                        contentMove.toValue   = [NSNumber numberWithFloat:1.0f]; 
                        contentMove.duration  = self.duration;
                        CAAnimationGroup *group = [CAAnimationGroup animation]; 
                        group.delegate = self;
                        [group setDuration:self.duration]; 
                        [group setFillMode:kCAFillModeForwards];
                        group.removedOnCompletion =NO;
                        [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                        if (self.times > 0 )
                        {
                            group.repeatCount = self.times;
                        }
                        if (self.isLoop == YES) 
                        {
                            group.repeatCount = HUGE_VALF;
                        }
                        [group setBeginTime:CACurrentMediaTime()];
                        [self.view.layer addAnimation:group forKey:@"Wipe"];
                    }
                }
                else
                {
                    if (([self.aspect compare:@"RIGHT"] == NSOrderedSame) )
                    {
                        if (self.isWipeOut == YES)
                        {
                            CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
                            move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x- self.view.layer.frame.size.width];
                            move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x )];
                            move.duration  = self.duration;
                            CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.x"];
                            contentMove.fromValue = [NSNumber numberWithFloat:-1.0f]; 
                            contentMove.toValue   = [NSNumber numberWithFloat:0.0f]; 
                            contentMove.duration  = self.duration;
                            CAAnimationGroup *group = [CAAnimationGroup animation]; 
                            group.delegate = self;
                            [group setDuration:self.duration]; 
                            [group setFillMode:kCAFillModeForwards];
                            group.removedOnCompletion =NO;
                            [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                            if (self.times > 0 )
                            {
                                group.repeatCount = self.times;
                            }
                            if (self.isLoop == YES) 
                            {
                                group.repeatCount = HUGE_VALF;
                            }
                            [group setBeginTime:CACurrentMediaTime()];
                            [self.view.layer addAnimation:group forKey:@"Wipe"];
                        }
                        else
                        {
                            CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
                            move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x];
                            move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x - self.view.layer.frame.size.width)];
                            move.duration  = self.duration;
                            CABasicAnimation *contentMove = [CABasicAnimation animationWithKeyPath:@"contentsRect.origin.x"];
                            contentMove.fromValue = [NSNumber numberWithFloat:0.0f]; 
                            contentMove.toValue   = [NSNumber numberWithFloat:-1.0f]; 
                            contentMove.duration  = self.duration;
                            CAAnimationGroup *group = [CAAnimationGroup animation]; 
                            group.delegate = self;
                            [group setDuration:self.duration]; 
                            [group setFillMode:kCAFillModeForwards];
                            group.removedOnCompletion =NO;
                            [group setAnimations: [NSArray arrayWithObjects:move,contentMove,nil]];
                            if (self.times > 0 )
                            {
                                group.repeatCount = self.times;
                            }
                            if (self.isLoop == YES) 
                            {
                                group.repeatCount = HUGE_VALF;
                            }
                            [group setBeginTime:CACurrentMediaTime()];
                            [self.view.layer addAnimation:group forKey:@"Wipe"];
                        }
                        
                    }
                }
            }
        }
    }
    
}

-(void) onAnimationStart
{
//    [super onAnimationStart];
   self.container.component.uicomponent.layer.opacity = [self.container.entity.alpha floatValue];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //播放时点击再次播放，触发Stop一次，再次播放完毕又执行Stop,监测两次播放的时间差，如果小于动画时间，就停止一次Stop
    //added by Adward 13-11-22
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:self.lastPlayDate];
    if(interval < self.duration)
        return;
    //////////
    [super animationDidStop:theAnimation finished:flag];
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *typestr       = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
    NSString *valuestr      = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationEnterOrQuit" parentElement:data]];
    if(([typestr compare:@"WIPEOUT_UP"]== NSOrderedSame))
    {
        if ([valuestr compare:@"OUT_FLAG"] == NSOrderedSame)
        {
            self.isWipeOut = NO;
        }
        else
        {
            self.isWipeOut = YES;
        }
        self.aspect        = @"UP";
    }
    if(([typestr compare:@"WIPEOUT_DOWN"]== NSOrderedSame))
    {
        if ([valuestr compare:@"OUT_FLAG"] == NSOrderedSame)
        {
            self.isWipeOut = NO;
        }
        else
        {
            self.isWipeOut = YES;
        }
        self.aspect    = @"DOWN";
    }
    if(([typestr compare:@"WIPEOUT_LEFT"]== NSOrderedSame))
    {
        if ([valuestr compare:@"OUT_FLAG"] == NSOrderedSame)
        {
            self.isWipeOut = NO;
        }
        else
        {
            self.isWipeOut = YES;
        }
        self.aspect    = @"LEFT";
    }
    if(([typestr compare:@"WIPEOUT_RIGHT"]== NSOrderedSame))
    {
        if ([valuestr compare:@"OUT_FLAG"] == NSOrderedSame)
        {
            self.isWipeOut = NO;
        }
        else
        {
            self.isWipeOut = YES;
        }
        self.aspect    = @"RIGHT";
    }
    [pool release];
}

-(void)keep
{
    if (self.isWipeOut == NO)
    {
        self.view.hidden = YES;
    }
}

-(void)reset//modified by Adward 13-12-27
{
    [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
    self.view.frame = self.containerRect;
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    [self.view.layer removeAllAnimations];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

- (void)dealloc
{
    self.aspect = nil;
    [super dealloc];
}

@end
