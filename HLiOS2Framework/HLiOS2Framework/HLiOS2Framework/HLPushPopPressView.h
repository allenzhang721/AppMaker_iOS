//
//  MoueePushPopPressView.h
//  MoueePushPopPressView
//
//  Based on BSSPushPopPressView by Blacksmith Software.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class HLPushPopPressView;

@protocol HLPushPopPressViewDelegate <NSObject>
@optional

/// manipulation starts, user has >= 2 fingers on the view
- (void)pushPopPressViewDidStartManipulation:(HLPushPopPressView *)pushPopPressView;

/// manipulation stopps, user has < 2 fingers on the view
- (void)pushPopPressViewDidFinishManipulation:(HLPushPopPressView *)pushPopPressView;

/// view will animate back to original frame
- (void)pushPopPressViewWillAnimateToOriginalFrame:(HLPushPopPressView *)pushPopPressView duration: (NSTimeInterval)duration;

/// animation to original frame is finished
- (void)pushPopPressViewDidAnimateToOriginalFrame:(HLPushPopPressView *)pushPopPressView;

- (void)pushPopPressViewWillAnimateToFullscreenWindowFrame:(HLPushPopPressView *)pushPopPressView duration: (NSTimeInterval)duration;
- (void)pushPopPressViewDidAnimateToFullscreenWindowFrame:(HLPushPopPressView *)pushPopPressView;

- (BOOL)pushPopPressViewShouldAllowTapToAnimateToOriginalFrame:(HLPushPopPressView *)pushPopPressView;
- (BOOL)pushPopPressViewShouldAllowTapToAnimateToFullscreenWindowFrame:(HLPushPopPressView *)pushPopPressView;

/// only active if allowSingleTapSwitch is enabled (default)
- (void)pushPopPressViewDidReceiveTap:(HLPushPopPressView *)pushPopPressView;

- (void)beginPinch;
- (void)endPinch;

@end

@interface HLPushPopPressView : UIView <UIGestureRecognizerDelegate> {
    UITapGestureRecognizer* tapRecognizer_;
    UILongPressGestureRecognizer* doubleTouchRecognizer;
    UIPanGestureRecognizer* panRecognizer_;
    CGAffineTransform scaleTransform_;
    CGAffineTransform rotateTransform_;
    CGAffineTransform panTransform_;
    CGRect initialFrame_;
	NSInteger initialIndex_;
    BOOL allowSingleTapSwitch_;
    BOOL fullscreen_;
    BOOL ignoreStatusBar_;
	BOOL keepShadow_;
    BOOL fullscreenAnimationActive_;
    BOOL anchorPointUpdated;
}

/// the delegate for the PushPopPressView
@property (nonatomic, unsafe_unretained) id<HLPushPopPressViewDelegate> pushPopPressViewDelegate;

/// returns true if fullscreen is enabled
@property (nonatomic, readonly, getter=isFullscreen) BOOL fullscreen;

/// true if one or more fingers are on the view
@property (nonatomic, readonly, getter=isBeingDragged) BOOL beingDragged;

/// set initialFrame if you change frame after initWithFrame
@property (nonatomic, assign) CGRect initialFrame;

/// allow mode switching via single tap. Defaults to YES.
@property (nonatomic, assign) BOOL allowSingleTapSwitch;

/// if true, [UIScreen mainScreen] is used for coordinates (vs rootView)
@property (nonatomic, assign) BOOL ignoreStatusBar;

/// if true, shadow does not appear/disappear when animating
@property (nonatomic, assign) BOOL keepShadow;

@property (nonatomic, assign) UIViewController *rootViewController;

/// animate/move to fullscreen
- (void)moveToFullscreenWindowAnimated:(BOOL)animated;

/// animate/moves to initialFrame size
- (void)moveToOriginalFrameAnimated:(BOOL)animated;

/// align view based on current size (either initialPosition or fullscreen)
- (void)alignViewAnimated:(BOOL)animated bounces:(BOOL)bounces;

@end
