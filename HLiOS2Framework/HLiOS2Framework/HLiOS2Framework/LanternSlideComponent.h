//
//  LanternSlideComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "LanternSlideEntity.h"

@interface LanternSlideComponent : Component <UIGestureRecognizerDelegate>
{
    UIView *componentView;
    int curIndex;
    int loopCount;
    int curAdd;
    NSTimer *timer;
    BOOL isStopAutoPlay;
    BOOL isPlayAnimation;
    BOOL isPause;
    BOOL isContinue;
    BOOL isPlaying;
}

@property (nonatomic, retain)LanternSlideEntity *entity;
@property (nonatomic, retain)UIImageView *curShowImg;
@property (nonatomic, retain)UIImageView *nextShowImg;
@property (nonatomic, retain)UIImageView *tmpShowImg;


@end
