//
//  AudioComponent.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/*
 
 enum {
 MPMoviePlaybackStateStopped,
 MPMoviePlaybackStatePlaying,
 MPMoviePlaybackStatePaused,
 MPMoviePlaybackStateInterrupted,
 MPMoviePlaybackStateSeekingForward,
 MPMoviePlaybackStateSeekingBackward
 };
 typedef NSInteger MPMoviePlaybackState;
 
 */

#import "HLAudioComponent.h"
#import "AudioEntity.h"
#import "HLContainer.h"
#import "NSTimer+EMBlockTimer.h"

#define kAudioW 44
#define kAudioH 44
#define kMinDuration 1.5

#pragma mark -
#pragma mark -

@interface HLAudioComponent ()
{
    NSString *audiopath;
	AVPlayer *player;
    AVAudioPlayer *audioPlayer;
    UIButton *playBtn;
    CSSlider *slider;
    UIProgressView *progressV;
    
    NSTimer *_timer;
    
    UIImageView *playBtnView;
    UIImageView *stopBtnView;
    
    UIImageView *controlBarPlay;
    UIImageView *controlBarPause;
    UIImageView *controlBarBack;
    UIImageView *playerBack;
    UIImageView *playerProgress;
    UIImageView *progressDot;
    
    NSTimer *_valueChangeTimer;
    
    UILabel *timeLab;
    
    UISlider *progressSlider;
    
    NSURL *onlineUrl;
}

@end

@implementation HLAudioComponent

@synthesize audiopath;
@synthesize player;
@synthesize audioPlayer;
//@synthesize isPaused;
@synthesize musicTime;
@synthesize playBtnView;
@synthesize playerItem;

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity    = (AudioEntity *)entity;
        _sliderMoveing = NO;
        _isFirstTime   = YES;
        _isFirstPlay   = YES;
        _playing       = NO;
        _isPaused      = !entity.isPlayAudioOrVideoAtBegining;
        _autoLoop      = self.entity.isAutoLoop;
        
        [self P_initUI];        //Mr.chen, Init UI Method, 14.03.28

    }
    return self;
}

#pragma mark -
#pragma mark - Base Logic

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

-(void)delayPlayAudio
{
    _isFirstTime = NO;
    [self.player play];
    
    NSLog(@"_delayPlayAudio");
    
    if (_autoLoop) {
        
        if (_isFirstPlay) {
            
            [self.container onPlay];
        }
    } else {
        
        [self.container onPlay];
    }
    
    
    if (timeLab)
    {
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:0],[self timeChange:0],[self timeChange:0]];
    }
    
    if (_isFirstPlay)
    {
        [self loadStatus];
        _isFirstPlay = NO;
    }
    else
    {
        CALayer *playerLayer  = self.playBtnView.layer;
        [self resumeLayer:playerLayer];
    }
    [super play];
    
    _isPaused = NO;
    _playing  = YES;
    
    self.valueChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(slideValueChange:) userInfo:Nil repeats:YES];
    
    NSLog(@"%@", self.valueChangeTimer);
}

-(void) play    //停止或暂停 -> 播放
{
    NSLog(@"play");
    [self btPlay];
    
    if (_isPaused == YES)   //暂停
    {
        if (self.player != nil)
        {
            [self.player play];
            
            [self.container onPlay];
            
            if (self.playBtnView != nil) {
                CALayer *playerLayer  = self.playBtnView.layer;
                [self resumeLayer:playerLayer];
            }
            
            [self.valueChangeTimer setFireDate:[NSDate distantPast]];
            
//            self.valueChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(slideValueChange:) userInfo:Nil repeats:YES];
        }
        else
        {
            NSLog(@"_isPaused_P_initAudio");
            [self P_initAudio];
        }
    }
    else        //非暂停（播放，停止状态）
    {
        if (self.player) {
            
            if (_playing) {
                
                return;
                
            } else {
                
                if (_autoLoop) {
                    
                    if (_isFirstPlay) {
                        
                        [self.player play];
                        
                        [self.container onPlay];
                        
                    } else {
                        
                        [self.player play];
                    }
                }
            }
        }
        else
        {
            
            NSLog(@"_isPaused_P_initAudio");
            [self P_initAudio];
        }
    }
    
    if (timeLab)
    {
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:0],[self timeChange:0],[self timeChange:0]];
    }

    [super play];
    
    _isPaused = NO;
    _playing  = YES;
    
    
}

-(void) pause
{
    NSLog(@"pause");
    if (self.valueChangeTimer != nil )
    {
        if (self.valueChangeTimer.isValid == YES)
        {
            NSLog(@"%@", self.valueChangeTimer);
            [self.valueChangeTimer setFireDate:[NSDate distantFuture]];
        }
    }
    [self btPause];
    
    if (_isPaused == YES)
    {
        return;
    }
    
    if (self.player != nil)
    {
        [self.player pause];
    }
    else
    {
        AVURLAsset *movieAsset = [[[AVURLAsset alloc]initWithURL:[self musicUrl] options:nil] autorelease];
        self.playerItem        = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player            = [AVPlayer playerWithPlayerItem:self.playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        
        float delay = self.entity.delayCount;
        if (!_isFirstTime)
        {
            delay = 0;
        }
        //        [self.container retain];
        [self performSelector:@selector(delayPlayAudio) withObject:nil afterDelay:delay];
        self.musicTime = [self playerDuration];
        if (self.entity.isControlBarShow)
        {
            slider.maximumValue = self.musicTime;
        }
    }
    
    _isPaused = YES;

    CALayer *playerLayer = self.playBtnView.layer;
    [self pauseLayer:playerLayer];
}

-(void) stop
{
    NSLog(@"audio stop");
    [self btStop];
    
    if (self.valueChangeTimer != nil)
    {
        if (self.valueChangeTimer.isValid == YES)
        {
            [self.valueChangeTimer invalidate];
        }
    }
    
    _isFirstTime   = YES; //added by Adward 13-12-06音频停止后再播放也要延迟
//    self.isPaused = YES;
    _isPaused = NO;        //Mr.chen, /*reason*/,/*14.03.28*/
    _playing  = NO;
    if (self.entity.isControlBarShow)
    {
        slider.value = 0.0;
    }
    
    if (self.player != nil)
    {
        [super stop];
        
        self.player.rate = 0.0;
        self.player = Nil;
    }
    
    if (self.playBtnView)
    {
        [self.playBtnView stopAnimating];
    }
    
    _isFirstPlay = YES;
    
    if (timeLab)
    {
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:0],[self timeChange:0],[self timeChange:0]];
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    if (self.playBtnView.isAnimating)//12.23
    {
        [self.playBtnView stopAnimating];
    }
    
    if (_autoLoop) {
        
        _isFirstPlay = NO;
        
    } else {
        _isFirstPlay = YES;
    }
    
//    self.isPaused = YES;
    _isPaused = NO;        //Mr.chen, /*reason*/,/*14.03.28*/
    _playing  = NO;
    
    [self btStop];
    
    if (self.player)
    {
        self.player.rate = 0.0;
        self.player = nil;
    }
    
    if (self.entity.isControlBarShow)
    {
        slider.value = 0.0;
    }
    if(((AudioEntity*)self.container.entity).isAutoLoop == NO)
    {
        [self stop];         //Mr.chen, /*reason*/,/*14.03.28*/
        [self.container onPlayEnd];
    }
    else
    {
        [self play];
    }
    if (self.valueChangeTimer != nil )
    {
        if (self.valueChangeTimer.isValid == YES)
        {
            [self.valueChangeTimer invalidate];
        }
    }
    if (timeLab)
    {
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:0],[self timeChange:0],[self timeChange:0]];
    }
}

#pragma mark -
#pragma mark - Audio Icon Control

-(void)didTapGesture:(UIGestureRecognizer *)gesture
{
    if (_isPaused)
    {
        [self play];
    }
    else
    {
        [self pause];
    }
}

- (void)btPlay
{
    if (self.playBtnView != Nil && stopBtnView != nil)
    {
        self.playBtnView.hidden = NO;
        stopBtnView.hidden = YES;
    }
    
    if (controlBarPlay != nil)
    {
        controlBarPause.hidden = NO;
        controlBarPlay.hidden = YES;
    }
}

- (void)btPause
{
    if (self.playBtnView != Nil && stopBtnView != nil)
    {
        self.playBtnView.hidden = YES;
        stopBtnView.hidden = NO;
    }
    
    if (controlBarPlay != nil)
    {
        controlBarPause.hidden = YES;
        controlBarPlay.hidden = NO;
        
    }
}

- (void)btStop
{
    if (self.playBtnView != Nil && stopBtnView != nil)
    {
        self.playBtnView.hidden = YES;
        stopBtnView.hidden = NO;
    }
    
    if (controlBarPlay != nil)
    {
        controlBarPause.hidden = YES;
        controlBarPlay.hidden = NO;
    }
    
    if (timeLab)
    {
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",@"00",@"00",@"00",@"00"];
    }
}

-(void) playClick
{
    if(self.player.rate == 1.0)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

#pragma mark -
#pragma mark - Audio Bar Control

- (void)timerUpdate
{
    if (_sliderMoveing)
    {
        return;
    }
}

-(NSString *)timeChange:(int)time
{
    NSString *timeLab1;
    
    if (time < 10)
    {
        timeLab1 = [NSString stringWithFormat:@"0%d",time];
    }
    else
    {
        timeLab1 = [NSString stringWithFormat:@"%d",time];
    }
    return timeLab1;
}

- (void)valueChanged:(id)sender
{
    CMTime time = CMTimeMakeWithSeconds(slider.value, 1);
    [self.player seekToTime:time];
    
    if (fabs(slider.value - self.musicTime) <= 0.05)
    {
        [self stop];        //Mr.chen, /*item did play finish*/,/*14.3.28*/
        [self itemDidFinishPlaying:nil];
    }
}

-(float)playerCurrentTime
{
    CMTime duration = self.player.currentTime;
    return CMTimeGetSeconds(duration);
}

-(void)slideValueChange:(id)sender
{
    NSLog(@"slideValueChange");
    
//    NSLog(@"%@", self.valueChangeTimer);
    
    if (!_sliderMoveing) {
        
        if (self.entity.isControlBarShow && self.musicTime >0)
        {
            slider.value =  [self playerCurrentTime];
        }
        
        [self timeLabChange];
    }
}

-(void)timeLabChange
{
    int time    = self.musicTime;
    int timeNow = [self playerCurrentTime];

    int hour    = 0;
    int min     = 0;
    int sec     = 0;

    int hourNow = 0;
    int minNow  = 0;
    int secNow  = 0;
    
    if (time >= 60 && time <= 3600)
    {
        
        if (timeNow >= 60 && timeNow < 3600)
        {
            minNow = (int)timeNow / 60.0;
            secNow = (int)((int)timeNow %60);
        }
        else if(timeNow < 60)
        {
            secNow = (int)timeNow;
        }
        else if (timeNow >3600)
        {
            hourNow = (int)timeNow / 3600;
            minNow  = (timeNow - hourNow) / 60;
            secNow  = (int)(timeNow - hourNow) % 60;
        }
        
        min          = (int)time / 60.0;
        sec          = (int)((int)time%60);
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:minNow],[self timeChange:secNow],[self timeChange:min],[self timeChange:sec]];
    }
    else if (time < 60)
    {
        secNow       = (int)timeNow;
        sec          = (int)time;
        timeLab.text = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:secNow],[self timeChange:0],[self timeChange:sec]];
    }
    else if (time > 3600)
    {
        if (timeNow >= 60 && timeNow < 3600)
        {
            minNow = (int)timeNow / 60.0;
            secNow = (int)((int)timeNow %60);
        }
        else if(timeNow < 60)
        {
            secNow = (int)timeNow;
        }
        else if (timeNow >3600)
        {
            hourNow = (int)timeNow / 3600;
            minNow  = (timeNow - hourNow) / 60;
            secNow  = (int)(timeNow - hourNow) % 60;
        }
        
        hour         = (int)time / 3600;
        min          = (time - hour) / 60;
        sec          = (int)(time - hour) % 60;
        timeLab.text = [NSString stringWithFormat:@"%@:%@:%@/%@:%@:%@",[self timeChange:hourNow],[self timeChange:minNow],[self timeChange:secNow],[self timeChange:hour],[self timeChange:min],[self timeChange:sec]];
    }
}

- (void)touchUp:(id)sender
{
    _sliderMoveing = NO;
    
    if (self.player) {
        
        if (_playing) {
            
            [self.player play];
            [self btPlay];
        }
    }
    
    if (self.player.rate == 1.0)
    {
        self.valueChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(slideValueChange:) userInfo:Nil repeats:YES];
    }
}

- (void)touchDown:(id)sender
{
    _sliderMoveing = YES;
    
    if (self.player) {
        
        if (_playing) {
            
            [self.player pause];
            [self btPause];
        }
    }
    
    self.valueChangeTimer.fireDate = [NSDate distantFuture];
    
    if (self.valueChangeTimer != Nil)
    {
        [self.valueChangeTimer retain];
        if (self.valueChangeTimer.isValid == YES)
        {
            [self.valueChangeTimer invalidate];
        }
    }
    
    self.valueChangeTimer = nil;        //Mr.chen, reason, 14.03.28
}

#pragma mark -
#pragma mark - Private Method

- (void)P_initUI
{
    if (self.entity.isControlBarShow)//ControlBar
    {
        // Init With Aduio Control Bar
        UIView *view            = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.entity.width floatValue], [self.entity.height floatValue])] autorelease];
        view.layer.cornerRadius = 8;
        self.uicomponent        = view;
        
        view.backgroundColor = [UIColor darkGrayColor];
//        controlBarBack                          = [[UIImageView alloc]initWithFrame:self.uicomponent.bounds];
//        controlBarBack.image                    = [UIImage imageNamed:@"playerBack"];
//        [self.uicomponent addSubview:controlBarBack];
//        controlBarBack.userInteractionEnabled   = YES;
        
//        controlBarPause                         = [[UIImageView alloc]initWithFrame:CGRectMake(10,0,30,30)];
//        controlBarPause.center                  = CGPointMake(25, [self.entity.height floatValue]/2);
        
        // 暂停按钮。
        CGRect pauseFrame = CGRectMake(5, CGRectGetHeight(view.bounds) / 2 - 30/2, 30, 30);
        controlBarPause = [[UIImageView alloc] initWithFrame:pauseFrame];
        controlBarPause.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        controlBarPause.image                   = [UIImage imageNamed:@"controlBarPause"];
        controlBarPause.hidden                  = YES;
        [self.uicomponent addSubview:controlBarPause];
        [controlBarPause addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)] autorelease]];
        controlBarPause.userInteractionEnabled  = YES;
        
//        controlBarPlay                          = [[UIImageView alloc]initWithFrame:CGRectMake(10,0,30,30)];
//        controlBarPlay.center                   = CGPointMake(25, [self.entity.height floatValue]/2);
        // 播放按钮。
        CGRect playFrame = CGRectMake(5, CGRectGetHeight(view.bounds) / 2 - 30/2, 30, 30);
        controlBarPlay = [[UIImageView alloc] initWithFrame:playFrame];
        controlBarPlay.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        controlBarPlay.image                    = [UIImage imageNamed:@"controlBarPlay"];
        [self.uicomponent addSubview:controlBarPlay];
        [controlBarPlay addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)] autorelease]];
        controlBarPlay.userInteractionEnabled   = YES;
        
//        slider                                  = [[CSSlider alloc] initWithFrame:CGRectMake(45, 0, [self.entity.width floatValue] - 200, 30 )];
//        slider.center                           = CGPointMake([self.entity.width floatValue] / 2 - 50, [self.entity.height floatValue]/2);
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize textSize = [@"00:00/00:00" sizeWithFont:font];
        
        // 滑动条
        CGRect sliderFrame = CGRectMake(CGRectGetMaxX(controlBarPlay.frame),
                                        CGRectGetHeight(view.bounds) / 2 - 30/2,
                                        CGRectGetWidth(view.bounds) - CGRectGetMaxX(controlBarPlay.frame) - 5 - 10- textSize.width,
                                        30);
        slider = [[CSSlider alloc] initWithFrame:sliderFrame];
        slider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        slider.value                            = 0;
        slider.continuous                       = NO;
        slider.minimumValue                     = 0;
        [slider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
        [slider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [slider addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [slider setThumbImage:[UIImage imageNamed:@"progressDot.png"] forState:UIControlStateNormal];
        slider.minimumTrackTintColor            = [UIColor whiteColor];
        [self.uicomponent addSubview:slider];
        
        // 时间。
        CGRect timelabFrame = CGRectMake(CGRectGetMaxX(sliderFrame) + 5 ,
                                         CGRectGetHeight(view.bounds) / 2 - textSize.height/2,
                                         textSize.width, textSize.height);
        
        timeLab                                 = [[UILabel alloc]initWithFrame:timelabFrame];
        timeLab.font = font;
        timeLab.textAlignment = NSTextAlignmentRight;
        timeLab.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        timeLab.center                          = CGPointMake([self.entity.width floatValue] - 120 + 50, [self.entity.height floatValue]/2);
        timeLab.textColor                       = [UIColor whiteColor];
        timeLab.backgroundColor                 = [UIColor clearColor];//兼容iOS5 adward 2.18
        timeLab.text                            = [NSString stringWithFormat:@"%@:%@/%@:%@",[self timeChange:0],[self timeChange:0],[self timeChange:0],[self timeChange:0]];
        [self.uicomponent addSubview:timeLab];
    }
    else
    {
        // Init With Audio Icon
        UIView *view                            = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAudioW, kAudioH)] autorelease];
        self.uicomponent                        = view;
        self.playBtnView                        = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAudioW, kAudioH)];
        
        self.playBtnView.userInteractionEnabled = YES;
        self.playBtnView.image                  = [UIImage imageNamed:@"jz_ (1).png"];
        [self.playBtnView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)] autorelease]];
        [self.uicomponent addSubview:self.playBtnView];
        
        stopBtnView                             = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAudioW, kAudioH)];
        stopBtnView.image                       = [UIImage imageNamed:@"audioPlay.png"];
        [self.uicomponent addSubview:stopBtnView];
        [stopBtnView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)] autorelease]];
        stopBtnView.userInteractionEnabled      = YES;
    }
}

- (void)P_initAudio
{
    AVURLAsset *movieAsset = [[[AVURLAsset alloc]initWithURL:[self musicUrl] options:nil] autorelease];
    self.playerItem        = [AVPlayerItem playerItemWithAsset:movieAsset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.player            = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    float delay            = self.entity.delayCount;
    if (!_isFirstTime)
    {
        delay                  = 0;
    }
    //            [self.container retain];
    //            NSLog(@"delay:%f",delay);
    [self performSelector:@selector(delayPlayAudio) withObject:nil afterDelay:delay];
    self.musicTime         = [self playerDuration];
    if (self.entity.isControlBarShow)
    {
        slider.maximumValue    = self.musicTime;
    }
}

-(NSURL *)musicUrl
{
    NSURL *url = nil;
    if (self.entity.isOnlineSource == NO)
    {
        self.audiopath = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
        url            = [NSURL fileURLWithPath:self.audiopath];
    }
    else
    {
        url = [NSURL URLWithString:self.entity.dataid];
    }
    NSLog(@"url:%@",url);
    return url;
}

-(double)playerDuration
{
    NSURL *musicURL = [[self musicUrl] copy];
    NSData *data =[NSData dataWithContentsOfURL:musicURL];
    [musicURL release];
    
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithData:data error:nil] autorelease];
//    self.audioPlayer.numberOfLoops = 0;        //Mr.chen, /*reason*/,/*date*/
//    self.audioPlayer.delegate      = self;
//    [self.audioPlayer prepareToPlay];
    if (self.audioPlayer.duration > kMinDuration)
    {
        return self.audioPlayer.duration;
    }
    else
        return kMinDuration;
}

-(void)loadStatus
{
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:1];
    for (int i = 2; i <= 61; i++)
    {
        NSString * imageName = [NSString stringWithFormat:@"jz_  (%d).png",i];
        UIImage * image = [UIImage imageNamed:imageName];
        
        if (image != nil) {
            
            [images addObject:image];
        } else {
            
            NSLog(@"Lost the Audio material");
        }
    }
    if (self.playBtnView)
    {
        self.playBtnView.animationImages = images;
        
        double duration = self.musicTime;
        self.playBtnView.animationDuration = duration;
        
        [self.playBtnView startAnimating];
    }
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime     = [layer timeOffset];
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    layer.beginTime               = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
}

/* 状态 */
-(void)clean
{
    [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc
{
    [self clean];
    
    self.entity = nil;
    if(self.player != nil)
    {
        self.player = nil;
    }
    [self.uicomponent release];
    if (self.audiopath != nil)
    {
        [self.audiopath release];
    }
    if (_valueChangeTimer) {
        
        _valueChangeTimer.fireDate = [NSDate distantFuture];        //Mr.chen, reason, 14.03.28
        [_valueChangeTimer invalidate];
//        [_valueChangeTimer release];
    }
   
    
    [controlBarPlay release];
    [controlBarPause release];
    [controlBarBack release];
    [slider release];
    [timeLab release];
    [playBtnView release];
    [stopBtnView release];
    [super dealloc];
}

@end
