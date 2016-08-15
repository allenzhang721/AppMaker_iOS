//
//  CurlFlipController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-3.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPageController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "HLFlipBaseController.h"

@interface HLCurlFlipController : HLFlipBaseController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
{
    AVAudioPlayer *audioPlayer;
    BOOL isScrollCurl;
    BOOL isButtonSwipe;
}

@property (nonatomic , retain) HLPageController       *beforePageController;

@property (nonatomic , retain) HLPageController       *afterPageController;

@property (nonatomic , retain) HLPageController       *curPageController;

@property (nonatomic , retain) UIPageViewController *curlPageViewController;

@end
