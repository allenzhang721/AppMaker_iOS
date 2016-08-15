//
//  AFKFlip.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/16/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLFlipBaseController.h"
#import "AFKPageFlipper.h"
#import "HLPageController.h"

@class HLPageController;

@interface HLAFKFlip : HLFlipBaseController<AFKPageFlipperDataSource>
{
    AFKPageFlipper *pageFlipper;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic , retain) HLPageController *pageController;
@property (nonatomic , retain) AFKPageFlipper *pageFlipper;
@end
