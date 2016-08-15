//
//  QuizAudioPlayer.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/21/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "QuizAudioPlayer.h"

@implementation QuizAudioPlayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.audioBtn = [[[AudioButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
        self.audioBtn.userInteractionEnabled = YES;
        [self addSubview:self.audioBtn];
        [self.audioBtn  addTarget:self action:@selector(onAudioBtn) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void) onAudioBtn
{
    if(self.audioPlayer.isPlaying)
    {
        [self stopPlayMusic];
    }
    else
    {
        [self.audioPlayer play];
         self.processTimer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [self.processTimer fire];
        self.audioBtn.image = [UIImage imageNamed:@"stop.png"];
        [self.audioBtn setNeedsLayout];
        [self.audioBtn setNeedsDisplay];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioPlayer.currentTime = 0;
     [self.audioBtn setProgress:0];
    [self stopPlayMusic];
    
}

-(void) playMusic:(NSString *) filePath
{
    [self.audioBtn setProgress:0.0f];
    if (self.audioPlayer != nil)
    {
        [self.audioPlayer stop];
    }
    if (self.processTimer != nil)
    {
        [self.processTimer invalidate];
    }
    self.processTimer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL] autorelease];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    self.audioPlayer.delegate = self;
    [self.processTimer fire];
    self.audioBtn.image = [UIImage imageNamed:@"stop.png"];
    [self.audioBtn setNeedsLayout];
    [self.audioBtn setNeedsDisplay];
}

-(void) update
{
    [self.audioBtn setProgress:self.audioPlayer.currentTime/self.audioPlayer.duration];
    [self.audioBtn setNeedsLayout];
    [self.audioBtn setNeedsDisplay];
}

-(void) stopPlayMusic
{
    if (self.audioPlayer != nil)
    {
        [self.audioPlayer stop];
        [self.processTimer invalidate];
    }
    self.audioBtn.image = [UIImage imageNamed:@"play.png"];
    [self.audioBtn setNeedsLayout];
    [self.audioBtn setNeedsDisplay];
}

- (void)dealloc
{
    [self stopPlayMusic];
    self.audioPlayer.delegate = nil;
    [self.audioPlayer release];
    [self.processTimer invalidate];
    [self.processTimer release];
    [self.audioBtn removeFromSuperview];
    [self.audioBtn release];
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
