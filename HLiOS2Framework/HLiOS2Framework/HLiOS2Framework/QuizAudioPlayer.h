//
//  QuizAudioPlayer.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/21/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "AudioButton.h"

@interface QuizAudioPlayer : UIView<AVAudioPlayerDelegate>

@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) NSTimer* processTimer;
@property (nonatomic,retain) AudioButton *audioBtn;

-(void) playMusic:(NSString *) filePath;
-(void) stopPlayMusic;
@end
