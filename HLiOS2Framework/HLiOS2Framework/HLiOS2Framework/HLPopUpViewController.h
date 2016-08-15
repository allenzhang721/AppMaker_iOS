//
//  MoueePopUpViewController.h
//  Waiyanshalong
//
//  Created by Mouee-iMac on 12-10-2.
//  Copyright (c) 2012年 Mouee-iMac. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum
{
    MJPopupViewAnimationSlideBottomTop = 1,
    MJPopupViewAnimationSlideRightLeft,
    MJPopupViewAnimationSlideLeftRight,
    MJPopupViewAnimationSlideBottomBottom,
    MJPopupViewAnimationFade
} MJPopupViewAnimation;

@interface HLPopUpViewController : UIViewController

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType;

@end
