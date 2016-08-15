//
//  Component.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"
#import "HLContainerEntity.h"

@class HLContainer;

@interface Component : NSObject
{
    UIView *uicomponent;
    HLContainer *container;
}

@property (nonatomic ,retain)  UIView     *uicomponent;
@property (assign)             HLContainer  *container;   //
@property (nonatomic , assign) HLContainerEntity *containerEntity;
@property Boolean hidden;
@property Boolean neeedCallStop;
@property BOOL isbyUserScale;                                          //陈星宇，11.19，图片放大可以移动

- (id)initWithEntity:(HLContainerEntity *) entity;


-(void) show;
-(void) beginView;
-(void) clean;
-(void) hide;
-(void) play;
-(void) stop;
-(void) change:(int)index;
-(void) pause;
-(void) playAll;
-(BOOL) onTouch;
-(void) onTouchBegin;
-(BOOL) onTouchEnd;
-(void) onTouchEndTouchUp;
-(BOOL) onTapGesture;//adward 3.6

-(void) onSwipeUp;
-(Boolean) isBusy;
-(void)unloadView;


@end
