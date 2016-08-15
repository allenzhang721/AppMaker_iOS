//
//  VideoComponent.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoComponent.h"
#import "VideoEntity.h"
#import "HLContainer.h"
#import "HLReachability.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static BOOL isExist = NO;

@implementation VideoComponent
@synthesize busy;
@synthesize player;
@synthesize filepath;
//added by Adward 13-11-07
@synthesize isOnlineVideo;
@synthesize tag;
@synthesize superView;//added by Adward

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity = (VideoEntity *)entity;
        isFirstTime = YES;
        isFirstDelay = YES;
        
        showControlBar = ((VideoEntity*)entity).showControlBar;
        self.uicomponent = [[[UIView alloc] initWithFrame:CGRectMake([entity.x floatValue], [entity.y floatValue], [entity.width floatValue], [entity.height floatValue])] autorelease];
        self.uicomponent.userInteractionEnabled = YES;
        self.uicomponent.backgroundColor     = [UIColor clearColor];
//        self.uicomponent.hidden              = YES;//modified by Adward 13-11-08
        
        //added by Adward 13-11-07
        self.isOnlineVideo = self.entity.isOnlineVideo;
        
        self.filepath = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)] autorelease]];
        
        videoCoverImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])] autorelease];
        videoCoverImg.userInteractionEnabled = NO;
        if (self.entity.coverName != nil && ![self.entity.coverName isEqualToString:@""])       //陈星宇，12.9
        {
            NSString *coverPath = [entity.rootPath stringByAppendingPathComponent :self.entity.coverName];
            if(coverPath)//用户设置视频封面 Adward 13-11-13
            {
                videoCoverImg.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:coverPath]];
            }
        }
        else//没有的话用默认
        {
            videoCoverImg.image = [UIImage imageNamed:@"Video.png"];
        }
        
        [self.uicomponent addSubview:videoCoverImg];
        
        videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoPlayBtn setFrame:CGRectMake((self.uicomponent.frame.size.width - 60) / 2, (self.uicomponent.frame.size.height - 60) / 2, 60, 60)];
        [videoPlayBtn setImage:[UIImage imageNamed:@"audio_play.png"] forState:UIControlStateNormal];
        [videoPlayBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.uicomponent addSubview:videoPlayBtn];
        
        if (!showControlBar || self.containerEntity.isPlayAudioOrVideoAtBegining)//如果一开始不显示frame，就不显示playbutton
        {
            videoPlayBtn.hidden = YES;
        }
    }
    return self;
}

- (void)playBtnClicked
{
    [self play];
}

- (void)tapVideo:(UITapGestureRecognizer *)gesture
{
    if (self.container.component != nil)
    {
        [self.container.component onTouchEndTouchUp];
        [self.container.component onTouch];
    }
    
}

-(void)stateChange:(NSNotification *)notif
{
    if (self.player.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self.container onPlay];//触发播放开始时事件 3.6
        [self preparePlay];
    }
    else if (self.player.playbackState == MPMoviePlaybackStatePaused)
    {
        [self preparePause];
    }
    else if(self.player.playbackState == MPMoviePlaybackStateStopped)
    {
        [self prepareStop];
    }
}

-(void) change:(NSNotification*)aNotification
{
    if ((self.player.playbackState == MPMoviePlaybackStateSeekingForward) || (self.player.playbackState == MPMoviePlaybackStateSeekingBackward))
    {
        busy = YES;
    }
}

-(void) playFinished
{
//    videoCoverImg.hidden = YES;//modified by Adward
    isExist = NO;       //陈星宇，12.9
    if (showControlBar)
    {
        videoPlayBtn.hidden = NO;
    }
    if(((VideoEntity*)self.container.entity).isAutoLoop == NO)
    {
        [self.container onPlayEnd];
    }
}

-(void) readyForPlay
{
    videoCoverImg.hidden = YES;     //陈星宇，12.9
    self.uicomponent.hidden = NO;
}

-(void) play
{
    //added by Adward 13-11-07
//    videoCoverImg.hidden = YES;
    if (!self.player)
    {
        //added by Adward 13-11-07
        NSURL *url = nil;
        if (self.isOnlineVideo)
        {
            url = [NSURL URLWithString:self.entity.dataid];
        }
        else
        {
            url =  [NSURL fileURLWithPath:self.filepath];
        }
        
//        self.uicomponent.hidden = YES;    //陈星宇，12.6
        if (!isExist)
        {
            localURL = url;
            isExist = YES;//一个页面只能播放一个视频
            self.player = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
            [self.uicomponent addSubview:self.player.view];
            [self.uicomponent bringSubviewToFront:videoCoverImg];
            [self.uicomponent bringSubviewToFront:videoPlayBtn];
            [self.player.view setFrame:self.uicomponent.bounds];
            
        }
//        else
//        {
//            self.player.contentURL = url;
//        }
        else
        {
            return;
        }
        self.player.shouldAutoplay = NO;
        if (showControlBar)
        {
            self.player.controlStyle = MPMovieControlStyleDefault;
        }
        else
        {
            self.player.controlStyle = MPMovieControlStyleNone;
            self.player.view.userInteractionEnabled = NO;
        }
        
        self.player.scalingMode  = MPMovieScalingModeFill;
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) //解决5.0视频播放崩溃
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyForPlay) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:self.player];
        }
        else
        {
            self.uicomponent.hidden = NO;
        }
        
        if(((VideoEntity*)self.container.entity).isAutoLoop)
        {
            self.player.repeatMode = MPMovieRepeatModeOne;
        }
//        [url release];
        
    }
    if (self.player != nil)
    {
//        if (self.player.playbackState == MPMoviePlaybackStatePlaying)
//        {
//            return;
//        }
        
        float delay = self.entity.delayCount;
        if (!isFirstTime)
        {
            delay = 0;
        }
        [self.container retain];
        [self performSelector:@selector(delayPlayVideo) withObject:nil afterDelay:delay];
    }
    [super play];
}

-(void)preparePlay
{
    videoPlayBtn.hidden = YES;
    isFirstTime = NO;
}

-(float)playerDuration//adward 12-30
{
    return self.player.duration;
}

- (void)delayPlayVideo
{
    [self preparePlay];
    [self.player play];
    float delay = .2;
    if (isFirstDelay)
    {
        isFirstDelay = NO;
        delay = .4;
    }
    [self performSelector:@selector(delayPlay) withObject:nil afterDelay:delay];
}

- (void)delayPlay
{
    self.player.view.hidden = NO;
    videoCoverImg.hidden = YES;
    
    [self.container onPlay];
    [self.container release];
}

-(void)prepareStop
{
    if (showControlBar)
    {
        videoPlayBtn.hidden = NO;
    }
    
    isFirstTime = YES;
    isExist = NO;
}

-(void) stop
{
    [self prepareStop];
    if (self.player != nil)
    {
        for (int i = 0; i < [self.container.entity.behaviors count]; i++)//如果视频没有播放完就切换页面 需要对结束后的背景音乐单独处理
        {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_AUDIO_VIDEO_END"] == YES)
            {
                if ([behavior.functionName isEqualToString:@"FUNCTION_PLAY_BACKGROUND_MUSIC"])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayBackgroundMusic" object:nil];
                }
            }
        }
        [self.player stop];
        [super stop];
        
    }
}

-(void)preparePause
{
    if (showControlBar)
    {
        videoPlayBtn.hidden = NO;
    }
    isExist = NO;
}

-(void)pause
{
    [self preparePause];
    if (self.player != nil)
    {
        [self.player pause];
        [super pause];
    }
}

-(void)show//modified by Adward 13-12-06 视频后面的交互
{
//    if (self.player)
//    {
//        if (self.player.view.superview.superview)
//        {
//            [self.superView addSubview:self.player.view.superview];
//        }
//    }
    self.player.view.hidden = NO;
}

- (void)hide
{
    if (self.player)
    {
        if (self.player.view.hidden == NO)
        {
//            if (self.player.view.superview.superview)//modified by Adward 13-12-06 视频后面的交互
//            {
//                self.superView  =   self.player.view.superview.superview;
//                [self.player.view.superview removeFromSuperview];
//            }
            self.player.view.hidden = YES;
        }
        self.uicomponent.hidden = YES;
    }
}

-(void)clean
{
     [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
}

- (void)dealloc
{
    self.entity = nil;
    isExist = NO;
    [self.player stop];
    [self.player.view removeFromSuperview];
    [self.uicomponent release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
