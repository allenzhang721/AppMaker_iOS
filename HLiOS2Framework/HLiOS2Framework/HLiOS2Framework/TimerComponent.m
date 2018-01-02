//
//  TimerComponent.m
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "TimerComponent.h"
#import "TimerEntity.h"
#import "HLContainer.h"

@interface TimerComponent ()
{
    int totalTime;
    int _step;
    BOOL _isLastStaticPlay;
    BOOL _isPlayOver;
    BOOL _isPaused;
    BOOL _isClean;
    BOOL _isBeginView;
}

@end

static NSString* const gobalTimerDidChangedNotification = @"gobalTimerDidChangedNotification";

@implementation TimerComponent

@synthesize display;
@synthesize timer;
@synthesize timeInterval;
@synthesize isStatic;
@synthesize isMS;

- (id)initWithEntity:(HLContainerEntity *) entity
{
    TimerEntity * te = (TimerEntity*)entity;
    self = [super init];
    if (self)
    {
        self.display = [[[UILabel alloc] init] autorelease];
        [self.display setFont:[UIFont systemFontOfSize:te.fontSize]];
        self.display.textColor  = [self colorWithHexString:te.color];
        self.display.backgroundColor = [UIColor clearColor];
        self.display.textAlignment = NSTextAlignmentCenter;
        self.uicomponent = self.display;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        self.maxValue     = te.maxValue;
        self.isStatic     = te.isStatic;
        self.isMS         = te.isMilliCount;
        self.mt           = 0;
        self.isDesOrder = te.isDesOrder;
        _isPlayOver = YES;
        _isBeginView = NO;
        _isClean = NO;
        if (self.isDesOrder)
        {
            _step = -1;
            totalTime = self.maxValue;
        }
        else
        {
            _step = 1;
            totalTime = 0;
        }
        
        if (self.isMS == YES)
        {
            self.timeInterval = 0.01;
        }
        else
        {
            self.timeInterval = 1.0;
        }
        if (!self.display.text) {
            if (self.isMS == YES)
            {
                if (self.isDesOrder)
                {
                    [self.display setText:[NSString stringWithFormat:@"%2d:00", self.maxValue]];
                }
                else
                {
                    [self.display setText:@"0:00"];
                }
            }
            else
            {
                if (self.isDesOrder)
                {
                    [self.display setText:[NSString stringWithFormat:@"%d",self.maxValue]];
                }
                else
                {
                    [self.display setText:[NSString stringWithFormat:@"%d",0]];
                }
            }
        }
    }
    
    NSLog(@"timer_maxValue:%d",self.maxValue);
    return self;
}

-(void) beginView
{
    _isBeginView = YES;
    [self loadLastStaticInfo];
    [super beginView];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (void)loadLastStaticInfo
{
    if (self.isStatic == YES)
    {
        NSDictionary *staticTimerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"StaticTimerInfo"];
        if (staticTimerInfo)
        {
            BOOL pause = [[staticTimerInfo objectForKey:@"isPaused"] boolValue];
            _isPaused = pause;
            BOOL playOver = [[staticTimerInfo objectForKey:@"isPlayOver"] boolValue];
            _isPlayOver = playOver;
            
            totalTime =  [[staticTimerInfo objectForKey:@"totalTime"] intValue];
            self.mt = [[staticTimerInfo objectForKey:@"mt"] intValue];
            if (playOver == NO)
            {
                _isLastStaticPlay = YES;
                if (pause)
                {
                    if (self.isMS == YES)
                    {
                        [self setdisplay1:totalTime];
                    }
                    else
                    {
                        [self.display setText:[NSString stringWithFormat:@"%d",totalTime]];
                    }
                }
                else
                {
                    NSDate *date = [NSDate date];
                    NSDate *lastDate = [staticTimerInfo objectForKey:@"date"];
                    float secDis = [date timeIntervalSinceDate:lastDate];
                    self.mt = [[staticTimerInfo objectForKey:@"mt"] intValue];
                    [self onTimer];
                    if (self.isDesOrder)
                    {
                        totalTime -= (int)secDis;
                        if (totalTime <= 0)
                        {
                            totalTime = self.maxValue;
                            self.mt = 0;
                        }
                        else
                        {
                            [self play];
                        }
                    }
                    else
                    {
                        totalTime += (int)secDis;
                        if (totalTime >= self.maxValue)
                        {
                            totalTime = 0;
                            self.mt = 0;
                        }
                        else
                        {
                            [self play];
                        }
                    }
                }
            }
            else
            {
                [self stopHandler];
//                if (self.containerEntity.isPlayAudioOrVideoAtBegining)
//                {
//                    [self play];
//                }
            }
        }
    }
}

-(void) play
{
    [super play];
    
    if (self.timer == nil)
    {
        if (!_isPaused && !_isLastStaticPlay)
        {
            if (self.isDesOrder)
            {
                totalTime = self.maxValue;
            }
            else
            {
                totalTime = 0;
            }
        }
        _isLastStaticPlay = NO;
        _isPaused = NO;
        _isPlayOver = NO;
        [self.display setText:[NSString stringWithFormat:@"%d",totalTime]];
        [NSThread detachNewThreadSelector:@selector(updateTimer) toTarget:self withObject:nil];
        [self.container onPlay];
    }
    else
    {
        return;
    }
}

-(void)updateTimer//NSTimer计时不准
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

-(void) clean{
    _isClean = true;
}

-(void) reset{
    _isClean = true;
    [self saveTimerInfo];
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void) pause
{
    if (self.timer != nil)
    {
        _isPaused = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void) stop
{
    if(_isClean)
    {
        if(self.isStatic != YES)
        {
            [self stopHandler];
        }
    }
    else
    {
        [self stopHandler];
    }
    _isClean = false;
}

-(void) stopHandler{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    _isPlayOver = YES;
    _isPaused = NO;
    
    totalTime = 0;
    self.mt = 0;
    if (self.isMS == YES)
    {
        if (self.isDesOrder)
        {
            [self.display setText:[NSString stringWithFormat:@"%2d:00", self.maxValue]];
        }
        else
        {
            [self.display setText:@"0:00"];
        }
    }
    else
    {
        if (self.isDesOrder)
        {
            [self.display setText:[NSString stringWithFormat:@"%d",self.maxValue]];
        }
        else
        {
            [self.display setText:[NSString stringWithFormat:@"%d", totalTime]];
        }
    }
}

-(void) onTimer
{
    if (self.isMS == YES)
    {
        self.mt += _step;
        if (self.isDesOrder)
        {
            if (self.mt <= 0)
            {
                totalTime += _step;
                if (totalTime >= 0)
                {
                    self.mt = 99;
                    [self setdisplay1:totalTime];
                }
                if (totalTime < 0)
                {
                    totalTime = 0;
                    [self setdisplay1:totalTime];
                    [self timerStop];
                }
            }
            else
            {
                [self setdisplay1:totalTime];
            }
        }
        else
        {
            if (self.mt >= 99)
            {
                totalTime += _step;
                if (totalTime <= self.maxValue)
                {
                    self.mt = 0;
                    [self setdisplay1:totalTime];
                }
                if (totalTime >= self.maxValue)
                {
                    totalTime = self.maxValue;
                    [self setdisplay1:totalTime];
                    [self timerStop];
                }
            }
            else
            {
                [self setdisplay1:totalTime];
            }
        }
    }
    else
    {
        totalTime += _step;
        if (self.isDesOrder == YES)
        {
            if (totalTime < 0)
            {
                [self timerStop];
            }
            else
            {
                [self.display setText:[NSString stringWithFormat:@"%d",totalTime]];
            }
        }
        else
        {
            if (totalTime > self.maxValue)
            {
                [self timerStop];
            }
            else
            {
                [self.display setText:[NSString stringWithFormat:@"%d",totalTime]];
            }
        }
        
    }
}

- (void)setdisplay1:(int)curTime
{
    NSString *time;
//    if (curTime < 10)
//    {
//        time = [NSString stringWithFormat:@"0%d:",curTime ];
//    }
//    else
//    {
        time = [NSString stringWithFormat:@"%d:",curTime ];
//    }
    if (self.mt < 10)
    {
        time = [time stringByAppendingFormat:@"0%d",self.mt];
    }
    else
    {
        time = [time stringByAppendingFormat:@"%d",self.mt];
    }
    [self.display setText:time];
}

- (void)setdisplayEnd:(int)curTime
{
    NSString *time;

    time = [NSString stringWithFormat:@"%d:",curTime];
    time = [time stringByAppendingFormat:@"0%d",0];
    [self.display setText:[NSString stringWithFormat:@"%@",time]];
    [self timerStop];
}

- (void)timerStop
{
    _isPlayOver = YES;
    _isPaused = NO;
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.container onPlayEnd];
    if (self.isStatic)
    {
        [TimerComponent resetGlobal];
    }
}

+(void) resetGlobal
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"StaticTimerInfo"];//全局计数器11-
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)unloadView
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self saveTimerInfo];
}

-(void) saveTimerInfo
{
    if (self.isStatic == YES && _isBeginView == YES)
    {
        
        NSDictionary *timerInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:_isPaused], @"isPaused",
                                      [NSNumber numberWithBool:_isPlayOver], @"isPlayOver",
                                      [NSNumber numberWithInt:totalTime], @"totalTime",
                                      [NSNumber numberWithInt:self.mt], @"mt",
                                      [NSDate date], @"date",nil];
        [[NSUserDefaults standardUserDefaults] setObject:timerInfoDic forKey:@"StaticTimerInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _isBeginView = NO;
}

- (void)dealloc
{
    [self.display release];
    [super dealloc];
}




@end
