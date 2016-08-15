//
//  AFKFlip.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/16/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "FlipBaseController.h"
#import "AFKPageFlipper.h"
#import "PageController.h"

@class PageController;

@interface AFKFlip : FlipBaseController<AFKPageFlipperDataSource>
{
    AFKPageFlipper *pageFlipper;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic , retain) PageController *pageController;
@property (nonatomic , retain) AFKPageFlipper *pageFlipper;
@end
