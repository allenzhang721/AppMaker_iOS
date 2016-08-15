//
//  AudioComponent.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Component.h"
#import "AudioEntity.h"
#import "CSSlider.h"

@interface HLAudioComponent : Component<AVAudioPlayerDelegate>

#pragma mark -
#pragma mark - Object

@property (nonatomic, retain)AudioEntity   *entity;
@property (nonatomic, retain)NSString      *audiopath;
@property (nonatomic, retain)AVPlayer      *player;
@property (nonatomic, retain)AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)AVPlayerItem  *playerItem;
@property (nonatomic, retain)NSTimer       *valueChangeTimer;
@property (nonatomic, retain)UIImageView   *playBtnView;

#pragma mark -
#pragma mark - Value

@property (nonatomic, assign)float         musicTime;

#pragma mark -
#pragma mark - State Tag

@property (nonatomic, assign)BOOL          playing;        //Mr.chen,  add 'Playing' state tag,  14.03.28
@property (nonatomic, assign)BOOL          autoLoop;        //Mr.chen, add 'autoPlay' state tag , 14.03.28
@property (nonatomic, assign)BOOL          sliderMoveing;
@property (nonatomic, assign)BOOL          isFirstTime;
@property (nonatomic, assign)BOOL          isFirstPlay;     //控制播放 暂停
@property (nonatomic, assign)BOOL          isPaused;

#pragma mark -
#pragma mark - Public Method

- (void)clean;
- (void)valueChanged:(id)sender;
- (void)touchUp:(id)sender;
- (void)touchDown:(id)sender;
- (double)playerDuration;

@end
