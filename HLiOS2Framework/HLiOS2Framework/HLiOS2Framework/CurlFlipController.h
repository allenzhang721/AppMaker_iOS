//
//  CurlFlipController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-3.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "FlipBaseController.h"

@interface CurlFlipController : FlipBaseController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
{
    AVAudioPlayer *audioPlayer;
    BOOL isScrollCurl;
    BOOL isButtonSwipe;
}

@property (nonatomic , retain) PageController       *beforePageController;

@property (nonatomic , retain) PageController       *afterPageController;

@property (nonatomic , retain) PageController       *curPageController;

@property (nonatomic , retain) UIPageViewController *curlPageViewController;

@end
