//
//  CurverFlipController.h
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-29.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "FlipBaseController.h"
#import "PageController.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface CurverFlipController : FlipBaseController
{
    AVAudioPlayer *audioPlayer;
    
    int curIndex;
    int curAdd;
}

@property (nonatomic , retain) PageController *pageController;



@end
