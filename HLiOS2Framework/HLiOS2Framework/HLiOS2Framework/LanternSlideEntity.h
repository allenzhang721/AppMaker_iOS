//
//  LanternSlideEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

typedef enum HLAnimationType
{
    AnimationTypeFade,
    AnimationTypePush,
    AnimationTypeReveal,
    AnimationTypeMoveIn,
    AnimationTypeCubeEffect,
    AnimationTypeSuckEffect,
    AnimationTypeFlipEffect,
    AnimationTypeRippleEffect,
    AnimationTypePageCurl,
    AnimationTypePageUnCul
}MoueeAnimationType;

typedef enum HLAnimationDir
{
    HLAnimationDirLeft,
    HLAnimationDirRight,
    HLAnimationDirUp,
    HLAnimationDirDown,
    HLAnimationDirNon
}HLAnimationDir;

//added by Adward 13-11-26
typedef enum HLAnimatinoSwipeGestureDir
{
    HLAnimatinoSwipeGestureDirLeft,
    HLAnimatinoSwipeGestureDirRight,
    HLAnimatinoSwipeGestureDirUp,
    HLAnimatinoSwipeGestureDirDown,
    HLAnimatinoSwipeGestureDirNon
} HLAnimatinoSwipeGestureDir;

@interface LanternSlideEntity : HLContainerEntity

@property BOOL isAutoPlay;
@property BOOL isLoop;
@property BOOL isEndToStart;
@property BOOL isClickSwitch;
@property BOOL isSlideSwitch;
@property int loopCount;
@property (nonatomic, retain)NSMutableArray *showImgArr;
@property (nonatomic, retain)NSMutableArray *animationTypeArr;
@property (nonatomic, retain)NSMutableArray *animationDirArr;
@property (nonatomic, retain)NSMutableArray *animationDurationArr;  //每个item对应的动画时间长
@property (nonatomic, retain)NSMutableArray *animationDelayArr;
//added by Adward 13-11-26
@property (nonatomic, assign)HLAnimatinoSwipeGestureDir swipeDir;
@property (nonatomic, assign)BOOL isSwipe;
@end
