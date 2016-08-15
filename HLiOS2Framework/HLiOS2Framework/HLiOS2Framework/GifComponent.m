//
//  GifComponent.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GifComponent.h"
#import "HLContainer.h"
#import "HLImage.h"

@implementation GifComponent
@synthesize time;
@synthesize isLoop;
@synthesize imgs;
@synthesize timer;
@synthesize rootpath;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.isLoop = YES;
    }
    return self;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        isFirst = YES;
        isPlaying = NO;
        isPaused = NO;
        self.rootpath = entity.rootPath;
        self.imgs = ((GifEntity*)entity).images;
        NSString *imagePath = [((GifEntity*)entity).images objectAtIndex:0];
        imagePath = [entity.rootPath stringByAppendingPathComponent:imagePath];
        HLImage *imageView  = [[HLImage alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        imageView.isEnableMoveable = ((GifEntity*)entity).isStroyTelling;
        interval = ((GifEntity*)entity).duration / 1000;
        if ([self.imgs count] > 0)
        {
            interval = interval / [self.imgs count];
        }
        imageView.com               = self;
        self.isLoop                 = ((GifEntity*)entity).isLoop;
        self.time = ((GifEntity*)entity).duration / 1000;
        self.uicomponent = imageView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        [imageView release];
        currentIndex = 0;
        //        delayTime = entity.;
    }
    return self;
}



-(void) play
{
    if (!isPlaying)
    {
        timerstoped = NO;
        //    currentIndex = 0;
        [self performSelector:@selector(runTimer) withObject:nil afterDelay:0];
        if (!self.isLoop)
        {
            //        ((UIImageView*)self.uicomponent).animationRepeatCount = 1;
        }
        //    [((UIImageView*)self.uicomponent) startAnimating];
        [self performSelector:@selector(delayPlay) withObject:nil afterDelay:self.time];
        [self.container onPlay];
        isPlaying = YES;
        isPaused = NO;
    }
}

- (void)delayPlay
{
    
}

- (void)runTimer
{
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void) playEnd
{
    isFirst = NO;
    isPlaying = NO;
    isPaused = NO;
    [self.container onPlayEnd];
}

-(void) pause
{
    timerstoped = YES;
    isPaused = YES;
    isPlaying = NO;
    [super pause];
}

-(void) stop
{
    //    [((UIImageView*)self.uicomponent) stopA   nimating];
    if (isPaused || isPlaying)
    {
        if (self.timer && [self.timer isValid])
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        timerstoped = YES;
        isPlaying = NO;
        currentIndex = 0;
        NSString *imagePath = [self.imgs objectAtIndex:0];
        imagePath = [self.rootpath stringByAppendingPathComponent:imagePath];
        ((HLImage*)self.uicomponent).image = [UIImage imageWithContentsOfFile:imagePath];
        [super stop];
    }
}

-(void)timerUpdate:(id)sender
{
    if (timerstoped)
    {
        return;
    }
    NSString *imagePath = [self.imgs objectAtIndex:currentIndex];
    imagePath = [self.rootpath stringByAppendingPathComponent:imagePath];
    ((HLImage*)self.uicomponent).image = [UIImage imageWithContentsOfFile:imagePath];
    currentIndex++;
    //    if (currentIndex >= [self.imgs count])
    //    {
    //        currentIndex = [self.imgs count] - 1;
    //    }
    //
    if (!self.isLoop && currentIndex  > [self.imgs count] - 1)//不循环的保留在最后一帧
    {
        currentIndex = 0;
        timerstoped = YES;
        if (isFirst || !self.isLoop)
        {
            [self playEnd];
        }
    }
    if (self.isLoop && currentIndex  > [self.imgs count] - 1) {
        timerstoped = NO;
        currentIndex = 0;
        //        if (isFirst)
        //        {
        //            [self playEnd];
        //        }
    }
}

- (void)unloadView
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc
{
    [self.imgs release];
    [self.uicomponent removeFromSuperview]; //陈星宇，11.4
	[self.uicomponent release];
    [super dealloc];
}



@end
