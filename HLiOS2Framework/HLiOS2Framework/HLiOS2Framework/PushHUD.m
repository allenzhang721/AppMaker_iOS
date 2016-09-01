//
//  PushHUD.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 9/1/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushHUD.h"
#import "PushCell.h"
#import "PushController.h"

@interface CleardView : UIView

@end

@implementation CleardView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //    return false;
    for (UIView *v in self.subviews) {
        CGPoint p = [self convertPoint:point toView:v];
        if ([v pointInside:p withEvent:event]) {
            NSLog(@"%@ cleanrddd", NSStringFromClass(self.class));
            return true;
        }
    }
    return false;
}

@end

@interface PushView : UIView

- (void)show;

@end

@implementation PushView

- (void)show {
    UIView *p = [PushController newPushViewWithMessage:nil];
    CGSize size = [p sizeThatFits:self.superview.frame.size];
    CGRect f = p.frame;
    f.size = size;
    p.frame = f;

    [self addSubview:p];
    p.transform = CGAffineTransformMakeTranslation(0, -p.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        p.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 delay:4 options:0 animations:^{
                p.transform = CGAffineTransformMakeTranslation(0, -p.bounds.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    [p removeFromSuperview];
                }
            }];
        }
    }];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    //    return false;
//    for (UIView *v in self.subviews) {
//        CGPoint p = [self convertPoint:point toView:v];
//        if ([v pointInside:p withEvent:event]) {
//            NSLog(@"%@ cleanrddd", NSStringFromClass(self.class));
//            return true;
//        }
//    }
//    return false;
//}

@end

@interface PushHUD ()

@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) PushView *contentView;
@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel; // default is UIWindowLevelNormal

@end

@implementation PushHUD

+ (PushHUD*)shareInstance {
    static dispatch_once_t once;
    
    static PushHUD *share;
    dispatch_once(&once, ^{ share = [[self alloc] init];});
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxSupportedWindowLevel = UIWindowLevelNormal;
    }
    return self;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIView alloc] init];
        _overlayView.userInteractionEnabled = true;
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
//        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    // Update frame
    CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
    _overlayView.frame = windowBounds;
    
    return _overlayView;
}

- (PushView *)contentView {
    if(!_contentView) {
        _contentView = [[PushView alloc] init];
        _contentView.userInteractionEnabled = true;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor clearColor];
    }
    // Update frame
    CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
    _contentView.frame = windowBounds;
    
    return _contentView;
}

- (void)updateViewHierarchy {
    if(!self.overlayView.superview) {
        // Default case: iterate over UIApplication windows
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
            
            if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        // The HUD is already on screen, but maybot not in front. Therefore
        // ensure that overlay will be on top of rootViewController (which may
        // be changed during runtime).
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    
    // Add self to the overlay view
    if(!self.contentView.superview){
        [self.overlayView addSubview:self.contentView];
    }
    
    self.overlayView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
}

+ (void)show {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[PushHUD shareInstance] updateViewHierarchy];
        [[PushHUD shareInstance].contentView show];
    }];
}

+ (void)dismiss {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[PushHUD shareInstance].overlayView removeFromSuperview];
        [[PushHUD shareInstance].contentView removeFromSuperview];
    }];
}

@end

